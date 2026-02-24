import 'package:flutter/material.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F5F9),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Document Vault",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            /// UPLOAD CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.insert_drive_file_outlined,
                          color: Color(0xFF2F6BFF)),
                      SizedBox(width: 8),
                      Text(
                        "Secure document storage",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Upload PDFs/images, tag by date/doctor/condition, and quickly search your records.",
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F6BFF),
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.upload_outlined),
                      label: const Text("Upload"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            /// SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search by file name",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// TYPE FILTER
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: const [
                Text("Type",
                    style: TextStyle(
                        fontWeight: FontWeight.w600)),
                Text("Filter",
                    style: TextStyle(
                        color: Color(0xFF6B7280))),
              ],
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                filterChip("All", true),
                filterChip("Prescription", false),
                filterChip("Lab", false),
                filterChip("Scan", false),
                filterChip("Discharge", false),
                filterChip("Other", false),
              ],
            ),

            const SizedBox(height: 20),

            /// TAG INPUT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.label_outline),
                  hintText:
                      "e.g., asthma, Dr. Lee, CBC",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 22),

            /// STORED FILES
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: const [
                Text("Stored files",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                Text("2 items",
                    style: TextStyle(
                        color: Color(0xFF6B7280))),
              ],
            ),

            const SizedBox(height: 14),

            documentCard(
              fileType: "PDF",
              fileName: "CBC_Lab_Report.pdf",
              date: "10/2/2026",
              category: "Lab",
              tags: const ["CBC", "Routine"],
            ),

            const SizedBox(height: 14),

            documentCard(
              fileType: "IMG",
              fileName: "Prescription_Amoxicillin.png",
              date: "21/1/2026",
              category: "Prescription",
              tags: const ["Antibiotic"],
            ),
          ],
        ),
      ),
    );
  }

  static Widget filterChip(
      String label, bool selected) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFEAF0FF)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label,
          style: TextStyle(
              color: selected
                  ? const Color(0xFF2F6BFF)
                  : Colors.black)),
    );
  }

  static Widget documentCard({
    required String fileType,
    required String fileName,
    required String date,
    required String category,
    required List<String> tags,
  }) {
    return Container(
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
            children: [
              Container(
                padding:
                    const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FF),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Text(fileType,
                    style: const TextStyle(
                        color:
                            Color(0xFF2F6BFF),
                        fontWeight:
                            FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(fileName,
                        style: const TextStyle(
                            fontWeight:
                                FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      "$date  •  $category",
                      style: const TextStyle(
                          color:
                              Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: tags
                .map(
                  (tag) => Container(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFF3F5F9),
                      borderRadius:
                          BorderRadius.circular(
                              12),
                    ),
                    child: Text(tag),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFEAF0FF),
                    foregroundColor:
                        const Color(0xFF2F6BFF),
                    side: BorderSide.none,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("View"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Download"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}