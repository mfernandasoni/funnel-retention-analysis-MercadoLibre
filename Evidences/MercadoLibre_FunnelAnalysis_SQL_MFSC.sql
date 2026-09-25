--Objetivo: Conocer la estructura de la tabla mercadolibre_funnel
SELECT *
FROM mercadolibre_funnel
LIMIT 5;

--Objetivo: Conocer la estructura de la tabla mercadolibre_retention
SELECT*
FROM mercadolibre_retention
LIMIT 5;

--Objetivo: confirmar la secuencia del embudo de la tabla mercadolibre_funnel 
SELECT DISTINCT event_name
FROM mercadolibre_funnel
ORDER BY event_name;

--Objetivo: Construir bloques de usuarios únicos por evento (CTEs) en el rango 
--2025-01-01 → 2025-08-31, unirlos y contar usuarios por etapa del embudo.
WITH cte_first_visit AS(
SELECT DISTINCT user_id
FROM mercadolibre_funnel
WHERE event_name = 'first_visit' AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),

cte_select_item AS(
SELECT DISTINCT user_id
FROM mercadolibre_funnel
WHERE (event_name = 'select_item' OR event_name= 'select_promotion') AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),

cte_add_to_cart AS(
SELECT DISTINCT user_id
FROM mercadolibre_funnel
WHERE event_name = 'add_to_cart' AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),

cte_begin_checkout AS(
SELECT DISTINCT user_id
FROM mercadolibre_funnel
WHERE event_name = 'begin_checkout' AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),

cte_add_shipping_info AS(
SELECT DISTINCT user_id
FROM mercadolibre_funnel
WHERE event_name = 'add_shipping_info' AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),

cte_add_payment_info AS(
SELECT DISTINCT user_id
FROM mercadolibre_funnel
WHERE event_name = 'add_payment_info' AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),

cte_purchase AS(
SELECT DISTINCT user_id
FROM mercadolibre_funnel
WHERE event_name = 'purchase' AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
)

SELECT 
    COUNT(DISTINCT fv.user_id) AS usuarios_fist_visit,
    COUNT(DISTINCT s.user_id) AS usuarios_select_item,
    COUNT(DISTINCT c.user_id) AS usuarios_add_to_cart,
    COUNT(DISTINCT bc.user_id) AS usuarios_begin_checkout,
    COUNT(DISTINCT asi.user_id) AS usuarios_add_shipping_info,
    COUNT(DISTINCT api.user_id) AS usuarios_add_payment_info,
    COUNT(DISTINCT p.user_id) AS usuarios_purchase

from cte_first_visit AS fv
LEFT JOIN cte_select_item AS s ON fv.user_id = s.user_id
LEFT JOIN cte_add_to_cart AS c ON fv.user_id = c.user_id
LEFT JOIN cte_begin_checkout AS bc ON fv.user_id = bc.user_id
LEFT JOIN cte_add_shipping_info AS asi ON fv.user_id = asi.user_id
LEFT JOIN cte_add_payment_info AS api ON fv.user_id = api.user_id
LEFT JOIN cte_purchase AS p ON fv.user_id = p.user_id;

--Objetivo: A partir de los conteos por etapa del embudo, calcular el 
--porcentaje de conversión desde la etapa inicial (first_visit) hacia cada etapa.

--Resultado: General Funnel

WITH first_visit AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'first_visit'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
select_item AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name IN ('select_item', 'select_promotion')
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_to_cart AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'add_to_cart'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
begin_checkout AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'begin_checkout'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_shipping_info AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'add_shipping_info'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_payment_info AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'add_payment_info'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
purchase AS (
  SELECT DISTINCT user_id
  FROM mercadolibre_funnel
  WHERE event_name = 'purchase'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
), 
funnel_counts AS(
SELECT
  COUNT(fv.user_id) AS usuarios_first_visit,
  COUNT(si.user_id) AS usuarios_select_item,
  COUNT(a.user_id) AS usuarios_add_to_cart,
  COUNT(bc.user_id) AS usuarios_begin_checkout,
  COUNT(asi.user_id) AS usuarios_add_shipping_info,
  COUNT(api.user_id) AS usuarios_add_payment_info,
  COUNT(p.user_id) AS usuarios_purchase
FROM first_visit fv
LEFT JOIN select_item si        ON fv.user_id = si.user_id
LEFT JOIN add_to_cart a         ON fv.user_id = a.user_id
LEFT JOIN begin_checkout bc     ON fv.user_id = bc.user_id
LEFT JOIN add_shipping_info asi ON fv.user_id = asi.user_id
LEFT JOIN add_payment_info api  ON fv.user_id = api.user_id
LEFT JOIN purchase p            ON fv.user_id = p.user_id
)

-- ESCRIBE TU CODIGO AQUI
SELECT
ROUND(usuarios_select_item *100.0 / NULLIF(usuarios_first_visit,0),2) AS conversion_select_items,
ROUND(usuarios_add_to_cart *100.0 / NULLIF(usuarios_first_visit,0),2) AS conversion_add_to_cart,
ROUND(usuarios_begin_checkout *100.0 / NULLIF(usuarios_first_visit,0),2) AS conversion_begin_checkout,
ROUND(usuarios_add_shipping_info *100.0 / NULLIF(usuarios_first_visit,0),2) AS conversion_add_shipping_info,
ROUND(usuarios_add_payment_info *100.0 / NULLIF(usuarios_first_visit,0),2) AS conversion_add_payment_info,
ROUND(usuarios_purchase *100.0 / NULLIF(usuarios_first_visit,0),2) AS conversion_purchase

