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

  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _beneficialUseController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final int _beneficialUseMaxLength = 150;

  DateTime? _birthDate;
  String? _gender;
  String? _selectedEducationLevel;
  bool _showSendButton = false;

  final List<String> _educationLevels = [
    'Primary School',
    'Middle School',
    'High School',
    'Undergraduate',
    'Postgraduate',
    'PhD',
  ];

  final List<String> _availableAIModels = [
    'ChatGPT',
    'Bard',
    'Gemini',
    'Claude',
    'DeepSeek',
  ];
  final List<String> _selectedAIModels = [];
  final Map<String, String> _defects = {};

  @override
  void initState() {
    super.initState();
    _nameSurnameController.addListener(_checkFieldsFilled);
    _cityController.addListener(_checkFieldsFilled);
    _beneficialUseController.addListener(_checkFieldsFilled);
    _emailController.addListener(_checkFieldsFilled);
  }

  void _checkFieldsFilled() {
    setState(() {
      _showSendButton =
          _nameSurnameController.text.isNotEmpty &&
          _birthDate != null &&
          _selectedEducationLevel != null &&
          _cityController.text.isNotEmpty &&
          _gender != null &&
          _selectedAIModels.isNotEmpty &&
          _selectedAIModels.every(
            (model) => _defects[model]?.isNotEmpty ?? false,
          ) &&
          _beneficialUseController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _emailController.text.contains('@') &&
          _emailController.text.contains('.');
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 20)),
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

      if (age > 120 || age < 6) {
        Fluttertoast.showToast(
          msg:
              age > 120
                  ? "Age exceeds valid range (120 years max)."
                  : "You must be at least 6 years old to participate.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      setState(() {
        _birthDate = picked;
      });
      _checkFieldsFilled();
    }
  }

  Future<void> _submitSurvey() async {
    if (_formKey.currentState!.validate()) {
      if (_birthDate == null || _gender == null) {
        Fluttertoast.showToast(
          msg:
              _birthDate == null
                  ? "Please select a birth date"
                  : "Please select a gender",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
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

        final response = await http.post(
          Uri.parse('$baseUrl/survey'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        );

        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: "Survey submitted successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pop(context);
        } else {
          final error = json.decode(response.body)['detail'] ?? 'Unknown error';
          Fluttertoast.showToast(
            msg: "Failed to submit survey: $error",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (e) {
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
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedEducationLevel,
                  items:
                      _educationLevels
                          .map(
                            (level) => DropdownMenuItem<String>(
                              value: level,
                              child: Text(level),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedEducationLevel = val;
                    });
                    _checkFieldsFilled();
                  },
                  decoration: InputDecoration(labelText: "Education Level"),
                  validator: (value) => value == null ? "Required" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: "City"),
                  validator: (value) => value!.isEmpty ? "Required" : null,
                ),
                SizedBox(height: 16),
                Text("Gender", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Radio<String>(
                      value: "male",
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() => _gender = value);
                        _checkFieldsFilled();
                      },
                    ),
                    Text("Male"),
                    Radio<String>(
                      value: "female",
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() => _gender = value);
                        _checkFieldsFilled();
                      },
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
                            _checkFieldsFilled();
                          },
                        );
                      }).toList(),
                  key: Key('ai_models_field'),
                ),
                SizedBox(height: 16),
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
                                _checkFieldsFilled();
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
                SizedBox(height: 16),
                TextFormField(
                  controller: _beneficialUseController,
                  decoration: InputDecoration(
                    labelText: "Beneficial AI Use",
                    helperText:
                        "${_beneficialUseMaxLength - _beneficialUseController.text.length} characters remaining",
                    counterText: "",
                  ),
                  maxLength: _beneficialUseMaxLength,
                  maxLines: null,
                  onChanged:
                      (_) => setState(() {
                        _checkFieldsFilled();
                      }),
                  validator: (value) => value!.isEmpty ? "Required" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) =>
                          value!.isEmpty ||
                                  !value.contains('@') ||
                                  !value.contains('.')
                              ? "Valid email required"
                              : null,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _showSendButton
                    ? ElevatedButton(
                      onPressed: _submitSurvey,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text("Submit Survey"),
                    )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
