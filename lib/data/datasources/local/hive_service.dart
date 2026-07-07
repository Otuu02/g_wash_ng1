// FILE: lib/data/datasources/local/hive_service.dart
// PURPOSE: Manages local database using Hive for complex data storage

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/job_model.dart';
import '../../models/user_model.dart';

class HiveService {
  static const String _userBox = 'user_box';
  static const String _jobsBox = 'jobs_box';
  static const String _cacheBox = 'cache_box';
  
  static late Box _userBoxInstance;
  static late Box _jobsBoxInstance;
  static late Box _cacheBoxInstance;
  
  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters if needed
    // Hive.registerAdapter(JobModelAdapter());
    
    _userBoxInstance = await Hive.openBox(_userBox);
    _jobsBoxInstance = await Hive.openBox(_jobsBox);
    _cacheBoxInstance = await Hive.openBox(_cacheBox);
  }
  
  // ==================== USER DATA ====================
  static Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    await _userBoxInstance.put('current_user', user);
  }
  
  static Map<String, dynamic>? getCurrentUser() {
    return _userBoxInstance.get('current_user');
  }
  
  static Future<void> clearCurrentUser() async {
    await _userBoxInstance.delete('current_user');
  }
  
  // ==================== JOBS CACHE ====================
  static Future<void> cacheJobs(List<JobModel> jobs) async {
    await _jobsBoxInstance.put('cached_jobs', jobs.map((j) => j.toJson()).toList());
  }
  
  static List<JobModel>? getCachedJobs() {
    final data = _jobsBoxInstance.get('cached_jobs');
    if (data == null) return null;
    return (data as List).map((j) => JobModel.fromJson(j)).toList();
  }
  
  static Future<void> cacheJob(JobModel job) async {
    await _jobsBoxInstance.put('job_${job.id}', job.toJson());
  }
  
  static JobModel? getCachedJob(String jobId) {
    final data = _jobsBoxInstance.get('job_$jobId');
    if (data == null) return null;
    return JobModel.fromJson(data);
  }
  
  static Future<void> clearJobsCache() async {
    await _jobsBoxInstance.clear();
  }
  
  // ==================== GENERIC CACHE ====================
  static Future<void> cacheData(String key, dynamic value) async {
    await _cacheBoxInstance.put(key, value);
  }
  
  static dynamic getCachedData(String key) {
    return _cacheBoxInstance.get(key);
  }
  
  static Future<void> removeCachedData(String key) async {
    await _cacheBoxInstance.delete(key);
  }
  
  static Future<bool> hasCachedData(String key) async {
    return _cacheBoxInstance.containsKey(key);
  }
  
  // ==================== CACHE WITH EXPIRY ====================
  static Future<void> cacheWithExpiry(String key, dynamic value, Duration expiry) async {
    final data = {
      'value': value,
      'expiresAt': DateTime.now().add(expiry).toIso8601String(),
    };
    await _cacheBoxInstance.put(key, data);
  }
  
  static dynamic getCachedWithExpiry(String key) {
    final data = _cacheBoxInstance.get(key);
    if (data == null) return null;
    
    final expiresAt = DateTime.parse(data['expiresAt']);
    if (DateTime.now().isAfter(expiresAt)) {
      _cacheBoxInstance.delete(key);
      return null;
    }
    
    return data['value'];
  }
  
  // ==================== PREFERENCES ====================
  static Future<void> setPreference(String key, dynamic value) async {
    await _cacheBoxInstance.put('pref_$key', value);
  }
  
  static dynamic getPreference(String key) {
    return _cacheBoxInstance.get('pref_$key');
  }
  
  // ==================== CLEAR ALL ====================
  static Future<void> clearAll() async {
    await _userBoxInstance.clear();
    await _jobsBoxInstance.clear();
    await _cacheBoxInstance.clear();
  }
}