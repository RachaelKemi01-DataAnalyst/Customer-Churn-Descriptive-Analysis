-- joining tables
CREATE OR REPLACE VIEW customer_churn_views AS
WITH cleaned_Customer_Summary AS
(
SELECT
customer_id,
total_orders,
total_spent,
total_returns,
last_purchase_days,
lifetime_value,
customer_segment,
churn_risk_score,
churn

FROM customers_summary
WHERE customer_id IS NOT NULL

),



--Data Transformation, null handing and deduplication of orders table
cleaned_Orders AS 
(
  SELECT
  order_id,
  customer_id,
  order_date,
  product_category,
  product_name,
  order_amount AS sales,
  delivery_days,
  order_status,
  COALESCE(return_reason, 'unknown') AS return_reason,
  customer_rating

  FROM orders
  WHERE order_id IS NOT NULL

  
),


--Data cleaning per table
--deduplication and handling missing values from customer's table
cleaned_Customers AS
(
  SELECT
  customer_id,
  age,
  CONCAT(first_name,' ', last_name) AS full_name,
  CASE 
  WHEN age BETWEEN 18 AND 25 THEN  '18-25'
   WHEN age BETWEEN 26 AND 35 THEN '26-35'
   WHEN age BETWEEN 36 AND 50 THEN '35-50'
  ELSE '50+'
  END AS age_group,
  gender,
  state,
  signup_date,
  tenure_months,
  CASE WHEN tenure_months BETWEEN 1 AND 12 THEN '1 year'
  WHEN tenure_months BETWEEN 13 AND 24 THEN '2 years'
  WHEN tenure_months BETWEEN 25 AND 36 THEN '3 years'
  ELSE 'Over 3 years'
  END AS tenure_group,
  membership_tier,
  income_group,
  preferred_device,
  referral_source
  FROM customers
  WHERE last_name IS NOT NULL
  AND customer_id IS NOT NULL
  
     


),


--Data Transformation, null handing and deduplication of payment tables
cleaned_Payments AS 
(
  SELECT
  payment_id,
  customer_id,
  payment_method,
  payment_status,
  payment_failures,
  subscription_active,
  subscription_fee,
  average_monthly_spend,
  last_payment_date
  FROM payment
  WHERE customer_id IS NOT NULL
  
),

--Data transformation, deduplication of Engagements table
cleaned_Engagements AS (
  SELECT 
  customer_id,
  wishlist_items,
  cart_abandon_rate,
  days_since_last_login,
  CASE 
   WHEN days_since_last_login BETWEEN 1 AND 90 THEN '3 months'
  WHEN days_since_last_login BETWEEN 91 AND 180 THEN '6 months'
  WHEN days_since_last_login BETWEEN 181 and 270 THEN '9 months'
  WHEN days_since_last_login BETWEEN 270 and 366 THEN '12 months'
  ELSE 'Over 1year'
  END AS days_since_last_login_group,
  email_open_rate

  FROM engagement
  WHERE customer_id IS NOT NULL
  
),

--data cleaning of support tickets table
cleaned_SuportTickets AS (
  SELECT
  ticket_id,
  customer_id,
  tickets_last_year,
  complaint_category,
  average_resolution_hours,
  escalated,
  issue_status
  FROM support_tickets
  WHERE customer_id IS NOT NULL

  )

  --tables joining
    SELECT
      cs.customer_id,
	  COUNT(cs.customer_id) AS frequency,
      c.full_name,
      c.age,
  c.age_group,
  c.gender,
  c.state,
  c.signup_date,
  c.tenure_months,
  c.tenure_group,
  c.membership_tier,
  c.income_group,
  c.preferred_device,
  c.referral_source,
      cs.total_orders,
      cs.total_spent,
	  MAX(cs.total_spent)  AS MONETARY,
      cs.total_returns,
     cs.last_purchase_days,
    cs.lifetime_value,
    cs.customer_segment,
   cs. churn_risk_score,
    cs.churn,
    o.order_date,
	(p.last_payment_date-MAX(o.order_date)) AS recency,
    o.product_category,
  o.product_name,
  o.sales,
  o. delivery_days,
  o.order_status,
  o.return_reason,
  o.customer_rating,
  p.payment_method,
  p.payment_status,
  p.payment_failures,
  p.subscription_active,
  p.subscription_fee,
  p.average_monthly_spend,
  p.last_payment_date,
  e.wishlist_items,
  e.cart_abandon_rate,
  e.days_since_last_login,
  e.days_since_last_login_group,
  e.email_open_rate
    FROM cleaned_Customer_Summary AS cs
LEFT JOIN cleaned_Customers AS c
  ON cs.customer_id = c.customer_id
  LEFT JOIN cleaned_Orders AS o
  ON cs.customer_id = o.customer_id
LEFT JOIN cleaned_Payments AS p
  ON cs.customer_id = p.customer_id
LEFT JOIN cleaned_Engagements AS e
  ON cs.customer_id = e.customer_id

	GROUP BY cs.customer_id,
	 c.full_name,
      c.age,
  c.age_group,
  c.gender,
  c.state,
  c.signup_date,
  c.tenure_months,
  c.tenure_group,
  c.membership_tier,
  c.income_group,
  c.preferred_device,
  c.referral_source,
      cs.total_orders,
      cs.total_spent,
      cs.total_returns,
     cs.last_purchase_days,
    cs.lifetime_value,
    cs.customer_segment,
   cs. churn_risk_score,
    cs.churn,
    o.order_date,
    o.product_category,
  o.product_name,
  o.sales,
  o. delivery_days,
  o.order_status,
  o.return_reason,
  o.customer_rating,
  p.payment_method,
  p.payment_status,
  p.payment_failures,
  p.subscription_active,
  p.subscription_fee,
  p.average_monthly_spend,
  p.last_payment_date,
  e.wishlist_items,
  e.cart_abandon_rate,
  e.days_since_last_login,
  e.days_since_last_login_group,
  e.email_open_rate;

SELECT * FROM customer_churn_views
Limit 5;



