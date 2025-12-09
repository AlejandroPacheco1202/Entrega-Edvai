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
- Algunos productos tienen bajo volumen de ventas y podrían ser descontinuados.
- El ticket promedio varía significativamente entre clientes.
- El margen bruto tiene estacionalidad y puede optimizarse.
- La inteligencia de tiempo permite detectar tendencias y comparar períodos.

## 📐 Plan de métricas
- `Q_Total`: Unidades vendidas.
- `$_Total_Ingresos`: Ingresos totales.
- `$_Total_Margen_bruto`: Beneficio total.
- `Ticket_Promedio`: Ingresos promedio por venta.
- `Cantidad_Promedio_Ticket`: Unidades promedio por ticket.
- `Margen_Bruto_Promedio_Ticket`: Margen promedio por venta.
- `Ventas_Unidades_PY`: Unidades vendidas en el mismo período del año anterior.
- `Top5_Menos_Venta_Flag`: Identificador de productos con menor venta.

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

---

> Este proyecto fue desarrollado como parte de un trabajo práctico para demostrar habilidades en modelado de datos, DAX, diseño de dashboards y análisis de negocio.
