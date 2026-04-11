-- Question 1
Select ood.order_id,
	ood.order_status,
	ood.order_purchase_timestamp 
From olist_orders_dataset ood 
Where ood.order_status = 'shipped'
Order By ood.order_purchase_timestamp Desc

-- Question 2
Select ocd.customer_id,
	ocd.customer_state 
From olist_customers_dataset ocd 
Where ocd.customer_state = 'RJ'

-- Question 3
Select Top 10 ooid.order_id,
	ooid.price
From olist_order_items_dataset ooid 
Order By ooid.price Desc

-- Question 4
Select ocd.customer_id, 
	ocd.customer_city 
From olist_customers_dataset ocd
Where ocd.customer_city Like '%rio%'

-- Question 5
Select ocd.customer_state,
	Count(ocd.customer_id) As orders_per_state
From olist_customers_dataset ocd 
Group By ocd.customer_state 
Order By orders_per_state Desc

-- Question 6
Select ooid.order_id,
	Min(ooid.price) As minimum_price,
	Max(ooid.price) As maximum_price,
	Avg(ooid.price) As average_price
From olist_order_items_dataset ooid 
Group By ooid.order_id
Having Count(ooid.order_id) > 3

-- Question 7
Select oopd.payment_type,
	Sum(oopd.payment_value) As Revenue
From olist_order_payments_dataset oopd 
Group By oopd.payment_type

-- Question 8
Select ood.order_id,
	ood.order_status,
	ocd.customer_city,
	ocd.customer_state 
From olist_customers_dataset ocd 
Join olist_orders_dataset ood 
On ood.customer_id = ocd.customer_id 
Where ocd.customer_state = 'SP' 

-- Question 9
Select opd.product_category_name,
	ooid.price 
From olist_products_dataset opd
Inner Join olist_order_items_dataset ooid 
On opd.product_id = ooid.product_id 
Where ooid.price >= 300

-- Question 10
Select osd.seller_id,
	Count(ooid.product_id) As total_items
From olist_sellers_dataset osd 
Inner Join olist_order_items_dataset ooid 
On ooid.seller_id = osd.seller_id 
Group By osd.seller_id 
Having Count(ooid.product_id) > 100

-- Question 11
Select Top 5 opd.product_category_name,
	Sum(ooid.price) As total_revenue
From olist_products_dataset opd 
Inner Join olist_order_items_dataset ooid 
On ooid.product_id = opd.product_id 
Inner Join olist_orders_dataset ood 
On ood.order_id = ooid.order_id 
Where ood.order_status = 'delivered'
Group By opd.product_category_name 
Order by Sum(ooid.price) Desc

-- Question 12
Select ood.order_id 
From olist_orders_dataset ood 
Left Join olist_order_payments_dataset oopd 
On oopd.order_id = ood.order_id 
Where oopd.payment_type is Null