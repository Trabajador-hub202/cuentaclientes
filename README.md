# contador_de_clientes
Aplicación móvil multiplataforma diseñada para pequeños comercios que permite trackear la conversión de clientes en relación con factores climáticos y temporales, ofreciendo métricas estadísticas y análisis visual offline.
## 🔗 Demo en Vivo & Capturas  
*🌐 Simulación en Vivo (Web): https://trabajador-hub202.github.io/cuentaclientes-web/
*   🎥 Demostración en Video:https://drive.google.com/file/d/1am_7sBolzMBbdaY6JaMTbsvblALWPGUY/view?usp=sharing 
## 🛠️ Stack Tecnológico & Arquitectura   
*   Framework:* Flutter (Dart)
*   Base de Datos Local: SQLite (paquete sqflite)
*   Gráficos Visuales: fl_chart
*   Manejo de Estado: Local / State Management Eficient
## ⚙️ Funcionalidades Clave
*Registro de Datos de Negocio: Captura asíncrona de flujo de clientes, transacciones efectivas y variables climáticas (soleado, nublado, lluvioso).
*   Módulo Estadístico Avanzado: Cálculo automatizado de tasa de conversión de los últimos 15 días.
*   Visualización de Datos: Gráficos de barras interactivos para analizar el rendimiento de ventas segmentado por clima.
*   Seguridad Local:* Panel de administración y borrado de base de datos protegido mediante hashing de contraseña local.
## 📁 Estructura del Código LimpioEl proyecto mantiene una separación clara de responsabilidades:
* /lib/models/: Modelos de datos para Clientes, Ventas y Clima.
* /lib/database/: Controlador y queries de SQLite (CRUD, INNER JOINs de estadísticas).
* /lib/screens/: Interfaces limpias (Registro de datos, Panel de Estadísticas).
