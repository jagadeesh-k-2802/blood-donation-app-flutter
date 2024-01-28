import 'package:flutter/foundation.dart';

// API URL
const _debugUrl = "http://10.0.2.2:3000/api/v1";
const _prodUrl = "http://10.0.2.2:3000/api/v1";
const apiUrl = kReleaseMode ? _prodUrl : _debugUrl;

// Store Token In Local Storage
const tokenKey = "TOKEN_KEY";
