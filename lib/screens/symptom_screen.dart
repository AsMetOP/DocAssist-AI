import 'package:flutter/material.dart';
import 'results_screen.dart';

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final TextEditingController symptomsController =
      TextEditingController();
  final TextEditingController durationController =
      TextEditingController();
  final TextEditingController severityController =
      TextEditingController();
  final TextEditingController bodyAreaController =
      TextEditingController();

  void goToResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          symptom: symptomsController.text,
        ),
      ),
    );
  }

  Widget buildField({
    required String label,
    required String hint,
    TextEditingController? controller,
    bool isOptional = false,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              if (isOptional)
                const Text("Optional",
                    style: TextStyle(
                        color: Color(0xFF6B7280)))
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xFFF3F5F9),
              contentPadding:
                  const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget attachmentButton(
      {required IconData icon,
      required String label}) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEAF0FF),
          foregroundColor: const Color(0xFF2F6BFF),
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {},
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        title: const Text("Symptom Check"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF3F5F9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            /// READY CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FF),
                borderRadius:
                    BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFF2F6BFF)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Ready\nShare what you feel. Attach photos, audio (cough/breath), or a short video if it helps. This is informational only.",
                      style: TextStyle(
                          color: Color(0xFF1F2937)),
                    ),
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2F6BFF),
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 22),

            buildField(
              label: "Describe symptoms",
              hint:
                  "E.g., sore throat, dry cough, mild fever...",
              controller: symptomsController,
              maxLines: 4,
            ),

            const SizedBox(height: 18),

            buildField(
              label: "Duration",
              hint: "2 days",
              controller: durationController,
              isOptional: true,
            ),

            const SizedBox(height: 18),

            buildField(
              label: "Severity",
              hint: "Mild / Moderate / Severe",
              controller: severityController,
              isOptional: true,
            ),

            const SizedBox(height: 18),

            buildField(
              label: "Body area",
              hint:
                  "Chest, abdomen, left knee...",
              controller: bodyAreaController,
              isOptional: true,
            ),

            const SizedBox(height: 22),

            /// ATTACHMENTS
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Attachments",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Add images, audio, or video. (No recording yet — upload files)",
                    style: TextStyle(
                        color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      attachmentButton(
                          icon:
                              Icons.image_outlined,
                          label: "Image"),
                      const SizedBox(width: 12),
                      attachmentButton(
                          icon:
                              Icons.graphic_eq_outlined,
                          label: "Audio"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFEAF0FF),
                      foregroundColor:
                          const Color(0xFF2F6BFF),
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(
                              vertical: 16),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(16),
                      ),
                    ),
                    onPressed: () {},
                    icon:
                        const Icon(Icons.videocam),
                    label: const Text("Video"),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "No attachments added",
                    style: TextStyle(
                        color: Color(0xFF9CA3AF)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// WORKING BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF2F6BFF),
                  padding:
                      const EdgeInsets.symmetric(
                          vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
                onPressed: goToResults,
                icon: const Icon(Icons.send_outlined),
                label: const Text("Working"),
              ),
            )
          ],
        ),
      ),
    );
  }
}