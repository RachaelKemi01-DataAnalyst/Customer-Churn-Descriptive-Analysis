/*  Fact table is customers_summary table linked with 5 dimension table on customer_id */

CREATE TABLE customers_summary
(
  customer_id INT,
  total_orders INT,
  total_spent DECIMAL(12,5),
  average_order_value DECIMAL(12,5),
  total_returns INT,
  return_rate DECIMAL(12,5),
  loyalty_points INT,
  last_purchase_days INT,
  purchase_frequency DECIMAL(12,5),
  lifetime_value DECIMAL(12,5),
  customer_segment TEXT,
  churn_risk_score DECIMAL(12,5),
  churn BOOL

);

CREATE TABLE customers
(
  customer_id INT,
  first_name TEXT,
  last_name INT,
  age INT,
  gender TEXT,
  city TEXT,
  state TEXT,
  country TEXT,
  signup_date DATE,
  tenure_months INT,
  membership_tier TEXT,
  occupation TEXT,
  income_group TEXT,
  marital_status TEXT,
  education TEXT,
  preferred_device TEXT,
  referral_source TEXT
);


CREATE TABLE orders(
  order_id INT,
  customer_id INT,
  order_date DATE,
  product_category TEXT,
  product_name TEXT,
  quantity INT,
  unit_price DECIMAL(12,5),
  discount_percent INT,
  order_amount DECIMAL(12,5),
  payment_method TEXT,
  coupon_used BOOL,
  delivery_days TEXT,
  order_status TEXT,
  returned BOOL,
  return_reason TEXT,
  seller_rating DECIMAL(5,2),
  customer_rating INT
);

CREATE TABLE engagement (
  customer_id INT,
  app_usage_minutes INT,
  website_sessions INT,
  avg_session_duration DECIMAL(12,5),
  search_frequency INT,
  pages_viewed INT,
  wishlist_items INT,
  cart_abandon_rate DECIMAL(12,5),
  notification_click_rate DECIMAL(12,5),
  email_open_rate DECIMAL(12,5),
  days_since_last_login INT
);

CREATE TABLE payments
(
  payment_id INT,
  customer_id INT,
  payment_method TEXT,
  payment_status TEXT,
  payment_failures INT,
  refund_amount DECIMAL(12,5),
  subscription_active BOOL,
  subscription_fee INT,
  last_payment_date DATE,
  average_monthly_spend DECIMAL(12,5)
);

CREATE TABLE support_tickets
(
  ticket_id INT,
  customer_id INT,
  tickets_last_year INT,
  complaint_category TEXT,
  average_resolution_hours INT,
  satisfaction_score DECIMAL(12,5),
  escalated BOOL,
  issue_status TEXT
);