class MedicalDocument {
  final String filePath;
  final DateTime uploadedAt;
  final String type; // image, pdf, audio
  final String name;

  // Optional extracted text (OCR / reports)
  final String? extractedText;

  MedicalDocument({
    required this.filePath,
    required this.uploadedAt,
    required this.type,
    required this.name,
    this.extractedText,
  });
}