import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';
import 'package:doc_assist/screens/main_navigation.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final nameController = TextEditingController();
  DateTime? dob;
  String? gender;

  final supabase = Supabase.instance.client;
  bool loading = false;

  Future<void> saveProfile() async {
    if (nameController.text.isEmpty || dob == null || gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final user = supabase.auth.currentUser;

      print("Saving profile for user: ${user!.id}");

      await supabase.from('users').upsert({
        'id': user.id,
        'email': user.email,
        'name': nameController.text.trim(),
        'dob': dob!.toIso8601String(),
        'gender': gender,
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        ),
      );
    } catch (e) {
      print("PROFILE SAVE ERROR: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => loading = false);
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => dob = picked);
    }
  }

  void selectGender(String value) {
    setState(() => gender = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Complete Profile",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: pickDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    dob == null
                        ? "Select Date of Birth"
                        : "${dob!.day}/${dob!.month}/${dob!.year}",
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  ChoiceChip(
                    label: const Text("Male"),
                    selected: gender == "Male",
                    onSelected: (_) => selectGender("Male"),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("Female"),
                    selected: gender == "Female",
                    onSelected: (_) => selectGender("Female"),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("Other"),
                    selected: gender == "Other",
                    onSelected: (_) => selectGender("Other"),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Profile",style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}