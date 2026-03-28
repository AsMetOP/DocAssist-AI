import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doc_assist/core/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final supabase = Supabase.instance.client;
  List historyList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final user = supabase.auth.currentUser;

    /// Fetch all reports sorted by date
    final textData = await supabase
        .from('text_reports')
        .select()
        .eq('user_id', user!.id)
        .order('created_at', ascending: false);

    final imageData = await supabase
        .from('image_reports')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    final voiceData = await supabase
        .from('voice_reports')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    List tempHistory = [];

    int count = textData.length;

    for (int i = 0; i < count; i++) {
      var text = textData[i];
      var image = i < imageData.length ? imageData[i] : null;
      var voice = i < voiceData.length ? voiceData[i] : null;

      /// -------- FUSION ----------
      Map<String, double> scoreMap = {};

      void addPrediction(String? disease, dynamic confidence, double weight) {
        if (disease == null || confidence == null) return;

        double conf = (confidence is int)
            ? confidence.toDouble()
            : confidence;

        scoreMap[disease] = (scoreMap[disease] ?? 0) + (conf * weight);
      }

      /// TEXT
      addPrediction(text['prediction'], text['confidence'], 0.5);
      addPrediction(text['prediction2'], text['confidence2'], 0.5);
      addPrediction(text['prediction3'], text['confidence3'], 0.5);

      /// IMAGE
      if (image != null) {
        addPrediction(image['prediction'], image['confidence'], 0.3);
        addPrediction(image['prediction2'], image['confidence2'], 0.3);
        addPrediction(image['prediction3'], image['confidence3'], 0.3);
      }

      /// VOICE
      if (voice != null) {
        addPrediction(voice['prediction'], voice['confidence'], 0.2);
        addPrediction(voice['prediction2'], voice['confidence2'], 0.2);
        addPrediction(voice['prediction3'], voice['confidence3'], 0.2);
      }

      /// Convert to sorted list
      List finalPredictions = scoreMap.entries.map((e) {
        return {"disease": e.key, "confidence": e.value};
      }).toList();

      finalPredictions.sort(
              (a, b) => (b["confidence"]).compareTo(a["confidence"]));

      finalPredictions = finalPredictions.take(3).toList();

      tempHistory.add({
        "date": text['created_at'],
        "description": text['description'],
        "duration": text['duration'],
        "severity": text['severity'],
        "body_area": text['body_area'],
        "predictions": finalPredictions,
      });
    }

    setState(() {
      historyList = tempHistory;
      loading = false;
    });
  }

  Widget predictionRow(String disease, double confidence) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(disease),
          Text(
            "${(confidence * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget historyCard(Map item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Date
          Row(
            children: [
              const Icon(Icons.analytics, color: AppTheme.primary),
              const SizedBox(width: 10),
              const Text(
                "AI Result",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                item['date'].toString().substring(0, 10),
                style: const TextStyle(color: AppTheme.textGrey),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text("Symptoms: ${item['description'] ?? '-'}"),
          Text("Duration: ${item['duration'] ?? '-'}"),
          Text("Severity: ${item['severity'] ?? '-'}"),
          Text("Body Area: ${item['body_area'] ?? '-'}"),

          const SizedBox(height: 12),

          const Text(
            "Top Predictions",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          ...item['predictions']
              .map<Widget>((p) => predictionRow(
            p["disease"],
            p["confidence"],
          ))
              .toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadHistory,
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
          ? const Center(child: Text("No history yet"))
          : Padding(
        padding: const EdgeInsets.all(22),
        child: ListView.builder(
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            return historyCard(historyList[index]);
          },
        ),
      ),
    );
  }
}