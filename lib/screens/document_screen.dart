import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doc_assist/core/theme.dart';

import '../provider/settings_provider.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final supabase = Supabase.instance.client;

  List documents = [];
  String selectedTag = "Prescription";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDocuments();
    listenToChanges(); // REALTIME AUTO REFRESH
  }

  Future<void> loadDocuments() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    if (settings.anonymousMode) {
      setState(() {
        documents = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final user = supabase.auth.currentUser;

    final data = await supabase
        .from('documents')
        .select()
        .eq('user_id', user!.id)
        .order('uploaded_at', ascending: false);

    setState(() {
      documents = data;
      isLoading = false;
    });
  }

  /// REALTIME LISTENER (AUTO REFRESH WHEN NEW DOC UPLOADED)
  void listenToChanges() {
    final user = supabase.auth.currentUser;

    supabase
        .channel('documents')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'documents',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: user!.id,
      ),
      callback: (payload) {
        loadDocuments();
      },
    )
        .subscribe();
  }

  Widget tagChip(String tag) {
    return ChoiceChip(
      label: Text(tag),
      selected: selectedTag == tag,
      onSelected: (_) {
        setState(() {
          selectedTag = tag;
        });
      },
      selectedColor: AppTheme.primary,
      labelStyle: const TextStyle(color: Colors.black),
    );
  }

  Widget buildSection(String tag) {
    final filtered =
    documents.where((doc) => doc['tag'] == tag).toList();

    if (filtered.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tag,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),

        ...filtered.map((doc) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: AppTheme.cardDecoration,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    doc['file_url'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    doc['name'] ?? "Document",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await supabase
                        .from('documents')
                        .delete()
                        .eq('id', doc['id']);
                    loadDocuments();
                  },
                ),
              ],
            ),
          );
        }).toList(),

        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text("Documents")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: loadDocuments,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: ListView(
            children: [
              const Text(
                "Your Medical Documents",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 14),

              Wrap(
                spacing: 10,
                children: [
                  tagChip("Prescription"),
                  tagChip("Lab Report"),
                  tagChip("Scan"),
                  tagChip("Other"),
                ],
              ),

              const SizedBox(height: 20),

              buildSection("Prescription"),
              buildSection("Lab Report"),
              buildSection("Scan"),
              buildSection("Other"),
            ],
          ),
        ),
      ),
    );
  }
}