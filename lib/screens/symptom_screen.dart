import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:doc_assist/core/theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../provider/document_provider.dart';
import '../provider/result_provider.dart';
import '../provider/settings_provider.dart';
import 'results_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _symptomController =
  TextEditingController();
  final TextEditingController _durationController =
  TextEditingController();
  final TextEditingController _bodyAreaController =
  TextEditingController();
  double _progress = 0.0;
  String _loadingText = "Analyzing symptoms";
  Timer? _loadingTimer;

  String severity = "Mild";

  final ImagePicker _picker = ImagePicker();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _recorderReady = false;
  bool _playerReady = false;

  bool isRecording = false;
  bool isPlaying = false;

  Duration recordingDuration = Duration.zero;
  Timer? _recordTimer;

  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;
  StreamSubscription? _playerSubscription;

  List<String> attachments = [];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAudio();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.3).animate(
          CurvedAnimation(
            parent: _pulseController,
            curve: Curves.easeInOut,
          ),
        );
  }

  Future<void> _initAudio() async {
    await _recorder.openRecorder();
    await _player.openPlayer();
    await _player.setSubscriptionDuration(
      const Duration(milliseconds: 200),
    );
    setState(() {
      _recorderReady = true;
      _playerReady = true;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _recordTimer?.cancel();
    _playerSubscription?.cancel();
    _recorder.closeRecorder();
    _player.closePlayer();
    _loadingTimer?.cancel();
    super.dispose();
  }

  void startLoadingAnimation() {
    _progress = 0.0;

    _loadingTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {

      setState(() {
        _progress += 0.05;
        if (_progress > 1) _progress = 0.1;

        int dots = (timer.tick % 3) + 1;
        _loadingText = "AI analyzing" + "." * dots;
      });

    });
  }

  void stopLoadingAnimation() {
    _loadingTimer?.cancel();
  }

  // ================= IMAGE =================
  Future<void> captureImage() async {
    final image =
    await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => attachments.add(image.path));
    }
  }

  // ================= VIDEO =================
  Future<void> captureVideo() async {
    final video =
    await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() => attachments.add(video.path));
    }
  }

  // ================= RECORD =================
  Future<void> toggleRecording() async {
    print("Tapped audio");

    if (!_recorderReady) {
      print("Recorder not ready");
      return;
    }

    if (!isRecording) {

      print("Requesting permission...");
      final status = await Permission.microphone.request();
      print("Permission status: $status");

      if (!status.isGranted) {
        print("Permission not granted");
        return;
      }

      print("Starting recorder...");
      final dir = await getTemporaryDirectory();
      final path =
          "${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac";

      try {
        await _recorder.startRecorder(
          toFile: path,
          codec: Codec.aacADTS,
        );
        print("Recorder started");
      } catch (e) {
        print("Recorder error: $e");
      }

      _startTimer();
      setState(() => isRecording = true);

    } else {
      final path = await _recorder.stopRecorder();
      _recordTimer?.cancel();

      print("Recorder stopped");
      print("Audio saved at: $path");

      setState(() {
        isRecording = false;
        recordingDuration = Duration.zero;
      });

      if (path != null) {
        setState(() {
          attachments.add(path);
        });
      }
    }
  }

  void _startTimer() {
    recordingDuration = Duration.zero;
    _recordTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            recordingDuration =
                Duration(seconds: timer.tick);
          });
        });
  }

  // ================= PLAY =================
  Future<void> playAudio(String path) async {
    if (!_playerReady) return;

    if (isPlaying) {
      await _player.stopPlayer();
      _playerSubscription?.cancel();
      setState(() => isPlaying = false);
      return;
    }

    await _player.startPlayer(
      fromURI: path,
      whenFinished: () =>
          setState(() => isPlaying = false),
    );

    _playerSubscription =
        _player.onProgress!.listen((event) {
          setState(() {
            _position = event.position;
            _totalDuration = event.duration;
          });
        });

    setState(() => isPlaying = true);
  }

  void deleteAttachment(String file) {
    setState(() => attachments.remove(file));
  }

  String formatDuration(Duration d) {
    final m =
    d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s =
    d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Future<Map<String, dynamic>> safePost(String url, Map body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("URL: $url");
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // Gradio format: {"data": [ { result } ]}
        if (decoded is Map && decoded.containsKey("data")) {
          return decoded["data"][0];
        }

        return decoded;
      } else {
        return {};
      }
    } catch (e) {
      print("API ERROR: $e");
      return {};
    }
  }

  Future<void> analyze() async {
    if (_symptomController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter symptoms")),
      );
      return;
    }

    startLoadingAnimation();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      const textUrl = "https://asmetop-docassistai-text.hf.space/predict";
      const imageUrl = "https://grovyy-docassist-images.hf.space/predict";
      const voiceUrl = "https://sakshijindal-docassist-audio.hf.space/predict";

      final docProvider = Provider.of<DocumentProvider>(context, listen: false);

      final combinedText = """
            ${_symptomController.text}
            ${_durationController.text}
            ${_bodyAreaController.text}
            ${docProvider.getCombinedText()}
        """;

      /// ---------------- TEXT MODEL ----------------
      final textResult = await safePost(textUrl, {
        "description": combinedText,
        "duration": _durationController.text,
        "severity": severity,
        "body_area": _bodyAreaController.text
      });

      final textPredictions = textResult["top_predictions"] ?? [];

      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null) {
        await supabase.from('text_reports').insert({
          'user_id': user.id,
          'description': _symptomController.text,
          'duration': _durationController.text,
          'severity': severity,
          'body_area': _bodyAreaController.text,

          'prediction': textPredictions.isNotEmpty ? textPredictions[0]["disease"] : null,
          'confidence': textPredictions.isNotEmpty ? textPredictions[0]["confidence"] : null,

          'prediction2': textPredictions.length > 1 ? textPredictions[1]["disease"] : null,
          'confidence2': textPredictions.length > 1 ? textPredictions[1]["confidence"] : null,

          'prediction3': textPredictions.length > 2 ? textPredictions[2]["disease"] : null,
          'confidence3': textPredictions.length > 2 ? textPredictions[2]["confidence"] : null,
        });
      }

      /// ---------------- IMAGE MODEL ----------------
      Map<String, dynamic> imageResult = {};
      List imagePredictions = [];

      var imageRequest = http.MultipartRequest('POST', Uri.parse(imageUrl));
      imageRequest.fields['description'] = _symptomController.text;

      for (var file in attachments) {
        if (file.endsWith(".jpg") ||
            file.endsWith(".png") ||
            file.endsWith(".jpeg")) {
          imageRequest.files.add(await http.MultipartFile.fromPath('file', file));
        }
      }

      if (imageRequest.files.isNotEmpty) {
        var response = await imageRequest.send();
        final body = await response.stream.bytesToString();

        print("IMAGE STATUS: ${response.statusCode}");
        print("IMAGE BODY: $body");

        if (body.startsWith("{")) {
          imageResult = jsonDecode(body);
          imagePredictions = imageResult["top_predictions"] ?? [];
        }
      }
      if (imagePredictions.isNotEmpty && user != null) {
        await supabase.from('image_reports').insert({
          'user_id': user.id,
          'image_url': attachments.first,

          'prediction': imagePredictions.isNotEmpty ? imagePredictions[0]["disease"] : null,
          'confidence': imagePredictions.isNotEmpty ? imagePredictions[0]["confidence"] : null,
        });
      }

      /// ---------------- VOICE MODEL ----------------
      Map<String, dynamic> voiceResult = {};
      List voicePredictions = [];
      String? audioFile;

      for (var file in attachments) {
        if (file.endsWith(".aac")) {
          audioFile = file;
          break;
        }
      }

      if (audioFile != null) {
        var request = http.MultipartRequest('POST', Uri.parse(voiceUrl));
        request.fields['description'] = _symptomController.text;
        request.files.add(await http.MultipartFile.fromPath('file', audioFile));

        var response = await request.send();
        final body = await response.stream.bytesToString();

        print("VOICE STATUS: ${response.statusCode}");
        print("VOICE BODY: $body");

        if (body.startsWith("{")) {
          voiceResult = jsonDecode(body);
          voicePredictions = voiceResult["top_predictions"] ?? [];
        }
      }
      if (voicePredictions.isNotEmpty && user != null) {
        await supabase.from('voice_reports').insert({
          'user_id': user.id,
          'voice_url': audioFile,

          'prediction': voicePredictions.isNotEmpty ? voicePredictions[0]["disease"] : null,
          'confidence': voicePredictions.isNotEmpty ? voicePredictions[0]["confidence"] : null,
        });
      }

      /// ---------------- SMART FUSION ----------------
      Map<String, double> scoreMap = {};

      void addPredictions(List preds, double weight) {
        for (var item in preds) {
          String disease = item["disease"];
          double confidence = item["confidence"] * weight;
          scoreMap[disease] = (scoreMap[disease] ?? 0) + confidence;
        }
      }

      addPredictions(textPredictions, 0.5);
      addPredictions(imagePredictions, 0.3);
      addPredictions(voicePredictions, 0.2);

      List combinedPredictions = scoreMap.entries.map((entry) {
        return {
          "disease": entry.key,
          "confidence": entry.value,
        };
      }).toList();

      combinedPredictions.sort(
              (a, b) => (b["confidence"]).compareTo(a["confidence"]));

      combinedPredictions = combinedPredictions.take(3).toList();

      final finalResult = {
        "structured_guidance": textResult["structured_guidance"] ?? {},
        "top_predictions": combinedPredictions,
      };

      stopLoadingAnimation();
      if (context.mounted) Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            symptom: _symptomController.text,
            duration: _durationController.text,
            severity: severity,
            bodyArea: _bodyAreaController.text,
            result: finalResult,
          ),
        ),
      );
    } catch (e) {
      stopLoadingAnimation();
      if (context.mounted) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget buildField(String title,
      TextEditingController controller,
      {bool optional = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16),
          decoration: AppTheme.cardDecoration,
          child: TextField(
            controller: controller,
            decoration:
            const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
              horizontal: 20, vertical: 16),
          child: ListView(
            children: [

              const Text(
                "Describe symptoms", textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w600),
              ),

              const SizedBox(height: 20),

              Container(
                padding:
                const EdgeInsets.all(16),
                decoration:
                AppTheme.cardDecoration,
                child: TextField(
                  controller:
                  _symptomController,
                  maxLines: 4,
                  decoration:
                  const InputDecoration(
                    hintText:
                    "Sore throat, fever...",
                    border:
                    InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              buildField("Duration",
                  _durationController),

              // SEVERITY DROPDOWN
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Severity",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: AppTheme.cardDecoration,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: severity,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppTheme.primary,
                        ),

                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),

                        items: const [
                          DropdownMenuItem(
                            value: "Mild",
                            child: Text("Mild"),
                          ),
                          DropdownMenuItem(
                            value: "Moderate",
                            child: Text("Moderate"),
                          ),
                          DropdownMenuItem(
                            value: "Severe",
                            child: Text("Severe"),
                          ),
                        ],

                        onChanged: (value) {
                          setState(() {
                            severity = value!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),

              buildField("Body area",
                  _bodyAreaController),

              // ================= ATTACHMENTS CARD =================

              Container(
                padding: const EdgeInsets.all(18),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Attachments",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Add images or audio.",
                      style: TextStyle(color: AppTheme.textGrey),
                    ),
                    const SizedBox(height: 16),

                    /// IMAGE BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(14),
                        color: AppTheme.softBlue,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: captureImage,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_outlined, color: AppTheme.primary),
                                SizedBox(width: 8),
                                Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// AUDIO BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(14),
                        color: isRecording
                            ? Colors.red.withOpacity(0.1)
                            : AppTheme.softBlue,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: toggleRecording,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isRecording
                                    ? ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: const Icon(Icons.mic, color: Colors.red),
                                )
                                    : const Icon(Icons.graphic_eq,
                                    color: AppTheme.primary),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    isRecording
                                        ? "Recording ${formatDuration(recordingDuration)}"
                                        : "Record Audio",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isRecording
                                          ? Colors.red
                                          : AppTheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (attachments.isEmpty)
                      const Text(
                        "No attachments added",
                        style: TextStyle(color: AppTheme.textGrey),
                      ),

                    ...attachments.map(
                          (file) => Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: AppTheme.cardDecoration,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  if (file.endsWith(".aac"))
                                    IconButton(
                                      icon: Icon(
                                        isPlaying ? Icons.stop : Icons.play_arrow,
                                      ),
                                      onPressed: () => playAudio(file),
                                    ),
                                  Expanded(
                                    child: Text(
                                      file.split("/").last,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => deleteAttachment(file),
                                  )
                                ],
                              ),
                              if (isPlaying && file.endsWith(".aac"))
                                Slider(
                                  value: _position.inMilliseconds.toDouble(),
                                  max: _totalDuration.inMilliseconds == 0
                                      ? 1
                                      : _totalDuration.inMilliseconds.toDouble(),
                                  onChanged: (value) async {
                                    await _player.seekToPlayer(
                                      Duration(milliseconds: value.toInt()),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                height: 56,
                child:
                ElevatedButton(
                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    AppTheme.primary,
                  ),
                  onPressed: analyze,
                  child:
                  const Text("Analyze",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}