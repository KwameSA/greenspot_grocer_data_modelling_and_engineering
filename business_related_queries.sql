-- Retrieve customer sales details including customer ID, transaction date, product description, and sale price.
SELECT 
    s.customer_id, 
    it.transaction_date, 
    p.product_description, 
    s.sale_price
FROM 
    sale_transaction_t s
JOIN 
    inventory_transaction_t it ON s.transaction_id = it.transaction_id
JOIN 
    product_t p ON s.product_item_id = p.product_item_id;

-- List purchase transaction details: transaction ID, date, quantity changed, wholesale cost, and vendor name.
select 
      it.transaction_id, 
      it.transaction_date, 
      it.quantity_changed, 
      p.wholesale_cost, 
      v.vendor_name
from 
	  inventory_transaction_t it
INNER JOIN purchase_t p on it.transaction_id = p.transaction_id
INNER JOIN vendor_t v on p.vendor_id = v.vendor_id

-- Aggregate total quantity sold per product, ordered from highest to lowest sales volu
select 
	  p.product_description, 
      abs(sum(quantity_changed)) as total_sold
from 
	  sale_transaction_t s
join inventory_transaction_t it on it.transaction_id = s.transaction_id
join product_t p on s.product_item_id = p.product_item_id
group by p.product_description
order by total_sold desc

-- Calculate total quantity sold by each location, ordered from highest to lowest.
select
	  i.location_name, 
      abs(sum(it.quantity_changed)) as quantity_sold
from 
	  sale_transaction_t s
join inventory_transaction_t it on it.transaction_id = s.transaction_id
join inventory_t i on it.inventory_id = i.inventory_id
group by i.location_name
order by quantity_sold desc

-- Identify products with current stock below 30 units, showing product, location, and stock quantity.
SELECT 
    i.product_item_id, 
    p.product_description, 
    i.location_name, 
    MAX(it.stock_quantity) AS current_stock
FROM 
    inventory_transaction_t it
JOIN inventory_t i ON it.inventory_id = i.inventory_id
JOIN product_t p ON i.product_item_id = p.product_item_id
GROUP BY i.inventory_id
HAVING current_stock < 30;

-- Summarize total units supplied by each vendor, ordered from highest to lowest.
select
	v.vendor_name,
	abs(sum(it.quantity_changed)) as total_units_supplied
from
	purchase_t pur
join vendor_t v on pur.vendor_id = v.vendor_id
join inventory_transaction_t it on it.transaction_id = pur.transaction_id
group by v.vendor_name
order by total_units_supplied desc

-- Calculate revenue, cost, and profit per product based on sale prices and wholesale costs.
select
	  p.product_description,
      abs(sum(s.sale_price * it.quantity_changed)) as revenue,
      abs(sum(pur.wholesale_cost * it.quantity_changed)) as cost,
      abs(sum((s.sale_price - pur.wholesale_cost) * it.quantity_changed)) as profit
from sale_transaction_t s
join inventory_transaction_t it on s.transaction_id = it.transaction_id
join product_t p on s.product_item_id = p.product_item_id
join purchase_t pur on pur.product_item_id = s.product_item_id
group by p.product_description

-- Create a view summarizing sales with customer ID, product description, sale price, and transaction date.
CREATE VIEW sales_summary AS
SELECT 
    s.customer_id,
    p.product_description,
    s.sale_price,
    it.transaction_date
FROM sale_transaction_t s
JOIN product_t p ON s.product_item_id = p.product_item_id
JOIN inventory_transaction_t it ON s.transaction_id = it.transaction_id;

-- Create a view summarizing purchase transactions with details including transaction info, product, vendor, cost, and stock.
CREATE VIEW purchase_transaction_summary_vw AS
SELECT
    it.transaction_id,
    it.transaction_date,
    'PURCHASE' AS transaction_type,
    p.product_item_id,
    p.product_description,
    inv.location_name,
    v.vendor_name,
    pr.wholesale_cost,
    NULL AS sale_price,
    it.stock_quantity,
    NULL AS profit_per_unit,
    NULL AS total_estimated_profit
FROM inventory_transaction_t it
JOIN inventory_t inv ON it.inventory_id = inv.inventory_id
JOIN product_t p ON inv.product_item_id = p.product_item_id
JOIN purchase_t pr ON it.transaction_id = pr.transaction_id
JOIN vendor_t v ON pr.vendor_id = v.vendor_id;

-- Create a view summarizing sale transactions with transaction details, product info, prices, profit per unit, and estimated total profit.
CREATE VIEW sale_transaction_summary_vw AS
SELECT
    it.transaction_id,
    it.transaction_date,
    'SALE' AS transaction_type,
    p.product_item_id,
    p.product_description,
    inv.location_name,
    pr.wholesale_cost,
    st.sale_price,
    it.stock_quantity,
    (st.sale_price - pr.wholesale_cost) AS profit_per_unit,
    (st.sale_price - pr.wholesale_cost) * it.stock_quantity AS total_estimated_profit
FROM inventory_transaction_t it
JOIN inventory_t inv ON it.inventory_id = inv.inventory_id
JOIN product_t p ON inv.product_item_id = p.product_item_id
JOIN sale_transaction_t st ON it.transaction_id = st.transaction_id
LEFT JOIN (
    SELECT pr1.product_item_id, pr1.wholesale_cost, it1.transaction_date
    FROM purchase_t pr1
    JOIN inventory_transaction_t it1 ON pr1.transaction_id = it1.transaction_id
    JOIN inventory_t inv1 ON it1.inventory_id = inv1.inventory_id
) pr ON pr.product_item_id = p.product_item_id
   AND pr.transaction_date <= it.transaction_date
