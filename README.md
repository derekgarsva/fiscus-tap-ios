# 💳 Fiscus Tap - iOS Contactless POS App

Aplicación nativa en **Flutter / Dart** para convertir cualquier **iPhone 11** (o superior con iOS 16+) en un datáfono contactless profesional.

Acepta pagos con tarjetas Visa, Mastercard, American Express, Apple Pay y Google Wallet utilizando la antena **CoreNFC** integrada en el iPhone.

---

## 🚀 Arquitectura y Tecnologías
- **Framework**: Flutter (Channel Stable) + Dart
- **Diseño**: Apple Fintech Obsidian & Cobalt Theme
- **NFC Engine**: `flutter_nfc_kit` con soporte para CoreNFC (ISO 14443 Type A/B y ISO 7816 Smartcards)
- **Haptic Engine**: Respuesta háptica física personalizada para cada etapa de la transacción
- **Tickets Digitales**: Generador de recibos con código QR escaneable y envío directo a WhatsApp
- **CI/CD Cloud Build**: Compilación automatizada en macOS 14 mediante GitHub Actions

---

## 📲 Instalación Directa en iPhone 11 desde Windows

Dado que estás en una laptop con Windows, no necesitas una computadora Mac para instalar esta aplicación:

1. **Descarga el instalador `.ipa`**:
   - Ve a la pestaña **[Releases](https://github.com/derekgarsva/fiscus-tap-ios/releases)** de este repositorio y descarga `FiscusTap-v1.0.0-iPhone11.ipa`.
2. **Conecta tu iPhone 11**:
   - Conéctalo con su cable USB a tu laptop Windows. Pulsa "Confiar en este ordenador" en la pantalla del iPhone si aparece.
3. **Instala vía Sideloadly (100% Gratuito)**:
   - Descarga e instala **[Sideloadly para Windows](https://sideloadly.io/)**.
   - Abre Sideloadly en tu laptop.
   - Arrastra el archivo `FiscusTap-v1.0.0-iPhone11.ipa` a la ventana.
   - Escribe tu Apple ID (cualquier cuenta normal gratuita de Apple).
   - Haz clic en **Start**.
4. **Activación en el iPhone**:
   - En ~60 segundos el icono de **Fiscus Tap** aparecerá en la pantalla de inicio de tu iPhone 11.
   - Ve a `Ajustes > General > VPN y gestión de dispositivos` y pulsa "Confiar".
   - ¡Listo! Abre Fiscus Tap y cobra con NFC.

---

© 2026 Fiscus Tap Inc. Todos los derechos reservados.
