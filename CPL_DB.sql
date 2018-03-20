CREATE DATABASE	CPL_DB

USE CPL_DB

-- Create a table that auto increments with the addition of each new vendor
CREATE TABLE VENDOR(
	VENDOR_ID			INT	NOT NULL 	AUTO_INCREMENT, 
	VENDOR_NAME			VARCHAR(50),	
	VENDOR_STREET		VARCHAR(50),	
	VENDOR_CITY			VARCHAR(50),
	VENDOR_ZIP			VARCHAR(20),
	VENDOR_COUNTRY		VARCHAR(20),
	VENDOR_PHONE		VARCHAR(50),		
	VENDOR_CONTACT		VARCHAR(50),
	VENDOR_DESCRIPT		VARCHAR(100),
	VENDOR_EMAIL		VARCHAR(50),
	VENDOR_STATUS		VARCHAR(20),
	PRIMARY KEY (VENDOR_ID));

CREATE TABLE CONTRACT(
	VENDOR_ID			INT ,
	CONTRACT_ID			INT NOT NULL UNIQUE,
	CONTRACT_TYPE		VARCHAR(50),							
	PRIMARY KEY (VENDOR_ID, CONTRACT_ID),		
	FOREIGN KEY (VENDOR_ID)); 

CREATE TABLE PRODUCT(
	PRODUCT_ID		INT	NOT NULL	UNIQUE,
	PRODUCT_NAME		VARCHAR(50),
	PRODUCT_PARENT_ID	INT,
	PRODUCT_DESC		VARCHAR(100),
	PRODUCT_EST_PRICE	INT,					
	PRIMARY KEY (PRODUCT_ID));						

CREATE TABLE ORDER(
	ORDER_ID			INT	NOT NULL, UNIQUE,
	VENDOR_ID			INT,
	EMPLOYEE_ID			CHAR(5),
	ORDER_DATE			VARCHAR(50), 
	PRIMARY KEY (ORDER_ID),
	FOREIGN KEY (VENDOR_ID),
	FOREIGN KEY (EMPLOYEE_ID)); 

CREATE TABLE ORDER_ITEM(
	PRODUCT_ID			INT,
	ORDER_ID,			CHAR(9),
	ORDER_ITEM_QUAN		INT,
	PRIMARY KEY (PRODUCT_ID, ORDER_ID),
	FOREIGN KEY (PRODUCT_ID)
	FOREIGN KEY (ORDER_ID)); 

CREATE TABLE INVOICE(
	INVOICE_ID 	VARCHAR(50)	NOT NULL UNIQUE, 
	EMPLOYEE_ID CHAR(5) 	NOT NULL, 
	ORDER_ID CHAR(9) 	NOT NULL,  
	VENDOR_ID INT		NOT NULL, 
	INVOICE_AMT NUMERIC(10,2) NOT NULL,
	INVOICE_RECEIPT DATETIME,
	INVOICE_INPUT_DATE DATETIME,
	INVOICE_DUE_DATE DATETIME NOT NULL,
	INVOICE_STATUS NOT NULL,
	INVOICE_DATE DATETIME,
	PRIMARY KEY (INVOICE_ID),
	);


CREATE TABLE EMPLOYEE(
	EMPLOYEE_ID CHAR(5) NOT NULL UNIQUE,
	EMPLOYEE_LNAME 	VARCHAR(255)	NOT NULL,
	EMPLOYEE_FNAME 		VARCHAR(255)	NOT NULL,
	EMPLOYEE_MID_INI 	CHAR(1),
	EMPLOYEE_PSWD 	VARCHAR(255)	NOT NULL,
	PRIMARY KEY (EMPLOYEE_ID)
	);

CREATE TABLE PAYMENT(
	PAYMENT_ID 	CHAR(8)		NOT NULL UNIQUE,
	VENDOR_ID	INT	NOT NULL,
	INVOICE_ID 	VARCHAR(50)	NOT NULL, 
	EMPLOYEE_ID 	CHAR(5) 	NOT NULL, 
	PAYMENT_DATE DATE NOT NULL,
	PRIMARY KEY (PAYMENT_ID),
	FOREIGN KEY (VENDOR_ID) REFERENCES VENDOR(VENDOR_ID),
	FOREIGN KEY (INVOICE_ID) REFERENCES INVOICE(INVOICE_ID ),
	FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID)
	);
	

CREATE TABLE PAY_SOURCE (
	PAY_SOURCE_ID CHAR(8)	NOT NULL UNIQUE,
	PAY_SOURCE_DESC VARCHAR(255), 
	PAY_SOURCE_TOTAL NUMERIC(10,2), 
	PAY_SOURCE_RELEASE DATE, 
	PAY_SOURCE_TYPE CHAR(1), 
	PRIMARY KEY (PAY_SOURCE_ID)
	);


CREATE TABLE FUNDING (
	PAYMENT_ID 	CHAR(8)		NOT NULL,
	PAY_SOURCE_ID 	CHAR(6)		NOT NULL, 
	FUNDING_APPROVER VARCHAR(100), 
	PRIMARY KEY (PAYMENT_ID, PAY_SOURCE_ID),
	FOREIGN KEY (PAYMENT_ID) REFERENCES PAYMENT(PAYMENT_ID),
	FOREIGN KEY (PAY_SOURCE_ID) REFERENCES PAY_SOURCE(PAY_SOURCE_ID)
	);


-- Create the city table that relies on the supertype table for updates to the primary key
CREATE TABLE CITY (
	PAY_SOURCE_ID 	CHAR(6)	NOT NULL UNIQUE,
	CITY_DEPT VARCHAR(50),
	PRIMARY KEY (PAY_SOURCE_ID),
	CONSTRAINT FK_CITY_PAY_ID
		FOREIGN KEY (PAY_SOURCE_ID) 
		REFERENCES PAY_SOURCE(PAY_SOURCE_ID) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
	);

-- Create the donor table that relies on the supertype table for updates to the primary key
CREATE TABLE DONOR (
	PAY_SOURCE_ID 	CHAR(6) NOT NULL UNIQUE,
	DONOR_TYPE VARCHAR(50),
	DONOR_LNAME VARCHAR(50),
	DONOR_PHONE VARCHAR(30)
	DONOR_EMAIL VARCHAR(50),
	DONOR_REASON VARCHAR(200),
	PRIMARY KEY (PAY_SOURCE_ID),
	CONSTRAINT FK_DONOR_PAY_ID
		FOREIGN KEY (PAY_SOURCE_ID) 
		REFERENCES PAY_SOURCE(PAY_SOURCE_ID) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
	);




