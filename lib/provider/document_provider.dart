import 'package:flutter/material.dart';
import '../models/document_model.dart';

class DocumentProvider extends ChangeNotifier {
  final List<MedicalDocument> _documents = [];

  List<MedicalDocument> get documents => _documents;

  void addDocument(MedicalDocument doc) {
    _documents.add(doc);
    notifyListeners();
  }

  void deleteDocument(int index) {
    _documents.removeAt(index);
    notifyListeners();
  }
}