import 'package:flutter/material.dart';
import 'package:doc_assist/core/theme.dart';

class ResultsScreen extends StatelessWidget {
  final String symptom;
  final String duration;
  final String severity;
  final String bodyArea;
  final Map<String, dynamic>? result;

  const ResultsScreen({
    super.key,
    required this.symptom,
    this.duration = "",
    this.severity = "",
    this.bodyArea = "",
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    final guidance = result?["structured_guidance"] ?? {};
    final predictions = result?["top_predictions"] ?? [];

    final urgency = guidance["urgency"] ?? "Unknown";
    final firstAid = result?["first_aid"];
    final severityFromImage = result?["severity"];
    final recommendation = firstAid ?? guidance["recommendation"] ?? "Consult a clinician.";
    final doctor = guidance["doctor"] ?? "General Physician";
    final advice = guidance["advice"] ?? "Rest and monitor symptoms.";

    Color urgencyColor = Colors.green;
    if (urgency == "Medium") urgencyColor = Colors.orange;
    if (urgency == "High") urgencyColor = Colors.red;

    final topDisease =
    predictions.isNotEmpty ? predictions[0]["disease"] : "Unknown";
    final topConfidence =
    predictions.isNotEmpty ? (predictions[0]["confidence"] as num).toDouble() : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: ListView(
            children: [
              InkWell(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, size: 18),
                    SizedBox(width: 6),
                    Text("Back"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "AI Health Analysis",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// TOP RESULT CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Most Likely Condition",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      topDisease,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: topConfidence,
                      minHeight: 8,
                      backgroundColor: Colors.grey.withOpacity(.2),
                      valueColor:
                      const AlwaysStoppedAnimation(AppTheme.primary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Confidence ${(topConfidence * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// GUIDANCE CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Medical Guidance",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text("Symptoms: $symptom"),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: urgencyColor.withOpacity(.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Urgency: $urgency",
                        style: TextStyle(
                          color: urgencyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    if (severityFromImage != null) ...[
                      Text("Injury Severity: $severityFromImage"),
                      const SizedBox(height: 10),
                    ],

                    Text("Recommended Doctor: $doctor"),
                    const SizedBox(height: 10),
                    Text("Advice: $advice"),
                    const SizedBox(height: 10),
                    Text(
                      firstAid != null
                          ? "First Aid: $recommendation"
                          : "Recommendation: $recommendation",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Other Possible Conditions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 14),

              ...predictions.skip(1).map<Widget>((item) {
                final disease = item["disease"];
                final confidence = (item["confidence"] as num).toDouble();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: diseaseCard(disease, confidence),
                );
              }).toList(),

              const SizedBox(height: 20),

              /// DISCLAIMER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Disclaimer: This is an AI-assisted prediction and not a medical diagnosis.",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget diseaseCard(String disease, double confidence) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_services, color: AppTheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  disease,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                "${(confidence * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: confidence,
            minHeight: 8,
            backgroundColor: Colors.grey.withOpacity(.2),
            valueColor:
            const AlwaysStoppedAnimation(AppTheme.primary),
          ),
        ],
      ),
    );
  }
}