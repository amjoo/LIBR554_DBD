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
	ORDER_ID			CHAR(9)	NOT NULL UNIQUE,
	VENDOR_ID			INT NOT NULL,
	EMPLOYEE_ID			CHAR(5) NOT NULL,
	ORDER_DATE			DATETIME NOT NULL, 
	PRIMARY KEY (ORDER_ID),
	FOREIGN KEY (VENDOR_ID),
	FOREIGN KEY (EMPLOYEE_ID)); 

CREATE TABLE ORDER_ITEM(
	PRODUCT_ID			INT NOT NULL,
	ORDER_ID			CHAR(9),
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
	INVOICE_STATUS VARCHAR(255) NOT NULL CHECK (INVOICE_STATUS in ('Approved','Pending Approval','Unapproved')),
	INVOICE_DATE DATETIME,
	PRIMARY KEY (INVOICE_ID),
	FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID),
	FOREIGN KEY (ORDER_ID) REFERENCES ORDER(ORDER_ID),
	FOREIGN KEY (VENDOR_ID) REFERENCES VENDOR(VENDOR_ID)
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



INSERT INTO CONTRACT (VENDOR_ID,CONTRACT_ID,CONTRACT_TYPE)
VALUES
    	(1,'1000001','Contract'),
    	(1,'1000002','Catalog'),
    	(1,'1000003','Blanket'),
    	(1,'1000004','Standing'),
    	(5,'1000005','Service'),
    	(5,'1000006','Service'),
	(6,'1000007','Service'),
	(7,'1000008','Service'),
	(8,'1000009','Service'),
	(8,'1000010','Blanket'),
	(9,'1000011','Blanket'),
	(9,'1000012','Service'),
	(9,'1000013','Contract'),
	(10,'1000014','Contract'),
	(11,'1000015','Catalog'),
	(12,'1000016','Contract')
	(13,'1000017','Standing')
	(14,'1000018','Standing'),
	(15,'1000019','Contract'),
	(16,'1000020','Contract');
	

INSERT INTO VENDOR (VENDOR_NAME,VENDOR_STREET,VENDOR_CITY,VENDOR_PROVINCE,VENDOR_ZIP,VENDOR_COUNTRY,VENDOR_PHONE,VENDOR_CONTACT,VENDOR_DESCRIPT,VENDOR_EMAIL,VENDOR_STATUS)
VALUES
 ('Association for Computing Machinery',"'2 Penn Plaza, Suite 701'",'New York','NY','10121-0701','USA','212-869-7440','Corine Bailey','Computers','acmhelp@acm.org','Approved'),
('Elsevier','1600 JFK Boulevard','Philadelphia','PA',19103,'USA','215-239-3689','William Durant','ScienceDirect','w.durant@elsevier.com','Pending Approval'),
('EBSCO','10 Estes Street','Ipswich','MA','01938','USA','978-356-6500','Janet Brown','Information Services','j.brown@ebsco.com','Approved'),
('Geopoliticalmonitor Intelligence Corp.','5700-100 King Street West','Toronto','ON','M5X 1C7','Canada','647-523-5631','Jeremy James','Geographic Materials','jjames@geopoliticalmonitor.com','Approved'),
('Imagine Canada',"'65 St Clair Avenue East, Suite 700'",'Toronto','ON','M4T 2Y3','Canada','1-800-263-1178 x305','Nicole Mitchell','Strengthen charities and their operations','nmitchell@imaginecanada.ca','Approved'),
('Impelsys',"'116 West 23rd Street, Suite 500'",'New York','NY',10011,'USA','212-239-4138','Deepak Jayanna','Digital Content and Online Learning','deepak.jayanna@impelsys.com','Pending Approval'),
('Ithaka',"'2 Rector Street, 18th Floor'",'New York','NY',10006,'USA','212-358-6448','Dan Paskett','Digital Asset Management','dan.paskett@ithaka.org','Approved'),
('Lynda','6410 Via Real','Carpinteria','CA',93013,'USA','1-888-335-9632 x258','Michael Turner','Online Training in Programming and Business','mturner@lynda.com','Pending Approval'),
('MyBluePrint','310 Davenport Rd Suite 200','Toronto','ON','M4T 2Y3','Canada','1-888-901-5505','Damian Matheson','Curriculum Planning','damian.matheson@myBlueprint.ca','Approved'),
('National Film Board of Canada',"'P.O. Box 6100, Station Centre-ville'",'Montreal','QC','H3C 3H5','Canada','1-800-267-7710',,'Educational Films','info@nfb.ca','Approved'),
('Recorded Books','270 Skipjack Road','Prince Frederick','MD',20678,'USA','1-877-732-2898','Bryan Messersmith','Audio Books','bmessersmith@recordedbooks.com','Approved'),
('Statista Inc','55 Broad Street; 30th floor','New York','NY',10004,'USA','212-433-2269','Johannes Meindl','Database for Market and Consumer Research','Johannes.Meindl@statista.com','Not Approved'),
('STEM Village',"'1 Yonge Street, Suite 1801'",'Toronto','ON','M5E 1W7','Canada','416-684-3289','Mark Applebaum','STEM kits','mark@stemvillage.com','Approved'),
('Taylor & Francis Group','6000 NW Broken Sound Parkway','Boca Raton','FL',33487,'USA','818-416-5775','Susan Sanders','Digital Reference and E-books','susan.sanders@taylorandfrancis.com','Approved'),
('Third Iron','PO Box 270400','St. Paul','MN',55127,'USA','855-649-7607 x702','Hayley J. H. Harris','Integration of Journal Platforms','hayley@thirdiron.com','Approved'),
('TumbleBooks','1853A Avenue Road','Toronto','ON','M5M 3Z4','Canada','1-866-622-9609','Rachela Naccarato','Online Children Books','rachela@tumblebooks.com','Approved'),
('University of Chicago Press','1427 E. 60th Street','Chicago','IL',60637,'USA','773-702-7957','Jim Lilly','The Chicago Manual of Style Online','jlilly@press.uchicago.edu','Approved'),
('Variant Edition','10132 – 151 Street','Edmonton','AB',,'Canada','780-452-9886','Brandon Schatz','Comics and Prose Books','library@variantedmonton.com','Pending Approval'),
('World Book','180 N LaSalle St','Chicago','IL',60601,'USA','800-967-5325','Mike Tieman','Children Online Books','tieman@shaw.ca ','Approved'),
('WWD.com','Santa Monica Boulevard','Los Angeles','CA',,,'310.484.2536','Randi Segal ','Online Pop Culture Magazine','randi.segal@wwd.com','Approved');

