-- Challenge 1 - E-commerce Order System (Olist)

-- Grain of Fact: One row per order line, goods atomic transfer
-- Dimensional tables: Seller, Date, Customer, Product Category

With fct_orders As (
    Select p.product_id,
        oi.price,
        Case 
            When oi.price > 500 Then 'Premium'
            When oi.price > 100 Then 'Standard'
            When oi.price > 30 Then 'Budget'
            Else 'Bargain'
        End As price_tier,
        s.seller_state,
        o.order_id,
        o.customer_id,
        o.order_delivered_customer_date,
        o.order_purchase_timestamp
    From BRAZILSHOP_DW.RAW.PRODUCTS p
    Inner Join BRAZILSHOP_DW.RAW.ORDER_ITEMS oi
    On oi.product_id = p.product_id
    Inner Join BRAZILSHOP_DW.RAW.SELLERS s
    On s.seller_id = oi.seller_id
    Inner Join BRAZILSHOP_DW.RAW.ORDERS o
    On o.order_id = oi.order_id
)

Select Sum(price) As Revenue_Per_Product,
    Avg(datediff('day', order_purchase_timestamp, order_delivered_customer_date)) As Average_Delivery_Time,
    price_tier,
    customer_id,
    seller_state
From fct_orders 
Where price_tier = 'Premium'
Group By price_tier, customer_id, seller_state
Having Count(price_tier) > 1

-- Challenge 2 - Ride Hailing (Think Uber)

-- Grain of fact: One row per trip leg
-- Dimensional tables: Driver, Location, Date, Passenger
-- Columns: City (str), Price (int), Driver (str), Duration (date), trip_id (str), arrival_time (date)
-- A junior engineer on your team says the grain should be per booking. Write a one paragraph explanation of why they are wrong.
-- R: Because booking just registers a customer request, it misses how much does the trip last and 
-- it isn't what our client ask, besides revenue and quantity of trips done they want to see how many
-- of them ended in the morning or night besides the average duration in each city.

-- Challenge 3 - Hotel Booking (Booking.com)
-- Grain of fact: One row per reservation night
-- Dimensional tables: Hotel, Guest
-- Fact Tables: Transactions (Revenue) and Snapshots (Occupancy)

With fct_reservations As (
    Select h.hotel_id,
        h.total_rooms,
        h.price_per_night,
        g.guest_id,
        g.reservation,
        g.check_in_date,
        g.check_out_date,
        datediff('day', g.check_in_date, g.check_out_date) As Days_Of_Stay
    From Hotel h 
    Inner Join Guest g
    On h.hotel_id = g.hotel_id
)

Select 
    hotel_id,
    guest_id,
    total_rooms,
    reservation,
    Avg(datediff('day', check_in_date, check_out_date)) As Avg_Stay,
    (Count(guest_id) / (Max(total_rooms) * 30)) * 100 As Hotel_Occupancy_Rate_Monthly,
    Sum(Days_Of_Stay * price_per_night) As Revenue_Per_Night_week
From fct_reservations
Group By hotel_id, Month(reservation), Week(Days_Of_Stay)

-- Challenge 5 - Healthcare (Think Hospital System)

-- Fact tables: fct_treatments, fct_stay, fct_bed_occupancy
-- fct_treatments -> One row per treatment
-- fct_stay -> One row per patient
-- fct_bed_occupancy -> One row per ward

-- Dimensional Tables: Wards, Revenue, Patients

-- Columns for fct_treatments -> patient_id, doctor_id, revenue, treatment, sickness, alergies

-- Too maintain Data Integrety, it is not recommended to megre everything in one column due to
-- architectural design. Combining everything could cause a lot of missing values, running
-- queries in Snowflake could take too long and more difficult to clean the data