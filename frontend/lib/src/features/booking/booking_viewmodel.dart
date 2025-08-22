import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../core/network/api_client.dart';
import 'booking_service.dart';
import 'seat_models.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingService _service;
  BookingViewModel(ApiClient api) : _service = BookingService(api);

  String? movieId;
  String? hallId;
  String? showtimeId;

  SeatMap? seatMap;
  bool loading = false;
  String? error;

  final Set<String> selected = {};
  Reservation? currentReservation;

  Timer? _pollTimer;
  bool _disposed = false;

  void _safeNotify() {
    if (_disposed || !hasListeners) return;
    final phase = SchedulerBinding.instance.schedulerPhase;
    switch (phase) {
      case SchedulerPhase.idle:
        // Safe to notify immediately
        // ignore: invalid_use_of_protected_member
        notifyListeners();
        break;
      default:
        // Defer to after current frame to avoid notifying during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_disposed) return;
          // ignore: invalid_use_of_protected_member
          notifyListeners();
        });
    }
  }

  Future<void> init(
      {required String movieId,
      required String hallId,
      required String showtimeId}) async {
    this.movieId = movieId;
    this.hallId = hallId;
    this.showtimeId = showtimeId;
    await refreshSeatMap();
    _startPolling();
  }

  Future<void> refreshSeatMap() async {
    if (hallId == null || showtimeId == null) return;
    loading = true;
    error = null;
    _safeNotify();
    try {
      seatMap = await _service.fetchSeatMap(hallId!, showtimeId!);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      _safeNotify();
    }
  }

  void toggleSeat(String seatId) {
    if (seatMap == null) return;
    final status = seatMap!.seats[seatId]?.status;
    if (status != SeatStatus.available && !selected.contains(seatId))
      return; // cannot newly add non-available
    if (selected.contains(seatId)) {
      selected.remove(seatId);
    } else {
      selected.add(seatId);
    }
    _safeNotify();
  }

  Future<bool> holdSelected() async {
    if (hallId == null || showtimeId == null || selected.isEmpty) return false;
    try {
      final res = await _service.holdSeats(
          hallId: hallId!, showtimeId: showtimeId!, seats: selected.toList());
      currentReservation = res;
      await refreshSeatMap();
      return true;
    } catch (e) {
      error = e.toString();
      _safeNotify();
      return false;
    }
  }

  Future<bool> confirm() async {
    if (currentReservation == null) return false;
    try {
      final res = await _service.confirmReservation(
        reservationId: currentReservation!.id,
        hallId: hallId!,
        showtimeId: showtimeId!,
        seats: currentReservation!.seats,
      );
      currentReservation = res;
      await refreshSeatMap();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> release() async {
    if (currentReservation == null) return;
    try {
      await _service.releaseReservation(
        reservationId: currentReservation!.id,
        hallId: hallId!,
        showtimeId: showtimeId!,
        seats: currentReservation!.seats,
      );
      currentReservation = null;
      selected.clear();
      await refreshSeatMap();
    } catch (e) {
      error = e.toString();
      _safeNotify();
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      try {
        await refreshSeatMap();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _disposed = true;
    super.dispose();
  }
}
