import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';

class EmailService {
  static final EmailService _instance = EmailService._internal();

  factory EmailService() {
    return _instance;
  }

  EmailService._internal();

  late final SmtpServer _smtpServer;
  late final String _fromEmail;

  /// Inicializar el servicio de emails (llamar en main.dart)
  Future<void> initialize() async {
    await dotenv.load();

    final smtpUser = dotenv.env['BREVO_SMTP_USER'] ?? '';
    final smtpPassword = dotenv.env['BREVO_SMTP_PASSWORD'] ?? '';
    final smtpServer =
        dotenv.env['BREVO_SMTP_SERVER'] ?? 'smtp-relay.brevo.com';
    final smtpPort = int.parse(dotenv.env['BREVO_SMTP_PORT'] ?? '587');

    _fromEmail = dotenv.env['BREVO_SENDER_EMAIL'] ?? 'marketmove@example.com';

    _smtpServer = SmtpServer(
      smtpServer,
      port: smtpPort,
      username: smtpUser,
      password: smtpPassword,
      ssl: false,
      allowInsecure: true,
    );

    print('✅ EmailService inicializado correctamente');
  }

  /// Enviar email genérico
  Future<bool> sendEmail({
    required String toEmail,
    required String toName,
    required String subject,
    required String htmlContent,
    List<Attachment>? attachments,
  }) async {
    try {
      print('📧 Intentando enviar correo...');
      print('  De: $_fromEmail');
      print('  Para: $toEmail');
      print('  Asunto: $subject');

      final message = Message()
        ..from = Address(_fromEmail, 'MarketMove')
        ..recipients.add(Address(toEmail, toName))
        ..subject = subject
        ..html = htmlContent;

      // Agregar adjuntos si existen
      if (attachments != null && attachments.isNotEmpty) {
        message.attachments.addAll(attachments);
        print('  Adjuntos: ${attachments.length}');
      }

      final sendReport = await send(message, _smtpServer);

      print('✅ Correo enviado exitosamente');
      print('Message ID: ${sendReport.toString()}');
      return true;
    } on MailerException catch (e) {
      print('❌ Error Mailer: ${e.toString()}');
      print('   Problemas: ${e.problems}');
      return false;
    } catch (e) {
      print('❌ Error al enviar correo: $e');
      return false;
    }
  }

