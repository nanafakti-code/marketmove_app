# 📧 Configuración de Brevo para Envío de Correos

## 🎯 ¿Qué es Brevo?
Brevo (anteriormente Sendinblue) es un servicio de email marketing y transaccional que permite enviar correos de forma confiable.

---

## 📝 Pasos para Configurar Brevo

### 1️⃣ **Crear una Cuenta en Brevo**
1. Ve a https://www.brevo.com
2. Haz clic en **"Sign up"** (Registrarse)
3. Completa el formulario:
   - Email
   - Nombre
   - Contraseña
4. Confirma tu email verificando el link enviado

### 2️⃣ **Obtener las Credenciales SMTP**

#### Opción A: Usar Credenciales SMTP Generadas
1. Inicia sesión en Brevo: https://app.brevo.com
2. Ve a **Settings** (Configuración) → **SMTP & API**
3. En la sección **SMTP**, verás:
   - **SMTP Server**: `smtp-relay.brevo.com`
   - **Port**: `587`
   - **Username**: Tu email de Brevo (ej: `tu@email.com`)
   - **Password**: Tu contraseña de Brevo

#### Opción B: Generar una API Key (Más seguro)
1. En **Settings** → **SMTP & API**
2. Ve a **SMTP Credentials**
3. Haz clic en **Generate New SMTP Credentials**
4. Completa el formulario:
   - **Name**: `MarketMove-Flutter`
   - Haz clic en **Generate**
5. Te dará:
   - **Login**: (tu usuario)
   - **Password**: (copia y guarda esto)

### 3️⃣ **Configurar el archivo `.env`**

Crea un archivo `.env` en la raíz del proyecto con:

```env
# Configuración de Brevo SMTP
BREVO_SMTP_USER=tu_email@gmail.com
BREVO_SMTP_PASSWORD=tu_contraseña_brevo
BREVO_SENDER_EMAIL=tu_email@gmail.com

# Supabase
SUPABASE_URL=https://tuproyecto.supabase.co
SUPABASE_ANON_KEY=tu_anon_key
```

> ⚠️ **IMPORTANTE**: 
> - Nunca comitees el archivo `.env` a GitHub
> - Ya está en `.gitignore`
> - Guarda tus credenciales de forma segura

### 4️⃣ **Configurar un Email Verificado en Brevo**

Para enviar correos, necesitas verificar un email remitente:

1. Ve a **Settings** → **Senders & Emails**
2. Haz clic en **Add a sender**
3. Completa los datos:
   - **Sender name**: `MarketMove`
   - **Sender email**: Tu email verificado (debe ser el mismo que en `BREVO_SENDER_EMAIL`)
4. Verifica el email confirmando el link enviado por Brevo

---

## ✅ Verificar que Funciona

### Prueba Local
1. Ejecuta la app:
   ```bash
   flutter run
   ```

2. Crea una nueva cuenta (Registro)
3. Deberías ver en la consola:
   ```
   📧 Enviando email de bienvenida a usuario@email.com
   🚀 Intentando enviar mensaje...
   ✅ Email de bienvenida enviado exitosamente a usuario@email.com
   ```

4. Comprueba el email recibido en tu bandeja de entrada

### Prueba de Venta
1. Crea una venta desde la app
2. Proporciona un email de cliente válido
3. Deberías recibir un recibo detallado en ese email

---

## 🔍 Solucionar Problemas

### ❌ "Credenciales SMTP no configuradas"
- Verificar que el archivo `.env` existe en la raíz
- Verificar que `BREVO_SMTP_USER` está configurado
- Verificar que `BREVO_SMTP_PASSWORD` está configurado

### ❌ "Error SMTP: 535 Authentication failed"
- Las credenciales son incorrectas
- Verificar en Brevo que están bien copiadas
- Probar con usuario/contraseña nuevos

### ❌ "Error: Email del cliente inválido"
- El email del cliente tiene formato incorrecto
- Verificar que contenga `@`
- Ejemplo válido: `cliente@empresa.com`

### ❌ "No recibo el email"
- Verificar bandeja de SPAM
- Verificar que el email es correcto
- Verificar que el sender es verificado en Brevo
- Revisar logs en la consola de Flutter

---

## 📊 Límites de Brevo

**Plan Gratuito:**
- ✅ 300 correos/día
- ✅ Contactos ilimitados
- ✅ Soporte por email

**Plan de Pago:**
- Correos ilimitados
- Automatizaciones avanzadas
- Soporte prioritario

---

## 🎯 Estructura de Correos

### Email de Bienvenida
- Se envía cuando el usuario se registra
- Contiene bienvenida + instrucciones
- Gradiente púrpura

### Email de Recibo de Venta
- Se envía cuando se crea una venta
- Contiene detalles de la venta
- Cliente, número, total, impuestos, descuentos
- Gradiente verde
- Método de pago

---

## 📞 Soporte

- **Documentación Brevo**: https://developers.brevo.com
- **Documentación Mailer Dart**: https://pub.dev/packages/mailer
- **Email de soporte**: support@brevo.com

