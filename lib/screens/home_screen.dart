import 'package:flutter/material.dart';
import 'upload_screen.dart';
import 'document_screen.dart';
import 'symptom_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigate(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Doc Assist",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            dashboardCard(
              icon: Icons.monitor_heart_outlined,
              title: "Symptom Check",
              subtitle: "Analyze symptoms with AI assistance",
              color: Colors.blue,
              onTap: () => navigate(context, const SymptomScreen()),
            ),

            const SizedBox(height: 18),

            dashboardCard(
              icon: Icons.camera_alt_outlined,
              title: "Upload Medical Data",
              subtitle: "Capture prescriptions or reports",
              color: Colors.green,
              onTap: () => navigate(context, const UploadScreen()),
            ),

            const SizedBox(height: 18),

            dashboardCard(
              icon: Icons.folder_open_outlined,
              title: "Document Vault",
              subtitle: "View and manage uploaded files",
              color: Colors.deepPurple,
              onTap: () => navigate(context, const DocumentsScreen()),
            ),

            const SizedBox(height: 18),

            dashboardCard(
              icon: Icons.history,
              title: "Analysis History",
              subtitle: "Review previous symptom checks",
              color: Colors.orange,
              onTap: () {},
            ),

          ],
        ),
      ),
    );
  }
}