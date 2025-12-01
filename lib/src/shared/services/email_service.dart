import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static Future<bool> sendWelcomeEmail({
    required String email,
    required String fullName,
    required String businessName,
  }) async {
    try {
      final smtpUsername = dotenv.env['BREVO_SMTP_USER'];
      final smtpPassword = dotenv.env['BREVO_SMTP_PASSWORD'];
      final senderEmail = dotenv.env['BREVO_SENDER_EMAIL'];
      
      if (smtpUsername == null || smtpPassword == null || senderEmail == null) {
        print('❌ Error: Credenciales SMTP no configuradas');
        return false;
      }
      
      print('📧 Enviando email de bienvenida a $email');

      // Configurar servidor SMTP de Brevo
      final smtpServer = SmtpServer(
        'smtp-relay.brevo.com',
        port: 587,
        username: smtpUsername,
        password: smtpPassword,
        allowInsecure: false,
      );

      // Crear mensaje
      final message = Message()
        ..from = Address(senderEmail, 'MarketMove')
        ..recipients.add(email)
        ..subject = '¡Bienvenido a MarketMove!'
        ..html = _getWelcomeEmailTemplate(
          fullName: fullName,
          businessName: businessName,
        );

      // Enviar email
      await send(message, smtpServer);
      print('✅ Email de bienvenida enviado a $email');
      return true;
    } catch (e) {
      print('🔥 Error enviando email: $e');
      return false;
    }
  }

  static String _getWelcomeEmailTemplate({
    required String fullName,
    required String businessName,
  }) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 20px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
        }
        .content {
            padding: 30px 20px;
            color: #333;
        }
        .content h2 {
            color: #667eea;
            font-size: 20px;
            margin-top: 0;
        }
        .content p {
            line-height: 1.6;
            margin: 15px 0;
        }
        .features {
            background-color: #f9f9f9;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin: 20px 0;
            border-radius: 5px;
        }
        .features ul {
            margin: 10px 0;
            padding-left: 20px;
        }
        .features li {
            margin: 8px 0;
        }
        .button {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border-radius: 5px;
            text-decoration: none;
            margin: 20px 0;
            font-weight: bold;
        }
        .footer {
            background-color: #f5f5f5;
            padding: 20px;
            text-align: center;
            color: #666;
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
            <h1>🎉 ¡Bienvenido a MarketMove!</h1>
        </div>
        
        <div class="content">
            <h2>Hola $fullName,</h2>
            
            <p>Tu cuenta ha sido creada exitosamente. Estamos emocionados de tenerte como parte de la familia MarketMove.</p>
            
            <p><strong>Datos de tu negocio:</strong></p>
            <p>📦 Nombre del negocio: <strong>$businessName</strong></p>
            <p>📧 Email registrado: <strong>Tu email</strong></p>
            
            <div class="features">
                <p><strong>¿Qué puedes hacer ahora?</strong></p>
                <ul>
                    <li>Gestionar tu inventario de productos</li>
                    <li>Registrar tus ventas diarias</li>
                    <li>Controlar tus gastos operacionales</li>
                    <li>Ver resumen de ganancias</li>
                    <li>Acceder desde cualquier dispositivo</li>
                </ul>
            </div>
            
            <p>Para comenzar a usar MarketMove, solo necesitas iniciar sesión con tus credenciales.</p>
            
            <p><strong>Próximos pasos:</strong></p>
            <ol>
                <li>Configura tu perfil de negocio</li>
                <li>Añade tus productos al inventario</li>
                <li>Comienza a registrar tus ventas</li>
                <li>Monitorea tu desempeño financiero</li>
            </ol>
            
            <p>Si tienes alguna pregunta o necesitas ayuda, no dudes en contactarnos.</p>
            
            <p>¡Esperamos que disfrutes usando MarketMove!</p>
            
            <p>Saludos,<br>
            <strong>El equipo de MarketMove</strong></p>
        </div>
        
        <div class="footer">
            <p>© 2025 MarketMove. Todos los derechos reservados.</p>
            <p>Este es un correo automático, por favor no responder a esta dirección.</p>
            <p>Si no solicitaste crear una cuenta, por favor contacta con nosotros.</p>
        </div>
    </div>
</body>
</html>
    ''';
  }
}
