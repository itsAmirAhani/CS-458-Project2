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
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
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
    _dayController.addListener(_validateBirthDateFields);
    _monthController.addListener(_validateBirthDateFields);
    _yearController.addListener(_validateBirthDateFields);
  }

  @override
  void dispose() {
    _nameSurnameController.dispose();
    _cityController.dispose();
    _beneficialUseController.dispose();
    _emailController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
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

  void _validateBirthDateFields() {
    int? day = int.tryParse(_dayController.text);
    int? month = int.tryParse(_monthController.text);
    int? year = int.tryParse(_yearController.text);

    DateTime? tempDate;
    if (day != null && month != null && year != null) {
      try {
        tempDate = DateTime(year, month, day);
        final now = DateTime.now();
        int age =
            now.year -
            tempDate.year -
            ((now.month < tempDate.month) ||
                    (now.month == tempDate.month && now.day < tempDate.day)
                ? 1
                : 0);

        if (age < 6 ||
            age > 120 ||
            day < 1 ||
            day > 31 ||
            month < 1 ||
            month > 12) {
          tempDate = null;
        }
      } catch (_) {
        tempDate = null;
      }
    }

    setState(() {
      _birthDate = tempDate;
    });

    _checkFieldsFilled();
  }

  Future<void> _submitSurvey() async {
    if (_formKey.currentState!.validate()) {
      if (_birthDate == null || _gender == null) {
        Fluttertoast.showToast(
          msg:
              _birthDate == null
                  ? "Please select a valid birth date"
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
                Text("Birth Date (DD/MM/YYYY)", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dayController,
                        maxLength: 2,
                        decoration: InputDecoration(
                          labelText: "Day",
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _monthController,
                        maxLength: 2,
                        decoration: InputDecoration(
                          labelText: "Month",
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        maxLength: 4,
                        decoration: InputDecoration(
                          labelText: "Year",
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                if (_birthDate == null &&
                    _dayController.text.isNotEmpty &&
                    _monthController.text.isNotEmpty &&
                    _yearController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Please enter a valid date between ages 6 and 120.",
                      style: TextStyle(color: Colors.red, fontSize: 12),
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
