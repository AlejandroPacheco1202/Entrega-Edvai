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
  --ROW_NUMBER() OVER (ORDER BY fecha) AS fecha_id,   -- surrogate key
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

