import 'dart:io';
import 'dart:typed_data';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';

class EmailService {
  static final EmailService _instance = EmailService._internal();

  factory EmailService() {
    return _instance;
  }

  EmailService._internal();

  SmtpServer? _smtpServer;
  String _fromEmail = 'noreply@marketmove.app';

  /// Inicializar el servicio de emails (llamar en main.dart)
  Future<void> initialize() async {
    try {
      // Leer archivo .env manualmente de forma segura
      try {
        final envFile = File('.env');
        if (await envFile.exists()) {
          final lines = await envFile.readAsLines();
          final envMap = <String, String>{};
          for (final line in lines) {
            if (line.isNotEmpty && !line.startsWith('#')) {
              final parts = line.split('=');
              if (parts.length == 2) {
                envMap[parts[0].trim()] = parts[1].trim();
              }
            }
          }

          final smtpUser = envMap['BREVO_SMTP_USER'] ?? '';
          final smtpPassword = envMap['BREVO_SMTP_PASSWORD'] ?? '';
          
          // Si hay credenciales, inicializar
          if (smtpUser.isNotEmpty && smtpPassword.isNotEmpty) {
            final smtpServer =
                envMap['BREVO_SMTP_SERVER'] ?? 'smtp-relay.brevo.com';
            final smtpPortStr = envMap['BREVO_SMTP_PORT'] ?? '587';
            final smtpPort = int.tryParse(smtpPortStr) ?? 587;
            final fromEmail = envMap['BREVO_SENDER_EMAIL'] ?? 'noreply@marketmove.app';

            _smtpServer = SmtpServer(
              smtpServer,
              port: smtpPort,
              username: smtpUser,
              password: smtpPassword,
              ssl: false,
              allowInsecure: true,
            );
            _fromEmail = fromEmail;
          }
        }
      } catch (_) {
        // Ignorar cualquier error al leer .env
      }
    } catch (_) {
      // Ignorar cualquier error durante inicialización
    }
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
      // Intentar leer credenciales del .env en tiempo real
      var smtpServer = _smtpServer;
      var fromEmail = _fromEmail;

      if (smtpServer == null) {
        // Intentar inicializar de nuevo
        try {
          final envFile = File('.env');
          if (await envFile.exists()) {
            final lines = await envFile.readAsLines();
            final envMap = <String, String>{};
            for (final line in lines) {
              if (line.isNotEmpty && !line.startsWith('#')) {
                final parts = line.split('=');
                if (parts.length == 2) {
                  envMap[parts[0].trim()] = parts[1].trim();
                }
              }
            }

            final smtpUser = envMap['BREVO_SMTP_USER'] ?? '';
            final smtpPassword = envMap['BREVO_SMTP_PASSWORD'] ?? '';
            
            if (smtpUser.isNotEmpty && smtpPassword.isNotEmpty) {
              final smtpServerStr =
                  envMap['BREVO_SMTP_SERVER'] ?? 'smtp-relay.brevo.com';
              final smtpPortStr = envMap['BREVO_SMTP_PORT'] ?? '587';
              final smtpPort = int.tryParse(smtpPortStr) ?? 587;
              
              smtpServer = SmtpServer(
                smtpServerStr,
                port: smtpPort,
                username: smtpUser,
                password: smtpPassword,
                ssl: false,
                allowInsecure: true,
              );
              fromEmail = envMap['BREVO_SENDER_EMAIL'] ?? 'noreply@marketmove.app';
            }
          }
        } catch (_) {
          return false;
        }
      }

      if (smtpServer == null) {
        return false;
      }

      final message = Message()
        ..from = Address(fromEmail, 'MarketMove')
        ..recipients.add(Address(toEmail, toName))
        ..subject = subject
        ..html = htmlContent;

      if (attachments != null && attachments.isNotEmpty) {
        message.attachments.addAll(attachments);
      }

      await send(message, smtpServer);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Email de bienvenida al usuario
  Future<bool> sendWelcomeEmail({
    required String userEmail,
    required String fullName,
    required String businessName,
  }) async {
    final html = '''<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { 
      font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif; 
      line-height: 1.6; 
      color: #2c3e50; 
      background: linear-gradient(135deg, #ecf0f1 0%, #bdc3c7 100%);
      padding: 20px 0;
    }
    .container { 
      max-width: 700px; 
      margin: 0 auto; 
      background: white; 
      border-radius: 16px; 
      overflow: hidden; 
      box-shadow: 0 10px 40px rgba(0,0,0,0.1); 
    }
    .header { 
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
      color: white; 
      padding: 60px 30px; 
      text-align: center; 
    }
    .header h1 { 
      margin: 0; 
      font-size: 36px; 
      font-weight: bold; 
      letter-spacing: 0.5px; 
    }
    .header p { 
      margin: 15px 0 0 0; 
      font-size: 16px; 
      opacity: 0.95; 
      font-weight: 300;
    }
    .content { 
      padding: 50px 40px; 
    }
    .greeting { 
      font-size: 18px; 
      margin-bottom: 25px; 
      color: #2c3e50; 
      line-height: 1.8; 
    }
    .greeting strong { 
      color: #667eea; 
      font-weight: 700; 
    }
    .welcome-box { 
      background: linear-gradient(135deg, #f5f7fa 0%, #f0f4f8 100%); 
      border-left: 5px solid #667eea; 
      padding: 25px; 
      margin: 30px 0; 
      border-radius: 10px; 
    }
    .welcome-box h2 { 
      color: #667eea; 
      font-size: 18px; 
      margin-bottom: 15px; 
      font-weight: 700;
    }
    .feature-list { 
      list-style: none; 
    }
    .feature-list li { 
      padding: 10px 0; 
      font-size: 15px; 
      color: #34495e; 
      border-bottom: 1px solid #e0e0e0;
    }
    .feature-list li:last-child { 
      border-bottom: none; 
    }
    .feature-list strong { 
      color: #764ba2; 
      font-weight: 600;
    }
    .benefits { 
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
      color: white; 
      padding: 30px; 
      margin: 30px 0; 
      border-radius: 10px; 
    }
    .benefits h3 { 
      font-size: 20px; 
      margin-bottom: 20px; 
      font-weight: bold;
    }
    .benefits-grid { 
      display: grid; 
      grid-template-columns: 1fr 1fr; 
      gap: 20px;
    }
    .benefit-item { 
      text-align: center;
    }
    .benefit-icon { 
      font-size: 32px; 
      margin-bottom: 10px;
    }
    .benefit-title { 
      font-size: 14px; 
      font-weight: 600; 
      margin-bottom: 5px;
    }
    .benefit-desc { 
      font-size: 12px; 
      opacity: 0.9;
    }
    .next-steps { 
      background: #fff3cd; 
      border-left: 5px solid #ffc107; 
      padding: 25px; 
      margin: 30px 0; 
      border-radius: 10px; 
    }
    .next-steps h3 { 
      color: #e67e22; 
      font-size: 16px; 
      margin-bottom: 15px; 
      font-weight: 700;
    }
    .steps-list { 
      list-style: none;
    }
    .steps-list li { 
      padding: 8px 0 8px 25px; 
      font-size: 14px; 
      color: #5a4a35; 
      position: relative;
    }
    .steps-list li:before { 
      content: "→"; 
      position: absolute; 
      left: 0; 
      color: #f39c12; 
      font-weight: bold;
    }
    .cta-section { 
      text-align: center; 
      margin: 35px 0; 
    }
    .cta-button { 
      display: inline-block; 
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
      color: white; 
      padding: 15px 40px; 
      text-decoration: none; 
      border-radius: 8px; 
      font-weight: 600; 
      font-size: 15px; 
      transition: transform 0.2s;
    }
    .cta-button:hover { 
      transform: translateY(-2px);
    }
    .divider { 
      border: 0; 
      border-top: 1px solid #e0e0e0; 
      margin: 30px 0;
    }
    .footer { 
      background: linear-gradient(135deg, #f5f7fa 0%, #f0f4f8 100%); 
      padding: 30px; 
      text-align: center; 
      color: #7f8c8d; 
      font-size: 12px; 
      border-top: 1px solid #e0e0e0;
    }
    .footer p { 
      margin: 5px 0;
    }
    .footer strong { 
      color: #2c3e50; 
      display: block; 
      margin-bottom: 10px; 
      font-size: 14px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>🎉 ¡Bienvenido a MarketMove!</h1>
      <p>Tu plataforma de gestión de inventario y ventas</p>
    </div>
    
    <div class="content">
      <div class="greeting">
        <p>¡Hola <strong>$fullName</strong>!</p>
        <p>Nos alegra enormemente que se haya unido a <strong>MarketMove</strong>. Tu cuenta ha sido creada exitosamente y estás listo para comenzar.</p>
      </div>

      <div class="welcome-box">
        <h2>📌 Tu Información de Cuenta</h2>
        <ul class="feature-list">
          <li><strong>Email:</strong> $userEmail</li>
          <li><strong>Nombre del Negocio:</strong> $businessName</li>
          <li><strong>Rol:</strong> Administrador</li>
          <li><strong>Acceso:</strong> Disponible ahora mismo</li>
        </ul>
      </div>

      <div class="benefits">
        <h3>✨ ¿Qué puedes hacer en MarketMove?</h3>
        <div class="benefits-grid">
          <div class="benefit-item">
            <div class="benefit-icon">📊</div>
            <div class="benefit-title">Gestión de Inventario</div>
            <div class="benefit-desc">Controla tus productos en tiempo real</div>
          </div>
          <div class="benefit-item">
            <div class="benefit-icon">💰</div>
            <div class="benefit-title">Registro de Ventas</div>
            <div class="benefit-desc">Documenta cada venta automáticamente</div>
          </div>
          <div class="benefit-item">
            <div class="benefit-icon">📈</div>
            <div class="benefit-title">Análisis y Reportes</div>
            <div class="benefit-desc">Visualiza métricas de tu negocio</div>
          </div>
          <div class="benefit-item">
            <div class="benefit-icon">⚙️</div>
            <div class="benefit-title">Automatización</div>
            <div class="benefit-desc">Optimiza tus procesos diarios</div>
          </div>
        </div>
      </div>

      <div class="next-steps">
        <h3>🚀 Primeros Pasos</h3>
        <ol class="steps-list">
          <li>Accede a tu cuenta con tus credenciales</li>
          <li>Completa tu perfil empresarial</li>
          <li>Configura tus productos/servicios</li>
          <li>Comienza a registrar tus ventas</li>
          <li>Explora los reportes y análisis</li>
        </ol>
      </div>

      <div class="cta-section">
        <a href="https://marketmove.com/login" class="cta-button">Inicia Sesión Ahora</a>
      </div>

      <hr class="divider">
      
      <p style="font-size: 14px; color: #7f8c8d; margin: 20px 0; line-height: 1.8;">
        Si tienes alguna pregunta o necesitas ayuda para comenzar, no dudes en contactarnos. Nuestro equipo de soporte está disponible para asistirte en todo lo que necesites.
      </p>

      <p style="font-size: 14px; color: #34495e; margin: 20px 0; font-weight: 600;">
        ¡Estamos emocionados de tenerle en el equipo de MarketMove!<br>
        <span style="color: #667eea;">Bienvenido/a</span> 🌟
      </p>
    </div>

    <div class="footer">
      <strong>MarketMove © 2025</strong>
      <p>Gestor profesional de inventario y ventas</p>
      <p style="margin-top: 10px; opacity: 0.7;">Este es un correo automatizado. Por favor, no respondas directamente.</p>
    </div>
  </div>
</body>
</html>''';

    return sendEmail(
      toEmail: userEmail,
      toName: fullName,
      subject: '🎉 Bienvenido a MarketMove - Tu cuenta está lista',
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

    final html = '''<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { 
      font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif; 
      line-height: 1.6; 
      color: #2c3e50; 
      background-color: #ecf0f1; 
      margin: 0; 
      padding: 0; 
    }
    .container { 
      max-width: 700px; 
      margin: 20px auto; 
      background: white; 
      border-radius: 12px; 
      overflow: hidden; 
      box-shadow: 0 4px 12px rgba(0,0,0,0.15); 
    }
    .header { 
      background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%); 
      color: white; 
      padding: 50px 30px; 
      text-align: center; 
    }
    .header h1 { 
      margin: 0; 
      font-size: 32px; 
      font-weight: bold; 
      letter-spacing: 1px; 
    }
    .header p { 
      margin: 12px 0 0 0; 
      font-size: 15px; 
      opacity: 0.95; 
    }
    .content { 
      padding: 40px 30px; 
    }
    .greeting { 
      font-size: 16px; 
      margin-bottom: 30px; 
      color: #2c3e50; 
      line-height: 1.8; 
    }
    .greeting strong { 
      color: #34495e; 
      font-weight: 600; 
    }
    .invoice-header { 
      background: linear-gradient(135deg, #f8f9fa 0%, #ecf0f1 100%); 
      border-left: 5px solid #2c3e50; 
      padding: 20px 20px; 
      margin: 25px 0; 
      border-radius: 8px; 
    }
    .invoice-header h2 { 
      margin: 0 0 15px 0; 
      color: #2c3e50; 
      font-size: 17px; 
      font-weight: 700; 
    }
    .invoice-row { 
      display: flex; 
      justify-content: space-between; 
      padding: 10px 0; 
      font-size: 14px; 
      border-bottom: 1px solid #e0e0e0; 
    }
    .invoice-row:last-child { 
      border-bottom: none; 
    }
    .invoice-row .label { 
      color: #7f8c8d; 
      font-weight: 600; 
    }
    .invoice-row .value { 
      color: #2c3e50; 
      font-weight: 700; 
    }
    .details-table { 
      width: 100%; 
      border-collapse: collapse; 
      margin: 30px 0; 
      background: white; 
      border: 1px solid #ecf0f1; 
      border-radius: 8px; 
      overflow: hidden; 
    }
    .details-table th { 
      background: #34495e; 
      color: white; 
      padding: 15px; 
      text-align: left; 
      font-weight: 700; 
      font-size: 12px; 
      text-transform: uppercase; 
      letter-spacing: 0.8px; 
    }
    .details-table td { 
      padding: 14px 15px; 
      border-bottom: 1px solid #ecf0f1; 
      font-size: 14px; 
    }
    .details-table tr:last-child td { 
      border-bottom: none; 
    }
    .amount { 
      text-align: right; 
      font-weight: 700; 
      color: #2c3e50; 
      font-size: 15px; 
    }
    .total-section { 
      background: linear-gradient(135deg, #34495e 0%, #2c3e50 100%); 
      padding: 30px; 
      margin: 30px 0; 
      border-radius: 10px; 
      box-shadow: 0 4px 10px rgba(0,0,0,0.1); 
    }
    .total-row { 
      display: flex; 
      justify-content: space-between; 
      margin: 8px 0; 
      font-size: 15px; 
      color: white; 
    }
    .total-row.final { 
      border-top: 2px solid rgba(255,255,255,0.3); 
      padding-top: 15px; 
      margin-top: 15px; 
      font-size: 24px; 
      font-weight: bold; 
      color: white; 
    }
    .pdf-notice { 
      background: linear-gradient(135deg, #d5f4e6 0%, #c8f0de 100%); 
      border-left: 5px solid #27ae60; 
      padding: 20px; 
      margin: 30px 0; 
      border-radius: 8px; 
    }
    .pdf-notice strong { 
      color: #27ae60; 
      display: block; 
      margin-bottom: 8px; 
      font-size: 15px; 
    }
    .pdf-notice p { 
      margin: 0; 
      font-size: 14px; 
      color: #27ae60; 
    }
    .notes-box { 
      background: #fff3cd; 
      border-left: 5px solid #f39c12; 
      padding: 20px; 
      margin: 25px 0; 
      border-radius: 8px; 
    }
    .notes-box strong { 
      color: #e67e22; 
      display: block; 
      margin-bottom: 10px; 
    }
    .notes-box p { 
      margin: 0; 
      font-size: 14px; 
      color: #5a4a35; 
    }
    .footer { 
      background: linear-gradient(135deg, #f8f9fa 0%, #ecf0f1 100%); 
      padding: 25px 30px; 
      text-align: center; 
      color: #7f8c8d; 
      font-size: 12px; 
      border-top: 1px solid #e0e0e0; 
    }
    .footer p { 
      margin: 5px 0; 
      font-weight: 500; 
    }
    .footer strong { 
      color: #2c3e50; 
    }
    .divider { 
      border: 0; 
      border-top: 1px solid #ecf0f1; 
      margin: 25px 0; 
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>📄 FACTURA DE VENTA</h1>
      <p>MarketMove - Gestor de Inventario y Ventas</p>
    </div>
    
    <div class="content">
      <div class="greeting">
        <p>Estimado/a <strong>$clientName</strong>,</p>
        <p>Agradecemos tu compra. Adjunto encontrarás la factura detallada de tu transacción en formato PDF.</p>
      </div>

      <div class="invoice-header">
        <h2>📋 Detalles de la Transacción</h2>
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
          <span class="label">Producto/Servicio:</span>
          <span class="value">$productName</span>
        </div>
      </div>

      <table class="details-table">
        <thead>
          <tr>
            <th>Concepto</th>
            <th style="text-align: right;">Importe</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Subtotal</td>
            <td class="amount">€${subtotal.toStringAsFixed(2)}</td>
          </tr>
          ${tax > 0 ? '<tr><td>Impuesto / IVA</td><td class="amount" style="color: #e74c3c;">+€${tax.toStringAsFixed(2)}</td></tr>' : ''}
          ${discount > 0 ? '<tr><td>Descuento / Promoción</td><td class="amount" style="color: #27ae60;">-€${discount.toStringAsFixed(2)}</td></tr>' : ''}
        </tbody>
      </table>

      <div class="total-section">
        <div class="total-row">
          <span>Subtotal neto:</span>
          <span>€${(total - tax).toStringAsFixed(2)}</span>
        </div>
        <div class="total-row final">
          <span>TOTAL PAGADO:</span>
          <span>€${total.toStringAsFixed(2)}</span>
        </div>
      </div>

      <div class="pdf-notice">
        <strong>✓ Factura en PDF Adjunta</strong>
        <p>Tu factura completa se encuentra adjunta a este correo. Descárgala para guardar tu registro.</p>
      </div>

      ${notes != null && notes.isNotEmpty ? '''
      <div class="notes-box">
        <strong>📝 Observaciones:</strong>
        <p>$notes</p>
      </div>
      ''' : ''}

      <hr class="divider">
      
      <p style="font-size: 13px; color: #7f8c8d; margin: 20px 0;">
        Si tienes alguna pregunta sobre esta factura o necesitas asistencia, no dudes en contactarnos. Estamos aquí para ayudarte en lo que necesites.
      </p>
    </div>

    <div class="footer">
      <p><strong>© 2025 MarketMove</strong></p>
      <p>Gestor profesional de inventario y ventas</p>
      <p style="margin-top: 10px; font-size: 11px; color: #95a5a6;">¡Gracias por tu confianza!</p>
    </div>
  </div>
</body>
</html>''';

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

  /// Email de informe diario para administradores
  Future<bool> sendDailyReportEmail({
    required String userEmail,
    required String userName,
    required String businessName,
    required int totalVentas,
    required int totalGastos,
    required double ingresoTotal,
    required double egresosTotal,
    required double ganancia,
    required int productosActivos,
    required int productosBajoStock,
    required Map<String, dynamic> topProduct,
  }) async {
    final gananciaNeta = ingresoTotal - egresosTotal;
    final porcentajeGanancia = ingresoTotal > 0 ? (gananciaNeta / ingresoTotal * 100) : 0;
    final fechaActual = DateTime.now();
    final fechaFormato = '${fechaActual.day} de ${_obtenerNombreMes(fechaActual.month)} de ${fechaActual.year}';

    final html = '''<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { 
      font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif; 
      line-height: 1.6; 
      color: #2c3e50; 
      background: linear-gradient(135deg, #ecf0f1 0%, #bdc3c7 100%);
      padding: 20px 0;
    }
    .container { 
      max-width: 800px; 
      margin: 0 auto; 
      background: white; 
      border-radius: 16px; 
      overflow: hidden; 
      box-shadow: 0 10px 40px rgba(0,0,0,0.1); 
    }
    .header { 
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
      color: white; 
      padding: 50px 30px; 
      text-align: center; 
    }
    .header h1 { 
      margin: 0; 
      font-size: 32px; 
      font-weight: bold; 
      letter-spacing: 0.5px; 
    }
    .header p { 
      margin: 10px 0 0 0; 
      font-size: 14px; 
      opacity: 0.95; 
    }
    .content { 
      padding: 40px 30px; 
    }
    .date-info { 
      background: #f5f7fa; 
      border-left: 5px solid #667eea; 
      padding: 15px 20px; 
      margin-bottom: 30px; 
      border-radius: 8px; 
      text-align: center;
    }
    .date-info p { 
      margin: 5px 0; 
      font-size: 14px;
    }
    .greeting { 
      font-size: 16px; 
      margin-bottom: 30px; 
      color: #2c3e50; 
      line-height: 1.8; 
    }
    .greeting strong { 
      color: #667eea; 
      font-weight: 700; 
    }
    .metrics-grid { 
      display: grid; 
      grid-template-columns: 1fr 1fr; 
      gap: 15px; 
      margin: 30px 0;
    }
    .metric-card { 
      background: linear-gradient(135deg, #f5f7fa 0%, #f0f4f8 100%); 
      border-left: 5px solid #667eea; 
      padding: 20px; 
      border-radius: 8px;
    }
    .metric-card.success { 
      border-left-color: #27ae60;
    }
    .metric-card.warning { 
      border-left-color: #f39c12;
    }
    .metric-card.danger { 
      border-left-color: #e74c3c;
    }
    .metric-label { 
      color: #7f8c8d; 
      font-size: 12px; 
      text-transform: uppercase; 
      font-weight: 600; 
      margin-bottom: 8px;
    }
    .metric-value { 
      font-size: 24px; 
      font-weight: 700; 
      color: #2c3e50;
    }
    .metric-card.success .metric-value { 
      color: #27ae60;
    }
    .metric-card.warning .metric-value { 
      color: #f39c12;
    }
    .top-product { 
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
      color: white; 
      padding: 25px; 
      margin: 30px 0; 
      border-radius: 10px;
    }
    .top-product h3 { 
      font-size: 16px; 
      margin-bottom: 15px; 
      font-weight: 700;
    }
    .top-product p { 
      margin: 8px 0; 
      font-size: 14px;
    }
    .summary-table { 
      width: 100%; 
      border-collapse: collapse; 
      margin: 30px 0; 
      background: white; 
      border: 1px solid #ecf0f1; 
      border-radius: 8px; 
      overflow: hidden;
    }
    .summary-table th { 
      background: #34495e; 
      color: white; 
      padding: 15px; 
      text-align: left; 
      font-weight: 600; 
      font-size: 12px; 
      text-transform: uppercase;
    }
    .summary-table td { 
      padding: 12px 15px; 
      border-bottom: 1px solid #ecf0f1; 
      font-size: 14px;
    }
    .summary-table tr:last-child td { 
      border-bottom: none;
    }
    .summary-table .label { 
      color: #7f8c8d; 
      font-weight: 600;
    }
    .summary-table .value { 
      color: #2c3e50; 
      font-weight: 700; 
      text-align: right;
    }
    .footer { 
      background: linear-gradient(135deg, #f5f7fa 0%, #f0f4f8 100%); 
      padding: 30px; 
      text-align: center; 
      color: #7f8c8d; 
      font-size: 12px; 
      border-top: 1px solid #e0e0e0;
    }
    .footer p { 
      margin: 5px 0;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>📊 Informe Diario</h1>
      <p>Resumen de operaciones de tu negocio</p>
    </div>
    
    <div class="content">
      <div class="date-info">
        <p><strong>$fechaFormato</strong></p>
        <p style="font-size: 13px; opacity: 0.8;">$businessName</p>
      </div>

      <div class="greeting">
        <p>Hola <strong>$userName</strong>,</p>
        <p>A continuación se presenta un resumen detallado de las operaciones de tu empresa para el día de hoy.</p>
      </div>

      <div class="metrics-grid">
        <div class="metric-card">
          <div class="metric-label">📈 Ventas del Día</div>
          <div class="metric-value">$totalVentas</div>
        </div>
        <div class="metric-card success">
          <div class="metric-label">💰 Ingresos Totales</div>
          <div class="metric-value">€${ingresoTotal.toStringAsFixed(2)}</div>
        </div>
        <div class="metric-card warning">
          <div class="metric-label">📉 Gastos ($totalGastos transacciones)</div>
          <div class="metric-value">€${egresosTotal.toStringAsFixed(2)}</div>
        </div>
        <div class="metric-card success">
          <div class="metric-label">💹 Ganancia (Ingresos - Gastos)</div>
          <div class="metric-value">€${gananciaNeta.toStringAsFixed(2)}</div>
        </div>
      </div>

      <table class="summary-table">
        <thead>
          <tr>
            <th>Concepto</th>
            <th style="text-align: right;">Valor</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="label">Margen de Ganancia</td>
            <td class="value">${porcentajeGanancia.toStringAsFixed(2)}%</td>
          </tr>
          <tr>
            <td class="label">Productos Activos</td>
            <td class="value">$productosActivos</td>
          </tr>
          <tr>
            <td class="label">Productos con Bajo Stock</td>
            <td class="value" style="color: #e74c3c;">$productosBajoStock</td>
          </tr>
        </tbody>
      </table>

      <div class="top-product">
        <h3>🏆 Producto Más Vendido</h3>
        <p><strong>${topProduct['nombre'] ?? 'N/A'}</strong></p>
        <p>Cantidad vendida: <strong>${topProduct['cantidad'] ?? 0} unidades</strong></p>
        <p>Ingresos: <strong>€${(topProduct['ingresos'] ?? 0).toStringAsFixed(2)}</strong></p>
      </div>

      <p style="font-size: 13px; color: #7f8c8d; line-height: 1.8; margin: 30px 0;">
        Este informe ha sido generado automáticamente por MarketMove y contiene un resumen de todas las operaciones de tu negocio en el día de hoy. 
        Si necesitas información más detallada, puedes acceder a tu panel de control en cualquier momento.
      </p>
    </div>

    <div class="footer">
      <p><strong>MarketMove © 2025</strong></p>
      <p>Gestor profesional de inventario y ventas</p>
      <p style="margin-top: 10px; opacity: 0.7;">Informe automatizado - Por favor, no responda a este email</p>
    </div>
  </div>
</body>
</html>''';

    return sendEmail(
      toEmail: userEmail,
      toName: userName,
      subject: '📊 Informe Diario - $businessName - ${fechaActual.day}/${fechaActual.month}/${fechaActual.year}',
      htmlContent: html,
    );
  }

  String _obtenerNombreMes(int mes) {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses[mes - 1];
  }
}