  /// Email de bienvenida al usuario
  Future<bool> sendWelcomeEmail({
    required String userEmail,
    required String fullName,
    required String businessName,
  }) async {
    final html =
        '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background: linear-gradient(to right, #667eea, #764ba2); color: white; padding: 20px; border-radius: 8px 8px 0 0; }
          .content { background: #f9fafb; padding: 20px; border-radius: 0 0 8px 8px; }
          .button { display: inline-block; background: #667eea; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-top: 15px; }
          .features { background: white; padding: 15px; border-left: 4px solid #667eea; margin: 15px 0; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>🎉 ¡Bienvenido a MarketMove!</h1>
          </div>
          <div class="content">
            <p>Hola <strong>$fullName</strong>,</p>
            <p>Tu cuenta ha sido creada exitosamente. Estamos emocionados de tenerte como parte de MarketMove.</p>
            
            <div class="features">
              <p><strong>📊 Datos de tu negocio:</strong></p>
              <p>📦 Nombre: <strong>$businessName</strong></p>
              <p>📧 Email: <strong>$userEmail</strong></p>
            </div>
            
            <p><strong>¿Qué puedes hacer ahora?</strong></p>
            <ul>
              <li>Gestionar tu inventario de productos</li>
              <li>Registrar tus ventas diarias</li>
              <li>Controlar tus gastos operacionales</li>
              <li>Ver resumen de ganancias</li>
              <li>Acceder desde cualquier dispositivo</li>
            </ul>
            
            <p>Si tienes alguna pregunta, no dudes en contactarnos.</p>
            <p>Saludos,<br><strong>El equipo de MarketMove</strong></p>
          </div>
        </div>
      </body>
      </html>
    ''';

    return sendEmail(
      toEmail: userEmail,
      toName: fullName,
      subject: '¡Bienvenido a MarketMove!',
      htmlContent: html,
    );
  }

  /// Email de recibo de COMPRA al cliente
  Future<bool> sendPurchaseReceipt({
    required String clientEmail,
    required String clientName,
    required String saleNumber,
    required double total,
    required double tax,
    required double discount,
    required String paymentMethod,
    required DateTime saleDate,
    required String? notes,
  }) async {
    final subtotal = total - tax + discount;
    final formattedDate = '${saleDate.day}/${saleDate.month}/${saleDate.year}';
    final formattedTime =
        '${saleDate.hour.toString().padLeft(2, '0')}:${saleDate.minute.toString().padLeft(2, '0')}';

    final html =
        '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background: linear-gradient(to right, #3B82F6, #2563EB); color: white; padding: 20px; border-radius: 8px 8px 0 0; }
          .content { background: #f9fafb; padding: 20px; border-radius: 0 0 8px 8px; }
          .receipt-section { background: white; padding: 15px; border-left: 4px solid #3B82F6; margin: 15px 0; }
          .details-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
          .details-table th { background: #3B82F6; color: white; padding: 12px; text-align: left; }
          .details-table td { padding: 12px; border-bottom: 1px solid #e0e0e0; }
          .total-section { background: #eff6ff; padding: 20px; margin: 20px 0; border-radius: 8px; }
          .total-row { display: flex; justify-content: space-between; margin: 10px 0; font-size: 15px; }
          .total-row.final { border-top: 2px solid #3B82F6; padding-top: 10px; font-size: 18px; font-weight: bold; color: #1e40af; }
          .notes-box { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 5px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>🛍️ Recibo de Compra</h1>
            <p>MarketMove - Tu gestor de inventario</p>
          </div>
          
          <div class="content">
            <div class="receipt-section">
              <p><strong>Información de tu Compra</strong></p>
              <p>Número: <strong>#$saleNumber</strong></p>
              <p>Comprador: <strong>$clientName</strong></p>
              <p>Fecha: <strong>$formattedDate $formattedTime</strong></p>
              <p>Método de pago: <strong>${paymentMethod[0].toUpperCase()}${paymentMethod.substring(1)}</strong></p>
            </div>

            <table class="details-table">
              <thead>
                <tr>
                  <th>Concepto</th>
                  <th style="text-align: right;">Monto</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Subtotal</td>
                  <td style="text-align: right;">�${subtotal.toStringAsFixed(2)}</td>
                </tr>
                ${tax > 0 ? '<tr><td>Impuesto (+)</td><td style="text-align: right;">�${tax.toStringAsFixed(2)}</td></tr>' : ''}
                ${discount > 0 ? '<tr><td>Descuento (-)</td><td style="text-align: right;">-�${discount.toStringAsFixed(2)}</td></tr>' : ''}
              </tbody>
            </table>

            <div class="total-section">
              <div class="total-row final">
                <span>Total Pagado:</span>
                <span>�${total.toStringAsFixed(2)}</span>
              </div>
            </div>

            ${notes != null && notes.isNotEmpty ? '''
            <div class="notes-box">
              <strong>📝 Notas del vendedor:</strong><br>
              $notes
            </div>
            ''' : ''}

            <p style="text-align: center; color: #666; margin-top: 30px;">
              ¡Gracias por tu compra! 🙏
            </p>
          </div>
        </div>
      </body>
      </html>
    ''';

    return sendEmail(
      toEmail: clientEmail,
      toName: clientName,
      subject: '🛍️ Recibo de Compra #$saleNumber',
      htmlContent: html,
    );
  }

  /// Email de recibo de VENTA al administrador/vendedor
  Future<bool> sendSaleReceiptToAdmin({
    required String adminEmail,
    required String adminName,
    required String clientName,
    required String clientEmail,
    required String clientPhone,
    required String saleNumber,
    required double total,
    required double tax,
    required double discount,
    required String paymentMethod,
    required DateTime saleDate,
    required String? notes,
  }) async {
    final subtotal = total - tax + discount;
    final formattedDate = '${saleDate.day}/${saleDate.month}/${saleDate.year}';
    final formattedTime =
        '${saleDate.hour.toString().padLeft(2, '0')}:${saleDate.minute.toString().padLeft(2, '0')}';

    final html =
        '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background: linear-gradient(to right, #10B981, #059669); color: white; padding: 20px; border-radius: 8px 8px 0 0; }
          .content { background: #f9fafb; padding: 20px; border-radius: 0 0 8px 8px; }
          .receipt-section { background: white; padding: 15px; border-left: 4px solid #10B981; margin: 15px 0; }
          .customer-section { background: #f0fdf4; padding: 15px; border-left: 4px solid #34d399; margin: 15px 0; border-radius: 5px; }
          .details-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
          .details-table th { background: #10B981; color: white; padding: 12px; text-align: left; }
          .details-table td { padding: 12px; border-bottom: 1px solid #e0e0e0; }
          .total-section { background: #e8f5e9; padding: 20px; margin: 20px 0; border-radius: 8px; }
          .total-row { display: flex; justify-content: space-between; margin: 10px 0; font-size: 15px; }
          .total-row.final { border-top: 2px solid #10B981; padding-top: 10px; font-size: 18px; font-weight: bold; color: #059669; }
          .notes-box { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 5px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>💰 Recibo de Venta</h1>
            <p>MarketMove - Tu gestor de inventario</p>
          </div>
          
          <div class="content">
            <p>Hola <strong>$adminName</strong>,</p>
            <p>Una nueva venta ha sido registrada en tu sistema.</p>

            <div class="receipt-section">
              <p><strong>Información de la Venta</strong></p>
              <p>Número: <strong>#$saleNumber</strong></p>
              <p>Fecha: <strong>$formattedDate $formattedTime</strong></p>
              <p>Método de pago: <strong>${paymentMethod[0].toUpperCase()}${paymentMethod.substring(1)}</strong></p>
            </div>

            <div class="customer-section">
              <p><strong>👤 Datos del Cliente</strong></p>
              <p>Nombre: <strong>$clientName</strong></p>
              <p>Email: <strong>$clientEmail</strong></p>
              <p>Teléfono: <strong>$clientPhone</strong></p>
            </div>

            <table class="details-table">
              <thead>
                <tr>
                  <th>Concepto</th>
                  <th style="text-align: right;">Monto</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Subtotal</td>
                  <td style="text-align: right;">�${subtotal.toStringAsFixed(2)}</td>
                </tr>
                ${tax > 0 ? '<tr><td>Impuesto (+)</td><td style="text-align: right;">�${tax.toStringAsFixed(2)}</td></tr>' : ''}
                ${discount > 0 ? '<tr><td>Descuento (-)</td><td style="text-align: right;">-�${discount.toStringAsFixed(2)}</td></tr>' : ''}
              </tbody>
            </table>

            <div class="total-section">
              <div class="total-row final">
                <span>Total Ganancia:</span>
                <span>�${total.toStringAsFixed(2)}</span>
              </div>
            </div>

            ${notes != null && notes.isNotEmpty ? '''
            <div class="notes-box">
              <strong>📝 Notas:</strong><br>
              $notes
            </div>
            ''' : ''}

            <p style="text-align: center; color: #666; margin-top: 30px;">
              ✅ El cliente ha recibido su recibo de compra automáticamente.
            </p>
          </div>
        </div>
      </body>
      </html>
    ''';

    return sendEmail(
      toEmail: adminEmail,
      toName: adminName,
      subject:
          '💰 Nueva Venta Registrada #$saleNumber - �${total.toStringAsFixed(2)}',
      htmlContent: html,
    );
  }

  /// Email de notificación al administrador
  Future<bool> sendAdminNotification({
    required String adminEmail,
    required String subject,
    required String htmlContent,
  }) async {
    return sendEmail(
      toEmail: adminEmail,
      toName: 'Administrador MarketMove',
      subject: subject,
      htmlContent: htmlContent,
    );
  }

  /// Email de factura al cliente con botón de descarga
  Future<bool> sendInvoiceEmail({
    required String clientEmail,
    required String clientName,
    required String saleNumber,
    required double total,
    required double tax,
    required double discount,
    required String paymentMethod,
    required DateTime saleDate,
    required String? notes,
    required String productName,
    String? pdfDownloadUrl,
    Uint8List? pdfBytes,
  }) async {
    final subtotal = total - tax + discount;
    final formattedDate = '${saleDate.day}/${saleDate.month}/${saleDate.year}';
    final formattedTime =
        '${saleDate.hour.toString().padLeft(2, '0')}:${saleDate.minute.toString().padLeft(2, '0')}';

    final html =
        '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          body { font-family: 'Segoe UI', Arial, sans-serif; line-height: 1.6; color: #333; background-color: #f5f5f5; margin: 0; padding: 0; }
          .container { max-width: 600px; margin: 20px auto; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
          .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px 30px; text-align: center; }
          .header h1 { margin: 0; font-size: 32px; font-weight: bold; }
          .header p { margin: 10px 0 0 0; font-size: 16px; opacity: 0.95; }
          .content { padding: 40px 30px; }
          .invoice-box { background: #f8f9fa; border-left: 4px solid #667eea; padding: 20px; margin: 20px 0; border-radius: 8px; }
          .invoice-box h2 { margin: 0 0 15px 0; color: #667eea; font-size: 18px; }
          .invoice-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #e0e0e0; }
          .invoice-row:last-child { border-bottom: none; }
          .invoice-row .label { color: #666; font-weight: 500; }
          .invoice-row .value { color: #333; font-weight: 600; }
          .details-table { width: 100%; border-collapse: collapse; margin: 25px 0; background: white; }
          .details-table th { background: #667eea; color: white; padding: 15px; text-align: left; font-weight: 600; }
          .details-table td { padding: 15px; border-bottom: 1px solid #e0e0e0; }
          .details-table tr:last-child td { border-bottom: none; }
          .total-section { background: linear-gradient(135deg, #e8f4f8 0%, #f0e8f8 100%); padding: 25px; margin: 25px 0; border-radius: 8px; border: 2px solid #667eea; }
          .total-row { display: flex; justify-content: space-between; margin: 12px 0; font-size: 16px; }
          .total-row.final { border-top: 3px solid #667eea; padding-top: 15px; margin-top: 15px; font-size: 24px; font-weight: bold; color: #667eea; }
          .download-button { text-align: center; margin: 35px 0; }
          .download-button a { display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 16px 40px; text-decoration: none; border-radius: 8px; font-size: 18px; font-weight: bold; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4); transition: transform 0.2s; }
          .download-button a:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5); }
          .notes-box { background: #fff9e6; border-left: 4px solid #ffc107; padding: 20px; margin: 25px 0; border-radius: 8px; }
          .notes-box strong { color: #f57c00; display: block; margin-bottom: 10px; }
          .footer { background: #f8f9fa; padding: 25px 30px; text-align: center; color: #666; font-size: 14px; }
          .footer p { margin: 5px 0; }
          .icon { font-size: 48px; margin-bottom: 10px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <div class="icon">📄</div>
            <h1>Factura de Venta</h1>
            <p>MarketMove - Tu gestor de inventario</p>
          </div>
          
          <div class="content">
            <p style="font-size: 18px; margin-bottom: 10px;">Hola <strong>$clientName</strong>,</p>
            <p style="color: #666; margin-bottom: 30px;">Gracias por tu compra. Aquí están los detalles de tu factura:</p>

            <div class="invoice-box">
              <h2>📋 Información de la Venta</h2>
              <div class="invoice-row">
                <span class="label">Número de Factura:</span>
                <span class="value">#$saleNumber</span>
              </div>
              <div class="invoice-row">
                <span class="label">Fecha:</span>
                <span class="value">$formattedDate a las $formattedTime</span>
              </div>
              <div class="invoice-row">
                <span class="label">Método de Pago:</span>
                <span class="value">${paymentMethod[0].toUpperCase()}${paymentMethod.substring(1)}</span>
              </div>
              <div class="invoice-row">
                <span class="label">Producto:</span>
                <span class="value">$productName</span>
              </div>
            </div>

            <table class="details-table">
              <thead>
                <tr>
                  <th>Concepto</th>
                  <th style="text-align: right;">Monto</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Subtotal</td>
                  <td style="text-align: right; font-weight: 600;">\$${subtotal.toStringAsFixed(2)}</td>
                </tr>
                ${tax > 0 ? '<tr><td>Impuesto (+)</td><td style="text-align: right; font-weight: 600; color: #f57c00;">\$${tax.toStringAsFixed(2)}</td></tr>' : ''}
                ${discount > 0 ? '<tr><td>Descuento (-)</td><td style="text-align: right; font-weight: 600; color: #4caf50;">-\$${discount.toStringAsFixed(2)}</td></tr>' : ''}
              </tbody>
            </table>

            <div class="total-section">
              <div class="total-row final">
                <span>Total Pagado:</span>
                <span>\$${total.toStringAsFixed(2)}</span>
              </div>
            </div>

            ${notes != null && notes.isNotEmpty ? '''
            <div class="notes-box">
              <strong>📝 Notas adicionales:</strong>
              $notes
            </div>
            ''' : ''}

            <div style="background: linear-gradient(135deg, #e8f4f8 0%, #f0e8f8 100%); padding: 20px; margin: 25px 0; border-radius: 8px; border: 2px solid #667eea; text-align: center;">
              <p style="margin: 0; font-size: 16px; color: #667eea; font-weight: bold;">
                📎 La factura en PDF está adjunta a este correo
              </p>
              <p style="margin: 10px 0 0 0; font-size: 14px; color: #666;">
                Descarga el archivo adjunto para guardar tu factura
              </p>
            </div>

            <p style="text-align: center; color: #999; margin-top: 40px; font-size: 14px;">
              Si tienes alguna pregunta sobre esta factura, no dudes en contactarnos.
            </p>
          </div>

          <div class="footer">
            <p><strong>¡Gracias por tu compra! 🎉</strong></p>
            <p>© 2025 MarketMove. Todos los derechos reservados.</p>
          </div>
        </div>
      </body>
      </html>
    ''';

    // Preparar adjunto PDF si está disponible
    List<Attachment>? attachments;
    if (pdfBytes != null) {
      // Guardar PDF en archivo temporal
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/Factura-$saleNumber.pdf');
      await tempFile.writeAsBytes(pdfBytes);

      attachments = [FileAttachment(tempFile)];
    }

    return sendEmail(
      toEmail: clientEmail,
      toName: clientName,
      subject: '📄 Factura #$saleNumber - MarketMove',
      htmlContent: html,
      attachments: attachments,
    );
  }

  /// Email de confirmación de actualización de perfil
  Future<bool> sendProfileUpdateEmail(String userEmail) async {
    final html = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          body { font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { 
            background: linear-gradient(135deg, #6366f1 0%, #3b82f6 100%);
            padding: 40px;
            border-radius: 12px;
            text-align: center;
            color: white;
          }
          .header h1 { margin: 0; font-size: 28px; }
          .content { 
            padding: 40px; 
            background: #f8f9fa;
            border-radius: 12px;
            margin-top: 20px;
          }
          .check-icon { font-size: 48px; margin: 20px 0; }
          .footer { 
            text-align: center; 
            color: #999; 
            font-size: 12px;
            margin-top: 30px;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <div class="check-icon">✅</div>
            <h1>Perfil Actualizado</h1>
          </div>
          
          <div class="content">
            <p>¡Hola!</p>
            
            <p>Tu perfil en <strong>MarketMove</strong> ha sido actualizado exitosamente.</p>
            
            <p>Los cambios incluyen:</p>
            <ul>
              <li>✏️ Información de perfil actualizada</li>
              <li>🔒 Tu email y contraseña permanecen protegidos</li>
              <li>⏰ Cambios efectivos inmediatamente</li>
            </ul>
            
            <p>Si no realizaste este cambio, por favor contacta con nuestro equipo de soporte inmediatamente.</p>
            
            <p style="color: #666; font-size: 14px; margin-top: 30px;">
              Saludos,<br>
              <strong>Equipo MarketMove</strong>
            </p>
          </div>
          
          <div class="footer">
            <p>© 2025 MarketMove. Todos los derechos reservados.</p>
          </div>
        </div>
      </body>
      </html>
    ''';

    return sendEmail(
      toEmail: userEmail,
      toName: 'Usuario MarketMove',
      subject: '✅ Tu Perfil ha sido Actualizado - MarketMove',
      htmlContent: html,
    );
  }
}
