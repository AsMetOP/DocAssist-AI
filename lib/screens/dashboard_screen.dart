import 'package:flutter/material.dart';
import 'symptom_screen.dart';
import 'upload_screen.dart';
import 'document_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF2F6BFF)),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(
                  color: Color(0xFF6B7280))),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAF0FF),
                foregroundColor: const Color(0xFF2F6BFF),
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onTap,
              child: Text(buttonText),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [

              const Text("Doccy",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),

              const Text(
                "A calm, non-diagnostic medical assistant for understanding symptoms and managing health records.",
                style: TextStyle(color: Color(0xFF6B7280)),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: actionCard(
                      icon: Icons.monitor_heart_outlined,
                      title: "Analyze Symptoms",
                      subtitle:
                      "Describe what you feel and attach media if helpful.",
                      buttonText: "Start →",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                              const SymptomScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: actionCard(
                      icon: Icons.upload_file_outlined,
                      title: "Upload Medical Data",
                      subtitle:
                      "Add lab results, scans, prescriptions, and more.",
                      buttonText: "Upload",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                              const UploadScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text("View Documents",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text(
                      "Search, filter, and review your stored health records.",
                      style: TextStyle(
                          color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF2F6BFF),
                          padding:
                          const EdgeInsets.symmetric(
                              vertical: 15),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                const DocumentsScreen()),
                          );
                        },
                        child: const Text(
                          "Open vault →",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  "This app is not a medical diagnostic tool and cannot replace professional medical advice. For emergencies call your local emergency number.",
                  style: TextStyle(
                      color: Color(0xFF6B7280)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}