import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Service for PDF password testing and text extraction
class PdfExtractionService {
  
  /// Test if a password can open a PDF
  /// Returns true if password works, false otherwise
  static Future<bool> testPassword(Uint8List pdfBytes, String password) async {
    try {
      final document = PdfDocument(inputBytes: pdfBytes, password: password);
      document.dispose();
      return true;
    } catch (e) {
      print('❌ Password test failed: $e');
      return false;
    }
  }
  
  /// Check if PDF requires a password
  static Future<bool> isPasswordProtected(Uint8List pdfBytes) async {
    try {
      final document = PdfDocument(inputBytes: pdfBytes);
      document.dispose();
      return false; // Opened without password
    } catch (e) {
      print('🔒 PDF is password protected');
      return true;
    }
  }
  
  /// Extract text from PDF
  /// Returns extracted text or null if extraction fails
  /// Throws exception if password is wrong (do not catch silently!)
  static Future<String?> extractText(Uint8List pdfBytes, {String? password}) async {
    PdfDocument document;
    
    try {
      if (password != null && password.isNotEmpty) {
        document = PdfDocument(inputBytes: pdfBytes, password: password);
      } else {
        document = PdfDocument(inputBytes: pdfBytes);
      }
    } catch (e) {
      print('❌ Failed to open PDF: $e');
      // Re-throw to let caller know password is wrong
      rethrow;
    }
    
    try {
      final StringBuffer textBuffer = StringBuffer();
      
      // Extract text from all pages
      final extractor = PdfTextExtractor(document);
      for (int i = 0; i < document.pages.count; i++) {
        final pageText = extractor.extractText(startPageIndex: i, endPageIndex: i);
        textBuffer.writeln(pageText);
      }
      
      document.dispose();
      
      final text = textBuffer.toString().trim();
      print('✅ Extracted ${text.length} characters from PDF');
      return text.isEmpty ? null : text;
    } catch (e) {
      print('❌ PDF text extraction error: $e');
      document.dispose();
      return null;
    }
  }
  
  /// Get PDF page count
  static Future<int> getPageCount(Uint8List pdfBytes, {String? password}) async {
    try {
      PdfDocument document;
      
      if (password != null && password.isNotEmpty) {
        document = PdfDocument(inputBytes: pdfBytes, password: password);
      } else {
        document = PdfDocument(inputBytes: pdfBytes);
      }
      
      final count = document.pages.count;
      document.dispose();
      return count;
    } catch (e) {
      return 0;
    }
  }
  
  /// Test password on multiple PDFs, return success rate
  static Future<(int, int)> testPasswordOnMultiple(
    List<Uint8List> pdfList, 
    String password,
    {int maxToTest = 5}
  ) async {
    int success = 0;
    int tested = 0;
    
    for (final pdf in pdfList.take(maxToTest)) {
      tested++;
      if (await testPassword(pdf, password)) {
        success++;
      }
    }
    
    return (success, tested);
  }
}