FROM funnel_counts;

--Objetivo: Agrupar las conversiones del embudo por país (country) 
--y detectar en que etapa del funnel se pierde más a los usuarios.

--Resultado: General Funnel by Country

WITH first_visits AS (
  SELECT DISTINCT user_id,
    country
  FROM mercadolibre_funnel
  WHERE event_name = 'first_visit'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
select_item AS (
  SELECT DISTINCT user_id,
     country
  FROM mercadolibre_funnel
  WHERE event_name IN ('select_item', 'select_promotion')
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_to_cart AS (
  SELECT DISTINCT user_id,
     country
  FROM mercadolibre_funnel
  WHERE event_name = 'add_to_cart'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
begin_checkout AS (
  SELECT DISTINCT user_id,
     country
  FROM mercadolibre_funnel
  WHERE event_name = 'begin_checkout'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_shipping_info AS (
  SELECT DISTINCT user_id,
     country
  FROM mercadolibre_funnel
  WHERE event_name = 'add_shipping_info'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_payment_info AS (
  SELECT DISTINCT user_id,
     country
  FROM mercadolibre_funnel
  WHERE event_name = 'add_payment_info'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
purchase AS (
  SELECT DISTINCT user_id,
     country
  FROM mercadolibre_funnel
  WHERE event_name = 'purchase'
    AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),

funnel_counts AS(
SELECT
  fv.country,
  COUNT( fv.user_id) AS usuarios_first_visit,
  COUNT(DISTINCT si.user_id) AS usuarios_select_item,
  COUNT(DISTINCT a.user_id) AS usuarios_add_to_cart,
  COUNT(DISTINCT bc.user_id) AS usuarios_begin_checkout,
  COUNT(DISTINCT asi.user_id) AS usuarios_add_shipping_info,
  COUNT(DISTINCT api.user_id) AS usuarios_add_payment_info,
  COUNT(DISTINCT p.user_id) AS usuarios_purchase
FROM first_visits fv
LEFT JOIN select_item si        ON fv.user_id = si.user_id AND fv.country = si.country
LEFT JOIN add_to_cart a         ON fv.user_id = a.user_id AND fv.country = a.country
LEFT JOIN begin_checkout bc     ON fv.user_id = bc.user_id AND fv.country = bc.country
LEFT JOIN add_shipping_info asi ON fv.user_id = asi.user_id AND fv.country = asi.country
LEFT JOIN add_payment_info api  ON fv.user_id = api.user_id AND fv.country = api.country
LEFT JOIN purchase p            ON fv.user_id = p.user_id AND fv.country = p.country

GROUP BY fv.country
)

SELECT
country,
-- Calculo conversion_select_item,
usuarios_select_item * 100.0 / NULLIF(usuarios_first_visit,0) AS conversion_select_item,
-- Calculo conversion_add_to_cart,
usuarios_add_to_cart * 100.0 / NULLIF(usuarios_first_visit,0) AS conversion_add_to_cart,
-- Calculo conversion_begin_checkout,
usuarios_begin_checkout * 100.0 / NULLIF(usuarios_first_visit,0) AS conversion_begin_checkout,
-- Calculo conversion_add_shipping_info,
usuarios_add_shipping_info * 100.0 / NULLIF(usuarios_first_visit,0) AS conversion_add_shipping_info,
-- Calculo conversion_add_payment_info,
usuarios_add_payment_info * 100.0 / NULLIF(usuarios_first_visit,0) AS conversion_add_payment_info,
-- Calculo conversion_purchase
usuarios_purchase * 100.0 / NULLIF(usuarios_first_visit,0) AS conversion_purchase

FROM funnel_counts
-- Ordena
ORDER BY conversion_purchase DESC;

--Objetivo: Para cada país, obtener porcentaje de activos acumulados desde su registro, 
--en el rango 2025-01-01 → 2025-08-31, al día 7, día 14, día 21 y día 28.

--Resultado: Retention by Country

SELECT
  country,

ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END) *100.0 /NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d7_pct,

ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 14  AND active = 1 THEN user_id END) *100.0 /NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d14_pct,

ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 21  AND active = 1 THEN user_id END) *100.0 /NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d21_pct,

ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 28  AND active = 1 THEN user_id END) *100.0 /NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d28_pct
    
FROM mercadolibre_retention
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY country;

--Objetivo: Para cada cohorte mensual (YYYY-MM), calcular el % de usuarios 
--activos al día 7, 14, 21, y 28  desde su registro.

--Resultado: Retention by Cohort

-- 1) CTE para cohorte:
WITH cohort AS (
SELECT
user_id,
TO_CHAR(DATE_TRUNC('month', MIN(signup_date)), 'YYYY-MM') AS cohort
FROM mercadolibre_retention
GROUP BY user_id
),

/* 2) CTE activity: tomar columnas claves de mercadolibre_retention y añadir el cohort  */
activity AS (
SELECT 
r.user_id,
cohort,
r.day_after_signup,
r.active

FROM mercadolibre_retention AS r
LEFT JOIN cohort AS c ON c.user_id = r.user_id
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31' 
)

/* 3) SELECT final: conteos exactos por día acumulado X / tamaño de cohorte -> % redondeado*/
SELECT 
    cohort,
    ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END) *100.0 /NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d7_pct,

    ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 14  AND active = 1 THEN user_id END) *100.0 /NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d14_pct,

ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 21  AND active = 1 THEN user_id END) *100.0 /NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d21_pct,

ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 28  AND active = 1 THEN user_id END) *100.0 /NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d28_pct
    
FROM activity
GROUP BY cohort
ORDER BY cohort;

