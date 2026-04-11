-- Question 1
Select ocd.customer_city,
	ocd.customer_state 
From olist_customers_dataset ocd
Inner Join olist_orders_dataset ood 
On ood.customer_id = ocd.customer_id 
Where ood.order_status = 'delivered'

-- Question 2
Select opd.product_category_name,
	ooid.order_id 
From olist_products_dataset opd
Inner Join olist_order_items_dataset ooid 
On ooid.product_id = opd.product_id
Where ooid.price > 300
Order By ooid.price Desc

-- Question 3
Select ood.order_id,
	ood.order_status 
From olist_orders_dataset ood 
Left Join olist_order_reviews_dataset oord 
On oord.order_id = ood.order_id 
Where oord.review_id is Null

-- Question 4
Select ood.customer_id,
	ocd.customer_state,
	ocd.customer_city 
From olist_orders_dataset ood 
Inner Join olist_customers_dataset ocd 
On ood.customer_id = ocd.customer_id
Where ood.customer_id In (
	Select ood2.customer_id
	From olist_orders_dataset ood2 
	Where ood2.order_delivered_customer_date >= '2017-01-01' And ood2.order_delivered_customer_date <= '2018-01-01'
)

-- Question 5
Select ooid.order_id 
From olist_order_items_dataset ooid 
Where ooid.price = (
	Select Max(ooid2.price)
	From olist_order_items_dataset ooid2 
)

-- Question 6
Select oopd.order_id,
	Case 
		When oopd.payment_value < 100 Then 'Low Value'
		When oopd.payment_value > 100 And oopd.payment_value < 500 Then 'Medium Value'
		Else 'High Value'
	End
From olist_order_payments_dataset oopd 

-- Question 7
Select ocd.customer_state,
	Case
		When ood.order_status = 'delivered' Then 'Delivered Order'
		When ood.order_status = 'shipped' Then 'Shipped Order'
		When ood.order_status = 'canceled' Then 'Canceled Order'
	End
From olist_customers_dataset ocd 
Inner Join olist_orders_dataset ood 
On ood.customer_id  = ocd.customer_id 

-- Question 8
Select Top 20 osd.seller_id,
	Round(Sum(ooid.price), 3) As total_revenue,
	Rank() Over (Order By Sum(ooid.price) Desc) As ranked_revenue
From olist_sellers_dataset osd 
Inner Join olist_order_items_dataset ooid 
On ooid.seller_id = osd.seller_id
Group By osd.seller_id 

-- Question 9
Select Year(ood.order_delivered_customer_date) As 'Year',
	Month(ood.order_delivered_customer_date) As 'Month',
	Round(Sum(ooid.price), 2) As monthly_revenue,
	Round(Sum(ooid.price) - Lag(Sum(ooid.price)) Over (Order By Year(ood.order_delivered_customer_date), Month(ood.order_delivered_customer_date)), 2) As monthly_change
From olist_order_items_dataset ooid 
Inner Join olist_orders_dataset ood 
On ood.order_id = ooid.order_id
Where Year(ood.order_delivered_customer_date) in (2017, 2018)
Group By Year(ood.order_delivered_customer_date), Month(ood.order_delivered_customer_date)

-- Question 10

-- Question 11

-- Question 12
