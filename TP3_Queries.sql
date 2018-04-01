--Query 1: Karen 

CREATE PROCEDURE GetUnpaidInvoice
    @VendorName	VARCHAR(255)
AS

SELECT		v.VENDOR_NAME, i.* --selects everything from INVOICE
FROM	    INVOICE i LEFT JOIN PAYMENT p ON i.INVOICE_ID = p.INVOICE_ID
			    JOIN VENDOR v ON i.VENDOR_ID = v.VENDOR_ID
WHERE		  p.INVOICE_ID IS NULL 
	      	AND	i.INVOICE_DUE_DATE < GETDATE() 
			    AND	v.VENDOR_NAME = @VendorName	

EXEC	GetUnpaidInvoice Lynda --Example 
