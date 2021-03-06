--Query 1
CREATE PROCEDURE GetUnpaidPastDueInvoice
	@VendorName	VARCHAR(255)
AS

SELECT		v.VENDOR_NAME,
		i.INVOICE_ID, 
		i.INVOICE_AMT,
		i.INVOICE_DUE_DATE,
		i.INVOICE_STATUS
FROM		INVOICE i LEFT JOIN PAYMENT p ON i.INVOICE_ID = p.INVOICE_ID
		JOIN VENDOR v ON i.VENDOR_ID = v.VENDOR_ID
WHERE		p.INVOICE_ID IS NULL 
		AND	i.INVOICE_DUE_DATE < GETDATE() 
		AND	v.VENDOR_NAME = @VendorName

--Example:
EXECUTE GetUnpaidPastDueInvoice 'Lynda'

--Query 3: Which employee processed an order

SELECT	po.PURCHASE_ORDER_ID,
	po.PURCHASE_ORDER_DATE,
	e.EMPLOYEE_FNAME + ' ' + e.EMPLOYEE_LNAME AS 'EMPLOYEE NAME'
FROM	PURCHASE_ORDER po,
	VENDOR v,
	EMPLOYEE e 
WHERE	po.VENDOR_ID = v.VENDOR_ID AND
	po.EMPLOYEE_ID = e.EMPLOYEE_ID AND
	v.VENDOR_NAME = 'Association for Computing Machinery'
ORDER BY po.PURCHASE_ORDER_DATE DESC 

--Query 4: Top 5 Vendors 
SELECT TOP(5)
	v.VENDOR_NAME, 
	SUM(i.INVOICE_AMT) AS TOTAL_AMT
FROM 	VENDOR v, 
	INVOICE i
WHERE 	v.VENDOR_ID = i.VENDOR_ID
GROUP BY v.VENDOR_NAME
ORDER BY TOTAL_AMT DESC

--Does same thing as the previous one, but is more efficient 
SELECT TOP(5) 
	v.VENDOR_NAME, 
	t.TOTAL_AMT
FROM VENDOR v 
JOIN 
	(SELECT
		i.VENDOR_ID,
		SUM(i.INVOICE_AMT) AS TOTAL_AMT
	FROM INVOICE i
	GROUP BY i.VENDOR_ID) AS t
ON v.VENDOR_ID = t.VENDOR_ID
ORDER BY TOTAL_AMT DESC
