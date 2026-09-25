# Funnel and Retention Analysis for MercadoLibre

🌐 [English](#english) | [Español](#español)

---

<a name="english"></a>
## 🇬🇧 English

Conversion funnel and user retention analysis using SQL and Excel.

### 1. Context / Problem
This was an individual project developed as part of the **TripleTen Data Analyst certificate program**. The Mercado Libre process was analyzed from the first website visit through purchase completion, over the period from January 1, 2025, to August 31, 2025.

The objective was twofold:
1. Identify the stage in the process with the highest user drop-off.
2. Determine how user retention could be improved over time.

### 2. My Contribution
I was responsible for the full analysis: data extraction, funnel and retention analysis, metric interpretation, and the executive summary.

### 3. Process and Decisions
- **Data exploration and cleaning:** I started by exploring the dataset to understand its structure and cleaned it to ensure the funnel and cohort calculations would be accurate.
- **Conversion funnel analysis:** I broke down the user journey into its full sequence of stages (`first_visit` → `select_item` / `select_promotion` → `add_to_cart` → `begin_checkout` → `add_shipping_info` → `add_payment_info` → `purchase`) to calculate the conversion rate at each step and identify where users dropped off most.
- **Drop-off identification:** I focused on finding the largest percentage decrease between consecutive stages rather than looking at every metric equally, since that was the highest-leverage point for improvement — the analysis showed this occurred between the "select item" and "add to cart" stages, with only 11% of users who reached item selection proceeding to add the item to the cart.
- **Cohort retention analysis:** I analyzed retention by registration cohort (D7, D14, D21, D28) and by country, to see not just where users dropped off but how retention evolved over time and varied by market.
- **Improvement simulation:** I projected the potential impact of a 15% improvement at the critical drop-off stage, to translate the finding into an actionable, quantifiable recommendation rather than a purely descriptive insight.

### 4. Outcome / Learning
- Identified the critical stage of the funnel: the "select item" → "add to cart" step, where the largest drop-off occurs (only 11% of users who reach item selection add an item to the cart, despite 76.89% of visitors reaching that stage).
- Found that Uruguay ranks second in retention from the first visit, with the lowest drop-off rate at the "add to cart" step (22.73% retained), suggesting its practices could be a reference for other markets.
- Quantified retention decay across cohorts: 86.63% (D7), 55.42% (D14), 24.95% (D21), and 2.63% (D28) for users registered between January 1–6, 2025, showing retention drops sharply after the first week.
- Identified Mexico and Peru as the countries with the highest retention from D7 to D28 (3.1% and 3.2% respectively), and Colombia as the lowest (1.6% at D28).
- Delivered actionable recommendations: prioritize improvements to the "add to cart" stage (pricing, button functionality, product information) and implement weekly follow-up strategies in markets such as Peru and Mexico.

### 5. Tools Used
- SQL
- Excel
- Funnel and metric analysis

### 6. Evidence
- 📋 Executive summary (Context / Insights / Recommendations)
- 📊 SQL code

---
# Funnel y Análisis de Retención para MercadoLibre

<a name="español"></a>
## 🇪🇸 Español

Análisis del embudo de conversión y retención de usuarios utilizando SQL y Excel.

### 1. Contexto / Problema
Este fue un proyecto individual desarrollado como parte del **certificado de Data Analyst de TripleTen**. Se analizó el proceso de Mercado Libre desde la primera visita al sitio web hasta la compra completada, durante el período del 1 de enero de 2025 al 31 de agosto de 2025.

El objetivo tuvo dos partes:
1. Identificar la etapa del proceso con la mayor tasa de abandono de usuarios.
2. Determinar cómo podía mejorarse la retención de usuarios a lo largo del tiempo.

### 2. Mi Contribución
Fui responsable de todo el análisis: extracción de datos, análisis de embudo y retención, interpretación de métricas, y elaboración del resumen ejecutivo.

### 3. Proceso y Decisiones
- **Exploración y limpieza de datos:** Comencé explorando el dataset para entender su estructura y lo limpié para asegurar que los cálculos de embudo y cohortes fueran precisos.
- **Análisis del embudo de conversión:** Dividí el recorrido del usuario en su secuencia completa de etapas (`first_visit` → `select_item` / `select_promotion` → `add_to_cart` → `begin_checkout` → `add_shipping_info` → `add_payment_info` → `purchase`) para calcular la tasa de conversión en cada paso e identificar dónde abandonaban más los usuarios.
- **Identificación del punto de abandono:** Me enfoqué en encontrar la mayor caída porcentual entre etapas consecutivas en lugar de revisar todas las métricas por igual, ya que ese era el punto de mayor impacto para una mejora; el análisis mostró que esto ocurría entre las etapas de "selección de artículo" y "agregar al carrito", donde solo el 11% de los usuarios que llegaban a la selección de artículo procedían a agregarlo al carrito.
- **Análisis de retención por cohortes:** Analicé la retención por cohorte de registro (D7, D14, D21, D28) y por país, para ver no solo dónde abandonaban los usuarios, sino cómo evolucionaba la retención en el tiempo y su variación por mercado.
- **Simulación de mejora:** Proyecté el impacto potencial de una mejora del 15% en la etapa crítica de abandono, para traducir el hallazgo en una recomendación accionable y cuantificable, en lugar de un insight puramente descriptivo.

### 4. Resultado / Aprendizaje
- Se identificó la etapa crítica del embudo: el paso de "selección de artículo" a "agregar al carrito", donde ocurre la mayor caída (solo el 11% de los usuarios que llegan a la selección de artículo agregan un producto al carrito, a pesar de que el 76.89% de los visitantes llega a esa etapa).
- Se encontró que Uruguay ocupa el segundo lugar en retención desde la primera visita, con la menor tasa de abandono en el paso de "agregar al carrito" (22.73% de retención), lo que sugiere que sus prácticas podrían replicarse en otros mercados.
- Se cuantificó la caída de retención por cohortes: 86.63% (D7), 55.42% (D14), 24.95% (D21) y 2.63% (D28) para usuarios registrados entre el 1 y 6 de enero de 2025, mostrando una caída pronunciada después de la primera semana.
- Se identificó a México y Perú como los países con mayor retención de D7 a D28 (3.1% y 3.2% respectivamente), y a Colombia con la más baja (1.6% en D28).
- Se entregaron recomendaciones accionables: priorizar mejoras en la etapa de "agregar al carrito" (precios, funcionalidad del botón, presentación de información del producto) e implementar estrategias semanales de seguimiento en mercados, como Perú y México.

### 5. Herramientas Utilizadas
- SQL
- Excel
- Análisis de embudos y métricas

### 6. Evidencias
- 📋 Resumen ejecutivo (Contexto / Insights / Recomendaciones)
- 📊 Análisis completo y datos de soporte
