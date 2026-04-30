-- Grain of Fact: One row per order line, goods atomic transfer
-- Dimensional tables: Seller, Date, Customer, Product
Create Or Replace Table BRAZILSHOP_DW.RAW.FCT_Orders As
Select Distinct
    SELLER_ID,
From BRAZILSHOP_DW.RAW.SELLERS 