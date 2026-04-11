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
Select Top 1 opd.product_category_name,
	ooid.seller_id,
	Rank() Over (Partition By ooid.seller_id Order By Count(opd.product_id) Desc) As seller_ranks
From olist_products_dataset opd
Inner Join olist_order_items_dataset ooid 
On ooid.product_id = opd.product_id 
Group By opd.product_category_name, ooid.seller_id 

-- Question 11
With total_revenue_orders As (
	Select Round(Sum(ooid.price), 2) As 'Total Revenue',
		Count(ooid.order_id) As 'Total Orders',
		osd.seller_id As 'Seller'
	From olist_order_items_dataset ooid
	Inner Join olist_sellers_dataset osd 
	On osd.seller_id = ooid.seller_id 
	Group By osd.seller_id 
)
Select "Total Revenue",
	"Total Orders",
	"Seller"
From total_revenue_orders 

-- Question 12
With average_review_score As (
	Select Avg(oord.review_score) As Score_Grade,
		ocd.customer_state As state
	From olist_order_reviews_dataset oord 
	Inner Join olist_orders_dataset ood 
	On ood.order_id = oord.order_id 
	Inner Join olist_customers_dataset ocd 
	On ocd.customer_id = ood.customer_id 
	Group By ocd.customer_state 
),
average_delivery_time As (
	Select Datediff(day, ood.order_approved_at, ood.order_delivered_customer_date) As Average_Delivery_Days,
		ocd.customer_state As state
	From olist_orders_dataset ood 
	Inner join olist_customers_dataset ocd 
	On ocd.customer_id = ood.customer_id 
	Group By ocd.customer_state, ood.order_approved_at, ood.order_delivered_customer_date
)
Select average_delivery_time.Average_Delivery_Days,
	average_review_score.Score_Grade,
	average_delivery_time.state
From average_delivery_time 
Inner Join average_review_score 
On average_review_score.state = average_delivery_time.state 
Where average_delivery_time.Average_Delivery_Days < 10 Or average_review_score.Score_Grade > 4