import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../config.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for text fields
  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _beneficialUseController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Form state
  DateTime? _birthDate;
  String? _gender;
  List<String> _availableAIModels = [
    'ChatGPT',
    'Bard',
    'Gemini',
    'Claude',
    'DeepSeek',
  ];
  List<String> _selectedAIModels = [];
  Map<String, String> _defects = {};
  String? _selectedEducationLevel; // Add this to state

  final List<String> _educationLevels = [
    'Primary School',
    'Middle School',
    'High School',
    'Undergraduate',
    'Postgraduate',
    'PhD',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        Duration(days: 365 * 20),
      ), // default age: ~20
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final today = DateTime.now();
      final age =
          today.year -
          picked.year -
          ((today.month < picked.month ||
                  (today.month == picked.month && today.day < picked.day))
              ? 1
              : 0);

      if (age > 120) {
        Fluttertoast.showToast(
          msg: "Age exceeds valid range (120 years max).",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      if (age < 6) {
        Fluttertoast.showToast(
          msg: "You must be at least 6 years old to participate.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _submitSurvey() async {
    // Validate form and required fields
    if (_formKey.currentState!.validate()) {
      if (_birthDate == null) {
        Fluttertoast.showToast(
          msg: "Please select a birth date",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }
      if (_gender == null) {
        Fluttertoast.showToast(
          msg: "Please select a gender",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare the payload
        final payload = {
          'name_surname': _nameSurnameController.text,
          'birth_date': DateFormat('yyyy-MM-dd').format(_birthDate!),
          'education_level': _selectedEducationLevel,
          'city': _cityController.text,
          'gender': _gender,
          'ai_models': _selectedAIModels,
          'defects': _defects,
          'beneficial_use': _beneficialUseController.text,
          'email': _emailController.text,
        };

        // Log the payload for debugging
        print('Submitting survey: ${json.encode(payload)}');

        // Send the request
        final response = await http.post(
          Uri.parse('$baseUrl/survey'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        );

        // Log the response
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: "Survey submitted successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pop(context); // Go back to login page
        } else {
          final error = json.decode(response.body)['detail'] ?? 'Unknown error';
          Fluttertoast.showToast(
            msg: "Failed to submit survey: $error",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (e) {
        print('Submission error: $e');
        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please fill all required fields correctly",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Survey")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameSurnameController,
                  decoration: InputDecoration(labelText: "Name & Surname"),
                  validator: (value) => value!.isEmpty ? "Required" : null,
                  key: Key('name_surname_field'),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: "Birth Date"),
                    child: Text(
                      _birthDate == null
                          ? "Select date"
                          : DateFormat('yyyy-MM-dd').format(_birthDate!),
                    ),
                    key: Key('birth_date_field'),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedEducationLevel,
                  items:
                      _educationLevels.map((level) {
                        return DropdownMenuItem<String>(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedEducationLevel = val;
                    });
                  },
                  decoration: InputDecoration(labelText: "Education Level"),
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                  key: Key('education_level_field'),
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: "City"),
                  validator: (value) => value!.isEmpty ? "Required" : null,
                  key: Key('city_field'),
                ),
                SizedBox(height: 16),
                Text("Gender", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Radio<String>(
                      value: "male",
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                      key: Key('gender_male'),
                    ),
                    Text("Male"),
                    Radio<String>(
                      value: "female",
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                      key: Key('gender_female'),
                    ),
                    Text("Female"),
                  ],
                ),
                SizedBox(height: 16),
                Text("Select AI Models", style: TextStyle(fontSize: 16)),
                Wrap(
                  spacing: 8.0,
                  children:
                      _availableAIModels.map((model) {
                        return FilterChip(
                          label: Text(model),
                          selected: _selectedAIModels.contains(model),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedAIModels.add(model);
                                _defects.putIfAbsent(model, () => "");
                              } else {
                                _selectedAIModels.remove(model);
                                _defects.remove(model);
                              }
                            });
                          },
                        );
                      }).toList(),
                  key: Key('ai_models_field'),
                ),

                SizedBox(height: 16),
                Text("Defects", style: TextStyle(fontSize: 16)),
                if (_selectedAIModels.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _selectedAIModels.map((model) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "$model - Defect/Cons",
                              ),
                              initialValue: _defects[model],
                              onChanged: (val) {
                                setState(() {
                                  _defects[model] = val;
                                });
                              },
                              validator:
                                  (val) =>
                                      val == null || val.isEmpty
                                          ? "Enter a defect for $model"
                                          : null,
                            ),
                          );
                        }).toList(),
                  ),

                SizedBox(height: 8),
                Text(
                  _defects.isEmpty
                      ? "No defects added"
                      : "Defects: ${_defects.entries.map((e) => '${e.key}: ${e.value}').join(', ')}",
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _beneficialUseController,
                  decoration: InputDecoration(labelText: "Beneficial Use"),
                  validator: (value) => value!.isEmpty ? "Required" : null,
                  key: Key('beneficial_use_field'), // Add this
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) =>
                          value!.isEmpty || !value.contains('@')
                              ? "Valid email required"
                              : null,
                  key: Key('email_field'),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      onPressed: _submitSurvey,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.blue, // Added for consistency
                      ),
                      child: Text("Submit Survey"),
                      key: Key('submit_button'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
