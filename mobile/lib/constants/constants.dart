import 'package:flutter/foundation.dart';

// API URL
const _debugUrl = "http://10.0.2.2:3000";
const _prodUrl = "http://10.0.2.2:3000";
const apiUrl = kReleaseMode ? _prodUrl : _debugUrl;

// Store Token In Local Storage
const tokenKey = "TOKEN_KEY";

// Blood Types
List<String> bloodTypes = [
  'A Positive (A+)',
  'A Negative (A-)',
  'B Positive (B+)',
  'B Negative (B-)',
  'O Positive (O+)',
  'O Negative (O-)',
  'AB Positive (AB+)',
  'AB Negative (AB-)',
];
