import 'package:flutter/material.dart';
import 'package:doc_assist/core//theme.dart';
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
      padding: const EdgeInsets.all(22),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.softBlue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: AppTheme.primary),
          ),
          const SizedBox(height: 18),
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(
                color: AppTheme.textGrey,
                height: 1.5,
              )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.softBlue,
                foregroundColor: AppTheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
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
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: ListView(
            children: [
              const Text(
                "DocAssist AI",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "A calm, non-diagnostic medical assistant for understanding symptoms and managing health records.",
                style: TextStyle(
                  color: AppTheme.textGrey,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: actionCard(
                      icon: Icons.monitor_heart_outlined,
                      title: "Analyze Symptoms",
                      subtitle:
                      "Describe what you feel and attach media if helpful.",
                      buttonText: "Start",
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
                  const SizedBox(width: 20),
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
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "View Documents",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Search, filter, and review your stored health records.",
                      style:
                      TextStyle(color: AppTheme.textGrey),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.softBlue,
                          foregroundColor: AppTheme.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DocumentScreen(),
                            ),
                          );
                        },
                        child: const Text("Open vault"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}