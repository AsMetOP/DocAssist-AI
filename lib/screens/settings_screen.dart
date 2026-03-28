import 'package:flutter/material.dart';
import 'package:doc_assist/core/theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../provider/settings_provider.dart';
import 'package:doc_assist/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _dob;
  String? _gender;

  final supabase = Supabase.instance.client;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  /// LOAD PROFILE
  Future<void> loadProfile() async {
    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', supabase.auth.currentUser!.id)
          .single();

      setState(() {
        _nameController.text = data['name'] ?? '';
        if (data['dob'] != null) {
          _dob = DateTime.parse(data['dob']);
        }
        _gender = data['gender'];
      });
    } catch (e) {
      print("Load Profile Error: $e");
    }
  }

  /// SAVE PROFILE
  Future<void> saveProfile() async {
    await supabase.from('users').upsert({
      'id': supabase.auth.currentUser!.id,
      'email': supabase.auth.currentUser!.email,
      'name': _nameController.text.trim(),
      'dob': _dob?.toIso8601String(),
      'gender': _gender,
    });

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated")),
    );
  }

  int get age {
    if (_dob == null) return 0;
    final today = DateTime.now();
    int calculatedAge = today.year - _dob!.year;
    if (today.month < _dob!.month ||
        (today.month == _dob!.month && today.day < _dob!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  Future<void> _pickDate() async {
    if (!isEditing) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  void _showGenderSheet() async {
    if (!isEditing) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _genderOption("Male"),
              _genderOption("Female"),
              _genderOption("Other"),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _gender = selected;
      });
    }
  }

  Widget _genderOption(String value) {
    return ListTile(
      title: Text(value),
      trailing: _gender == value
          ? const Icon(Icons.check, color: AppTheme.primary)
          : null,
      onTap: () {
        Navigator.pop(context, value);
      },
    );
  }

  /// WARNING DIALOG
  Future<bool?> showWarningDialog(
      BuildContext context, {
        required String message,
        required String confirmText,
      }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppTheme.primary),
            SizedBox(width: 8),
            Text("Warning"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel",
                style: TextStyle(color: AppTheme.textGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText,
                style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  /// LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                saveProfile();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: ListView(
            children: [
              const Text("Profile",
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),

              /// NAME CARD
              Container(
                height: 58,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: AppTheme.cardDecoration,
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: _nameController,
                  enabled: isEditing,
                  decoration: const InputDecoration(
                    hintText: "Full Name",
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// DOB CARD
              InkWell(
                onTap: _pickDate,
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: AppTheme.cardDecoration,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_dob == null
                          ? "Date of Birth"
                          : "${_dob!.day}/${_dob!.month}/${_dob!.year}"),
                      const Icon(Icons.calendar_today_outlined,
                          size: 18, color: AppTheme.textGrey),
                    ],
                  ),
                ),
              ),

              if (_dob != null) ...[
                const SizedBox(height: 16),
                Text("Age: $age years",
                    style: const TextStyle(color: AppTheme.textGrey)),
              ],

              const SizedBox(height: 16),

              /// GENDER CARD
              InkWell(
                onTap: _showGenderSheet,
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: AppTheme.cardDecoration,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_gender ?? "Gender"),
                      const Icon(Icons.keyboard_arrow_down,
                          color: AppTheme.textGrey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// PRIVACY CARD
              const Text("Privacy",
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("Save symptom history"),
                      value: settings.saveHistory,
                      activeColor: AppTheme.primary,
                      onChanged: (val) async {
                        if (!val) {
                          bool? confirm = await showWarningDialog(
                            context,
                            message:
                            "If you turn OFF history, your AI results will NOT be saved.",
                            confirmText: "Turn OFF",
                          );
                          if (confirm == true) {
                            settings.toggleSaveHistory(false);
                          }
                        } else {
                          settings.toggleSaveHistory(true);
                        }
                      },
                    ),
                    SwitchListTile(
                      title: const Text("Anonymous Mode"),
                      value: settings.anonymousMode,
                      activeColor: AppTheme.primary,
                      onChanged: (val) async {
                        if (val) {
                          bool? confirm = await showWarningDialog(
                            context,
                            message:
                            "In Anonymous Mode:\n\n• History will NOT be saved\n• Documents will NOT be saved\n• You cannot view past results",
                            confirmText: "Turn ON",
                          );
                          if (confirm == true) {
                            settings.toggleAnonymousMode(true);
                          }
                        } else {
                          settings.toggleAnonymousMode(false);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// LOGOUT CARD
              Container(
                decoration: AppTheme.cardDecoration,
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: logout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}