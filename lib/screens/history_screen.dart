import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F5F9),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "History",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            /// HEADER CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.history,
                          color: Color(0xFF2F6BFF)),
                      SizedBox(width: 8),
                      Text(
                        "Session history",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Review previous symptom checks. This is local UI demo data for now.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// SEARCH BOX
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search past sessions",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 22),

            /// SESSION 1
            historyCard(
              title: "Dry cough + sore throat • 2 days",
              date: "19/2/2026, 5:02:37 PM",
              urgency: "Low",
              color: const Color(0xFF22C55E),
            ),

            const SizedBox(height: 14),

            /// SESSION 2
            historyCard(
              title: "Rash on forearm • itching",
              date: "12/2/2026, 3:02:37 PM",
              urgency: "Medium",
              color: const Color(0xFFF59E0B),
            ),
          ],
        ),
      ),
    );
  }

  static Widget historyCard({
    required String title,
    required String date,
    required String urgency,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(Icons.monitor_heart,
              color: Color(0xFF2F6BFF)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight:
                            FontWeight.w600)),
                const SizedBox(height: 4),
                Text(date,
                    style: const TextStyle(
                        color:
                            Color(0xFF6B7280))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Text(
              "Urgency: $urgency",
              style: TextStyle(
                color: color,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}