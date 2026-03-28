import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResultProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  Future<void> saveResult({
    required String symptoms,
    required Map<String, dynamic> result,
  }) async {
    final predictions = result["top_predictions"] ?? [];
    final guidance = result["structured_guidance"] ?? {};

    final topDisease =
    predictions.isNotEmpty ? predictions[0]["disease"] : "Unknown";

    final confidence =
    predictions.isNotEmpty ? predictions[0]["confidence"] : 0.0;

    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return;

    await supabase.from('ai_results').insert({
      'user_id': userId,
      'symptoms': symptoms,
      'top_disease': topDisease,
      'confidence': confidence,
      'urgency': guidance["urgency"],
      'doctor': guidance["doctor"],
      'advice': guidance["advice"],
      'full_result': result,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}