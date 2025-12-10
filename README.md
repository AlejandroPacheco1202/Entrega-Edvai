# 📊 Dashboard de Análisis de Ventas

## 📝 Descripción general
Este proyecto consiste en el desarrollo de un dashboard interactivo en Power BI, basado en un dataset de Kaggle cargado en BigQuery. El objetivo es analizar las ventas, márgenes y comportamiento de clientes a través de métricas clave y visualizaciones claras, utilizando un modelo dimensional optimizado.

## 🎯 Objetivo
Diseñar un dashboard profesional que permita:
- Visualizar KPIs esenciales como ingresos, unidades vendidas y margen bruto.
- Comparar el rendimiento mensual y anual.
- Identificar productos de bajo desempeño.
- Aplicar buenas prácticas de modelado, diseño visual y DAX.
  

## 🧪 Caso de estudio
El dataset representa transacciones de ventas con información de productos, clientes, fechas y beneficios. Se simula el análisis de una empresa minorista que busca mejorar su rentabilidad y tomar decisiones basadas en datos.

## 💡 Hipótesis de negocio
- El ticket promedio varía significativamente entre clientes.
- El margen bruto tiene estacionalidad y puede optimizarse.
- La inteligencia de tiempo permite detectar tendencias y comparar períodos.

## 📐 Plan de métricas
<img width="1640" height="528" alt="image" src="https://github.com/user-attachments/assets/e87b648f-e202-4d4c-8c66-87d69304442d" />


## 🧱 Modelo de datos
Modelo en estrella compuesto por:
- `fact_ventas`: tabla de hechos con ingresos, cantidad y beneficio.
- `dim_producto`: información de productos.
- `dim_cliente`: datos de clientes.
- `dim_fecha`: calendario con jerarquías de tiempo.

Relaciones:
- `fact_ventas[producto_id]` → `dim_producto[producto_id]`
- `fact_ventas[cliente_id]` → `dim_cliente[cliente_id]`
- `fact_ventas[fecha]` → `dim_fecha[fecha]`

## 🔜 Desarrollo del proyecto
- El dataset proviene de Kaggle: https://www.kaggle.com/datasets/yashyennewar/product-sales-dataset-2023-2024
- Elegí este data set por estar relacionado con ventas, tener muchos registros, ser de fácil comprensión y tener datos de 2 años completos lo que permitia realizar algunas medidas con inteligencia de tiempo.
- Luego realizada la preparacion, ingesta, transformación y conexión con Power BI detecté que el dataset no tenia muchas posibilidades para hacer análisis mas complejos. Por este motivo me limité a hacer una analítica descripitva sencilla con algunas medidas comparativas de tiempo.
## 📉 Columnas del dataset 📉

<img width="601" height="485" alt="image" src="https://github.com/user-attachments/assets/c4b10474-742f-4dfb-890a-74481f1223fb" />



##  Diagrama Entidad-Relacion 
<img width="1322" height="1059" alt="Copy of Modelo de datos Delivery" src="https://github.com/user-attachments/assets/c326dac1-36b2-4a7b-a77a-fd4a46f03118" />

##  Código en dbdiagram.io 
<img width="756" height="833" alt="image" src="https://github.com/user-attachments/assets/f09afb9c-9e98-4051-8966-fb996e8f34ea" />


## Pipeline de datos
Se utilizo la estructura de medallón.
<img width="850" height="335" alt="image" src="https://github.com/user-attachments/assets/b4b6568a-a4b8-4d1c-ac9a-e4a035d8d19f" />



---

> Este proyecto fue desarrollado como parte de un trabajo práctico para demostrar habilidades en modelado de datos, DAX, diseño de dashboards y análisis de negocio.
