SELECT
    warehouse.warehouse_id,
    CONCAT (warehouse.state, ":", warehouse.warehouse_alias) AS warehouse_name,
    COUNT (orders.order_id) AS number_of_orders,
    (SELECT 
       COUNT(*) 
     FROM mydb.orderstb AS orders) AS total_orders,
CASE #to define the percentage of the grand total of orders that it fulfilled
	WHEN COUNT(orders.order_id)/(SELECT COUNT(*) FROM mydb.orderstb AS orders) <= 0.20 # this defines the first possible condition
          THEN 'Fulfilled 0-20% of Orders' #THEN defines the label to apply when the first condition is true.
    WHEN COUNT(orders.order_id)/(SELECT COUNT(*) FROM mydb.orderstb AS orders) > 0.20 
    # (This is the first part of the second condition.)
          AND COUNT(orders.order_id)/(SELECT COUNT(*) FROM mydb.orderstb AS Orders) <= 0.60 
    # (This is the second part of the second condition.)
          THEN 'Fulfilled 21-60% of Orders' #This defines the label to apply when the second condition is true
    ELSE 'Fulfilled more than 60% of Orders' # (This defines the label to apply when neither of the first two conditions is true.)
    END AS fulfillment_summary 
    #The END keyword terminates the CASE declaration. Then the AS keyword indicates what the resulting column should be named
FROM warehousetb AS warehouse
LEFT JOIN orderstb AS orders
	ON orders.warehouse_id = warehouse.warehouse_id
GROUP BY 
	warehouse.warehouse_id,
    warehouse_name 
HAVING
    COUNT (orders.order_id) > 0 
ORDER BY 
	number_of_orders DESC
#SET sql_mode = 'IGNORE_SPACE'; #backup