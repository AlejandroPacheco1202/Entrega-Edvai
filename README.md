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

## Proceso ETL ⚙️
- La capa Bronze está ubicada en Google Cloud: clase-476722.supermarket_sales.supermarket_sales. Allí se encuentra el CSV que fue extraido desde Kaggle. No se realizó ningún tipo de transformación.
- Luego de un análisis del dataset concluimos que estaba limpio y con los datos bien estructurados y sin faltantes.
- Solo se encontraron dos outliers que fueron eliminados.
- Creacion de dimensiones: Cliente, Producto, Fecha y Fact_ventas

## Codigo SQL para generar modelo de datos 
```sql
CREATE OR REPLACE TABLE `static-gravity-428518-i6.silver_layer2.dim_cliente` AS
WITH base AS (
  SELECT DISTINCT
    Customer_Name AS nombre_cliente,
    City AS ciudad,
    State AS estado,
    Region AS region
  FROM `clase-476722.ventas.ventas_2023_2024`
)
SELECT
  ROW_NUMBER() OVER (ORDER BY nombre_cliente, ciudad, estado) AS cliente_id, -- surrogate key
  nombre_cliente,
  ciudad,
  estado,
  region
FROM base;

CREATE OR REPLACE TABLE `static-gravity-428518-i6.silver_layer2.dim_producto` AS
WITH base AS (
  SELECT DISTINCT
    Product_Name AS nombre_producto,
    Category AS categoria,
    Sub_Category AS subcategoria
  FROM `clase-476722.ventas.ventas_2023_2024`
)
SELECT
  ROW_NUMBER() OVER (ORDER BY nombre_producto, categoria, subcategoria) AS producto_id, -- surrogate key
  nombre_producto,
  categoria,
  subcategoria
FROM base;

CREATE OR REPLACE TABLE `static-gravity-428518-i6.silver_layer2.dim_fecha` AS
WITH base AS (
  SELECT DISTINCT
    DATE(Order_Date) AS fecha
  FROM `clase-476722.ventas.ventas_2023_2024`
  WHERE Order_Date IS NOT NULL
)
SELECT
  fecha,
  EXTRACT(YEAR FROM fecha) AS anio,
  EXTRACT(MONTH FROM fecha) AS mes,
  EXTRACT(DAY FROM fecha) AS dia,
  EXTRACT(DAYOFWEEK FROM fecha) AS dia_semana_num,
  CASE EXTRACT(DAYOFWEEK FROM fecha)
    WHEN 1 THEN 'Domingo'
    WHEN 2 THEN 'Lunes'
    WHEN 3 THEN 'Martes'
    WHEN 4 THEN 'Miércoles'
    WHEN 5 THEN 'Jueves'
    WHEN 6 THEN 'Viernes'
    WHEN 7 THEN 'Sábado'
  END AS dia_semana,
  EXTRACT(WEEK FROM fecha) AS semana,
  EXTRACT(QUARTER FROM fecha) AS trimestre,
  CASE 
    WHEN EXTRACT(DAYOFWEEK FROM fecha) IN (1,7) THEN 'Fin de semana'
    ELSE 'Día laborable'
  END AS tipo_dia,
  CASE EXTRACT(MONTH FROM fecha)
    WHEN 1 THEN 'Enero'
    WHEN 2 THEN 'Febrero'
    WHEN 3 THEN 'Marzo'
    WHEN 4 THEN 'Abril'
    WHEN 5 THEN 'Mayo'
    WHEN 6 THEN 'Junio'
    WHEN 7 THEN 'Julio'
    WHEN 8 THEN 'Agosto'
    WHEN 9 THEN 'Septiembre'
    WHEN 10 THEN 'Octubre'
    WHEN 11 THEN 'Noviembre'
    WHEN 12 THEN 'Diciembre'
  END AS nombre_mes
FROM base
ORDER BY fecha;

CREATE OR REPLACE TABLE `static-gravity-428518-i6.silver_layer2.fact_ventas` AS
SELECT
  b.Order_ID AS order_id,
  DATE(b.Order_Date) AS fecha,
  c.cliente_id,                          -- FK hacia dim_cliente
  b.Customer_Name AS nombre_cliente,
  b.City AS ciudad,
  b.State AS estado,
  b.Region AS region,
  b.Product_Name AS nombre_producto,
  b.Category AS categoria,
  b.Sub_Category AS subcategoria,
  CAST(b.Quantity AS INT64) AS cantidad,
  CAST(b.Unit_Price AS NUMERIC) AS precio_unitario,
  CAST(b.Revenue AS NUMERIC) AS ingresos,
  CAST(b.Profit AS NUMERIC) AS beneficio
FROM `clase-476722.ventas.ventas_2023_2024` b
JOIN `static-gravity-428518-i6.silver_layer2.dim_cliente` c
  ON b.Customer_Name = c.nombre_cliente
 AND b.City = c.ciudad
 AND b.State = c.estado
 AND b.Region = c.region;
 ```



