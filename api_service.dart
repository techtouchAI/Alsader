import 'dart:convert';
import 'package:http/http.dart' as http;

/// خدمة جلب البيانات المسؤولة عن التواصل مع واجهة برمجة التطبيقات (API)
/// أو استدعاء ملفات JSON عبر الشبكة مع ضمان معالجة الترميز العربي (UTF-8) بشكل سليم.
class ApiService {
  /// جلب البيانات من الخادم وفك تشفيرها باستخدام UTF-8 بشكل صريح
  /// لمنع مشكلة Mojibake مع النصوص العربية.
  Future<List<Map<String, dynamic>>> fetchCombinedData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // الحل الجذري لمشكلة الترميز:
        // بدلاً من استخدام response.body الذي قد يعتمد على ترميز افتراضي خاطئ (مثل Latin-1)،
        // نستخدم response.bodyBytes لجلب البيانات كبايتات خام،
        // ثم نقوم بفك تشفيرها صراحة باستخدام utf8.decode لضمان سلامة النصوص العربية.
        final String decodedData = utf8.decode(response.bodyBytes);

        // تحويل النص المصحح إلى قائمة من كائنات Dart
        final List<dynamic> jsonData = json.decode(decodedData);

        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('فشل في جلب البيانات: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء الاتصال بالشبكة: $e');
    }
  }
}
