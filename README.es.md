# Doki Doki Tri-Line Quest (DDTLQ) — Español

**Menos lentitud en la ciudad, r9:** Los paneles y textos invisibles ya no se dibujan. Tres diseños verificados usan como máximo nueve llamadas. Las 108 comparaciones coinciden píxel a píxel. La ciudad nocturna pasó de 4,31 a 0,41 ms de procesamiento en Windows y de 5,52 a 0,53 ms de scripts con datos Android en el ejecutor local. No son FPS medidos en un teléfono; falta probarlo en el móvil. Se conserva la corrección de inicio r8.

**Corrección de cierre en Android, r8:** Los descriptores ZIP incoherentes de los APK r7 impedían cargar las clases de inicio. Todas las versiones normalizan las cabeceras antes de firmar y comprueban la estructura y los CRC después. Vuelve a crear el APK con r8. Falta repetir la prueba en el teléfono afectado.

## Windows
1. Extrae el paquete completo del parche. Ten tu propia copia compatible de DDTLQ 2.01.04 Beta para Windows.
2. Ejecuta `WindowsPatch.bat`, elige **5 — Español** y pulsa **Enter**.
3. Indica la carpeta del juego original. Inicia la nueva copia creada en `output`; los originales se conservan.

## Android
1. En Windows, ejecuta `Build-APK.bat`, elige **5 — Español** y pulsa **Enter**.
2. Indica la misma carpeta del juego original para Windows. No necesitas un APK original ni una instalación previa en Android.
3. El proceso prepara las herramientas y crea un APK firmado en `output`. Transfiérelo e instálalo en un dispositivo **Android 7 o posterior, ARM64**.

La distribución pública contiene el parche y las herramientas; cada jugador aporta su propia copia compatible del juego.

Toca la pantalla para hacer clic; mantén el dedo y muévelo para arrastrar. L/R seleccionan el botón izquierdo/derecho del ratón; normalmente usa L. Abre el menú de ayuda con el botón superior. Arrastrar por una opción no la activa.

[简体中文](README.md) · [English](README.en.md) · [Português](README.pt-BR.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [한국어](README.ko.md) · [Türkçe](README.tr.md)

## Xbox

Los mandos Xbox tienen soporte nativo. Muévete con el stick izquierdo (LS) o la cruceta; A confirma e inicia conversaciones, B vuelve atrás y Start pausa. Y o View abre Ayuda. El stick derecho (RS) mueve el cursor virtual; RT o X hace clic izquierdo y permite arrastrar al mantenerlo pulsado; LT hace clic derecho. Mantén LB para mover el cursor con precisión o RB para acelerarlo. Conecta el mando por USB o Bluetooth y deja que el sistema lo reconozca; no necesitas programas de asignación de botones.

Tras conectar el mando o volver al juego, suelta los botones y centra los sticks antes de continuar.
