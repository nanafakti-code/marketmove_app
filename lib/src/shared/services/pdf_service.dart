import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  static final PdfService _instance = PdfService._internal();

  factory PdfService() {
    return _instance;
  }

  PdfService._internal();

  /// Generar factura en PDF
  Future<Uint8List> generateInvoicePDF({
    required String saleNumber,
    required String clientName,
    required String clientEmail,
    required String productName,
    required double total,
    required double tax,
    required double discount,
    required String paymentMethod,
    required DateTime saleDate,
    String? notes,
  }) async {
    final pdf = pw.Document();
    final subtotal = total - tax + discount;
    final formattedDate = '${saleDate.day}/${saleDate.month}/${saleDate.year}';
    final formattedTime =
        '${saleDate.hour.toString().padLeft(2, '0')}:${saleDate.minute.toString().padLeft(2, '0')}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  gradient: const pw.LinearGradient(
                    colors: [
                      PdfColor.fromInt(0xFF667eea),
                      PdfColor.fromInt(0xFF764ba2),
                    ],
                  ),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'FACTURA DE VENTA',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'MarketMove - Tu gestor de inventario',
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Invoice Info
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: const PdfColor.fromInt(0xFF667eea),
                    width: 2,
                  ),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Información de la Venta',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFF667eea),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    _buildInfoRow('Número de Factura:', '#$saleNumber'),
                    _buildInfoRow(
                      'Fecha:',
                      '$formattedDate a las $formattedTime',
                    ),
                    _buildInfoRow(
                      'Método de Pago:',
                      '${paymentMethod[0].toUpperCase()}${paymentMethod.substring(1)}',
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Client Info
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFFF8F9FA),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Datos del Cliente',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    _buildInfoRow('Nombre:', clientName),
                    _buildInfoRow('Email:', clientEmail),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Product Details Table
              pw.Text(
                'Detalles del Producto',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(
                  color: const PdfColor.fromInt(0xFFE0E0E0),
                ),
                children: [
                  // Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFF667eea),
                    ),
                    children: [
                      _buildTableCell('Producto', isHeader: true),
                      _buildTableCell('Cantidad', isHeader: true),
                      _buildTableCell(
                        'Precio',
                        isHeader: true,
                        align: pw.TextAlign.right,
                      ),
                    ],
                  ),
                  // Product row
                  pw.TableRow(
                    children: [
                      _buildTableCell(productName),
                      _buildTableCell('1'),
                      _buildTableCell(
                        '${subtotal.toStringAsFixed(2)} EUR',
                        align: pw.TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Totals
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFFE8F4F8),
                  border: pw.Border.all(
                    color: const PdfColor.fromInt(0xFF667eea),
                    width: 2,
                  ),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    _buildTotalRow(
                      'Subtotal:',
                      '${subtotal.toStringAsFixed(2)} EUR',
                    ),
                    if (tax > 0)
                      _buildTotalRow(
                        'Impuesto (+):',
                        '${tax.toStringAsFixed(2)} EUR',
                      ),
                    if (discount > 0)
                      _buildTotalRow(
                        'Descuento (-):',
                        '-${discount.toStringAsFixed(2)} EUR',
                      ),
                    pw.Divider(
                      thickness: 2,
                      color: const PdfColor.fromInt(0xFF667eea),
                    ),
                    pw.SizedBox(height: 5),
                    _buildTotalRow(
                      'TOTAL:',
                      '${total.toStringAsFixed(2)} EUR',
                      isFinal: true,
                    ),
                  ],
                ),
              ),

              // Notes
              if (notes != null && notes.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    color: const PdfColor.fromInt(0xFFFFF9E6),
                    border: pw.Border(
                      left: pw.BorderSide(
                        color: const PdfColor.fromInt(0xFFFFC107),
                        width: 4,
                      ),
                    ),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Notas Adicionales:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFFF57C00),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(notes),
                    ],
                  ),
                ),
              ],

              pw.Spacer(),

              // Footer
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      '¡Gracias por tu compra!',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      '© 2025 MarketMove. Todos los derechos reservados.',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
          ),
          pw.SizedBox(width: 10),
          pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : PdfColors.black,
          fontSize: 12,
        ),
        textAlign: align,
      ),
    );
  }

  pw.Widget _buildTotalRow(String label, String value, {bool isFinal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isFinal ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: isFinal ? 18 : 14,
              color: isFinal
                  ? const PdfColor.fromInt(0xFF667eea)
                  : PdfColors.black,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: isFinal ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: isFinal ? 18 : 14,
              color: isFinal
                  ? const PdfColor.fromInt(0xFF667eea)
                  : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
