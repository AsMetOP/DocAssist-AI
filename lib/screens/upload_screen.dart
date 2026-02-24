import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/document_provider.dart';
import '../models/document_model.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  Future<void> captureImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      context.read<DocumentProvider>().addDocument(
            MedicalDocument(
              imagePath: image.path,
              uploadedAt: DateTime.now(),
            ),
          );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Document")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => captureImage(context),
          child: const Text("Click Picture"),
        ),
      ),
    );
  }
}