<img width="1127" height="736" alt="image" src="https://github.com/user-attachments/assets/bf4c5861-d949-4688-b23b-58f08284dbbe" />

## Modelo de datos en Power BI 📶
- En el modelo de datos se agregó una tabla para alojar las medidas DAX
- Además en el modelo semántico se agregó un Grupo de Cálculo con 3 Elementos de cálculo: unidades, ingreso y margen bruto. Con este Grupo de calculo podemos realizar visualizaciones dinámicas de estas 3 tipo de datos en un solo objeto y creando menos medidas para tal fin. Este herramienta permite configurar el tipo de dato ajutado a cada valor.

<img width="1423" height="768" alt="image" src="https://github.com/user-attachments/assets/f86aa9f8-0901-407d-98fc-99ea48c4fda5" />

## Diseño de lienzo

- Para el fondo de lienzo se utilizo la herramienta Figma. Utilizamos una plantilla que luego fuimos modificando a partir de las necesidades.

<img width="149" height="76" alt="image" src="https://github.com/user-attachments/assets/0b6f2e80-4b15-4aa9-951b-114a2a92f72f" />

## Dashboard de Ventas

Accede al informe completo en Power BI Service aquí:  
[Ver informe en Power BI Service](https://app.powerbi.com/groups/me/reports/0bf1f8b3-b7ab-48a8-90b1-da75416921a8/4e5a4001eb90d30187ae?experience=power-bi)

## Conclusiones
- Las ventas totales muestran una tendencia positiva en el último trimestre, con un crecimiento sostenido respecto al período anterior.

- El análisis comparativo con el año anterior muestra un incremento moderado en ingresos, aunque con diferencias significativas entre canales de venta

<img width="1406" height="800" alt="image" src="https://github.com/user-attachments/assets/9f8ff667-6d68-4575-b19f-ac571cce6d68" />

- El ticket promedio se mantuvo estable, lo que indica que los clientes compran cantidades similares, aunque con ligeras variaciones en categorías específicas

<img width="1376" height="781" alt="image" src="https://github.com/user-attachments/assets/8313301b-7238-4019-bdc0-a14733331917" />

- Los productos más vendidos concentran gran parte de los ingresos, mientras que existe un grupo de artículos con baja rotación que podrían revisarse.

<img width="1394" height="775" alt="image" src="https://github.com/user-attachments/assets/d324b318-35a0-4ed6-8b04-a00bf578e4ed" />

- La distribución geográfica de las ventas refleja que ciertas regiones aportan la mayoría de los ingresos, lo que abre la posibilidad de expandir esfuerzos comerciales en zonas menos activas.

<img width="1397" height="799" alt="image" src="https://github.com/user-attachments/assets/65426466-5586-4a41-837f-927d0603f706" />



