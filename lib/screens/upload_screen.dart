import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../provider/document_provider.dart';
import '../models/document_model.dart';
import 'package:doc_assist/core/theme.dart';
import '../provider/settings_provider.dart';
import 'document_screen.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    if (settings.anonymousMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anonymous mode is ON. Documents cannot be saved.")),
      );
      return;
    }

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      String selectedType = "Prescription";
      TextEditingController nameController = TextEditingController();

      showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.file(File(image.path)),
                      const SizedBox(height: 16),

                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "File name",
                          filled: true,
                          fillColor: AppTheme.softBlue,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTheme.softBlue,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: "Prescription", child: Text("Prescription")),
                          DropdownMenuItem(value: "Lab Report", child: Text("Lab Report")),
                          DropdownMenuItem(value: "Scan", child: Text("Scan")),
                          DropdownMenuItem(value: "Other", child: Text("Other")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                    ),
                    onPressed: () async {
                      final supabase = Supabase.instance.client;
                      final user = supabase.auth.currentUser;
                      if (user == null) return;

                      // SHOW LOADING ANIMATION
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text(
                                    "Uploading...",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Please wait",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );

                      try {
                        final file = File(image.path);
                        final fileName =
                            "${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg";

                        /// Upload to Supabase Storage
                        await supabase.storage.from('documents').upload(fileName, file);

                        final fileUrl =
                        supabase.storage.from('documents').getPublicUrl(fileName);

                        /// Save record in database
                        await supabase.from('documents').insert({
                          'user_id': user.id,
                          'name': nameController.text.isEmpty
                              ? image.name
                              : nameController.text,
                          'file_url': fileUrl,
                          'tag': selectedType,
                          'uploaded_at': DateTime.now().toIso8601String(),
                        });

                        /// Add locally for instant UI
                        context.read<DocumentProvider>().addDocument(
                          MedicalDocument(
                            filePath: image.path,
                            uploadedAt: DateTime.now(),
                            type: selectedType,
                            name: nameController.text.isEmpty
                                ? image.name
                                : nameController.text,
                          ),
                        );

                        Navigator.pop(context); // close loading
                        Navigator.pop(context); // close dialog

                        /// AUTO REFRESH DOCUMENT SCREEN
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const DocumentScreen()),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Uploaded successfully")),
                        );
                      } catch (e) {
                        Navigator.pop(context); // close loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Upload failed: $e")),
                        );
                      }
                    },
                    child: const Text("Upload", style: TextStyle(color: Colors.black)),
                  )
                ],
              );
            },
          );
        },
      );
    }
  }

  void showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Upload Medical Document",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 18),

              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppTheme.primary),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(context, ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo_library, color: AppTheme.primary),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text("Upload Documents",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: ListView(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file, color: Colors.black),
              label: const Text("Add Document",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () => showUploadOptions(context),
            ),
          ],
        ),
      ),
    );
  }
}