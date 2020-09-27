SELECT ListPrice, DiscountPercent, ROUND((ListPrice*(DiscountPercent/100)),2) AS DiscountAmount
FROM Products