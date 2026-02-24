import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final String symptom;

  const ResultsScreen({super.key, required this.symptom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F5F9),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios,
                size: 16, color: Colors.black),
            label: const Text("Back",
                style: TextStyle(color: Colors.black)),
          ),
        ),
        title: const Text(
          "Results",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            /// STRUCTURED GUIDANCE CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Row(
                    children: const [
                      Icon(Icons.favorite_border,
                          color: Color(0xFF2F6BFF)),
                      SizedBox(width: 8),
                      Text(
                        "Structured guidance",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )
                    ],
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Informational only — not a diagnosis.",
                    style:
                        TextStyle(color: Color(0xFF6B7280)),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "“$symptom”",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Duration: 10 days • Severity: Severe • Body area: Neck • Attachments: 0",
                    style:
                        TextStyle(color: Color(0xFF6B7280)),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          Colors.red.withOpacity(.1),
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                    child: const Text(
                      "Urgency: High",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight:
                              FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF0FF),
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                    child: const Text(
                      "Recommended: Primary care / Pulmonology",
                      style: TextStyle(
                          color:
                              Color(0xFF2F6BFF),
                          fontWeight:
                              FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// POSSIBLE CONDITIONS SECTION
            const Text(
              "Possible conditions",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "These are general possibilities based on your input. A clinician can confirm with history, exam, and tests.",
              style:
                  TextStyle(color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 18),

            conditionCard(
              title:
                  "Viral upper respiratory infection",
              likelihood: "Medium",
              likelihoodColor:
                  const Color(0xFF2F6BFF),
              description:
                  "Common with sore throat, cough, fatigue. Hydration + rest often help.",
            ),

            const SizedBox(height: 14),

            conditionCard(
              title: "Allergic irritation",
              likelihood: "Low",
              likelihoodColor:
                  const Color(0xFF9CA3AF),
              description:
                  "Can cause congestion, itchy throat/eyes. Consider exposure triggers.",
            ),

            const SizedBox(height: 14),

            conditionCard(
              title:
                  "Bacterial infection (possible)",
              likelihood: "Low",
              likelihoodColor:
                  const Color(0xFF9CA3AF),
              description:
                  "Certain features may need clinician evaluation and testing.",
            ),

            const SizedBox(height: 24),

            /// WHEN TO CONSULT SECTION
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color:
                    Colors.orange.withOpacity(.08),
                borderRadius:
                    BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: const [
                  Text(
                    "When to consult a doctor",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Seek urgent care if you have trouble breathing, chest pain, fainting, confusion, severe dehydration, sudden weakness, or a rapidly spreading rash.",
                  ),
                  SizedBox(height: 12),
                  Text("✔ Symptoms worsen or don’t improve in 24–48 hours"),
                  Text("✔ High fever, persistent vomiting, or severe pain"),
                  Text("✔ You’re pregnant, immunocompromised, or elderly"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget conditionCard({
    required String title,
    required String likelihood,
    required Color likelihoodColor,
    required String description,
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
                const SizedBox(height: 6),
                Text(description,
                    style: const TextStyle(
                        color:
                            Color(0xFF6B7280))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: likelihoodColor.withOpacity(.1),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Text(
              "Likelihood: $likelihood",
              style: TextStyle(
                  color: likelihoodColor,
                  fontWeight:
                      FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}