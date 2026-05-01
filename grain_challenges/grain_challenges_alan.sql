-- Question 1

-- Grain of Fact: One row per order line, goods atomic transfer
-- Dimensional tables: Seller, Date, Customer, Product

Create Or Replace Table BRAZILSHOP_DW.DEV.FCT_ORDERS AS
    Select Distinct
        c.customer_id AS customer,
        o.order_id As order,
        oi.price As price,
        s.seller_state As state,
        p.product_category_name As product_category,
        o.order_purchase_timestamp As order_date
        o.order_estimated_delivery_date As time_delivered
    From BRAZILSHOP_DW.RAW.CUSTOMERS c
    Inner JOIN BRAZILSHOP_DW.RAW.ORDERS o
    ON o.customer_id = c.customer_id
    Inner Join BRAZILSHOP_DW.RAW.ORDER_ITEMS oi 
    On oi.order_id = o.order_id
    Inner Join BRAZILSHOP_DW.RAW.SELLERS s
    On s.seller_id = oi.seller_id
    Inner Join BRAZILSHOP_DW.RAW.PRODUCTS p
    On p.product_id = oi.product_id

Select
    customer,
    product_category,
    Count(customer) As premium_customers,
    Round(Sum(price), 2) As total_revenue,
    Avg(DATEDIFF('day', order_date, time_delivered)) As avg_delivary_dates,
    state
From BRAZILSHOP_DW.DEV.FCT_ORDERS
Group By customer, product_category, state
Having Count(customer) > 1

-- Question 2

-- Grain of fact: One row per trip leg
-- Dimensional tables: Driver, Location, Date, Passenger
-- Columns: City (str), Price (int), Driver (str), Duration (date), trip_id (str), arrival_time (date)
-- A junior engineer on your team says the grain should be per booking. Write a one paragraph explanation of why they are wrong.
-- R: Because booking just registers a customer request, it misses how much does the trip last and 
-- it isn't what our client ask, besides revenue and quantity of trips done they want to see how many
-- of them ended in the morning or night besides the average duration in each city.

-- Question 3
-- Grain of fact: One row per reservation night
-- Dimensional tables: 
-- Fact Table: Clients, Reservations, Hotel

Create Table Or Replace Hotel_Booking.Dev.fct_revenue_per_night As
    Select Distinct
        c.client_id As client,
        r.reservation_id As reservation,
        r.arrival_date As arrival,
        r.departure_date As departure,
        h.hotel_id As hotel,
        h.hotel_name As hotel_name,
        h.hotel_location As hotel_city,
        h.total_rooms As total_rooms
    From Hotel_Booking.Raw.Clients c
    Inner Join Hotel_Booking.Raw.Reservations r
    On r.client_id = c.client_id
    Inner Join Hotel_Booking.Raw.Hotels h
    On h.hotel_id = r.hotel_id;

Select 
    client,
    reservation,
    Round(reservation / (total_rooms * 30)) * 100,
    Month(arrival) As arrival_month
From Hotel_Booking.Dev.fct_revenue_per_night
Group By client