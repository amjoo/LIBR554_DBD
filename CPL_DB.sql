CREATE DATABASE	CPL_DB

USE CPL_DB

-- Create a table that auto increments with the addition of each new vendor

CREATE TABLE VENDOR(
	VENDOR_ID			INT		NOT NULL		AUTO_INCREMENT, 
	VENDOR_NAME			VARCHAR(50),	
	VENDOR_STREET			VARCHAR(50),	
	VENDOR_CITY			VARCHAR(50),
	VENDOR_ZIP			VARCHAR(20),
	VENDOR_COUNTRY			VARCHAR(20),
	VENDOR_PHONE			VARCHAR(50),		
	VENDOR_CONTACT			VARCHAR(50),
	VENDOR_DESCRIPT			VARCHAR(100),
	VENDOR_EMAIL			VARCHAR(50),
	VENDOR_STATUS			VARCHAR(20),
	PRIMARY KEY (VENDOR_ID)
	);


CREATE TABLE CONTRACT(
	VENDOR_ID			INT,
	CONTRACT_ID			INT 		NOT NULL		UNIQUE,
	CONTRACT_TYPE			VARCHAR(50),							
	PRIMARY KEY (VENDOR_ID, CONTRACT_ID),		
	FOREIGN KEY (VENDOR_ID)		REFERENCES VENDOR(VENDOR_ID)
	); 


CREATE TABLE PRODUCT(
	PRODUCT_ID			INT		NOT NULL		UNIQUE,
	PRODUCT_NAME			VARCHAR(50),
	PRODUCT_PARENT_ID		INT,
	PRODUCT_DESC			VARCHAR(100),
	PRODUCT_EST_PRICE		INT,					
	PRIMARY KEY (PRODUCT_ID)
	);						


CREATE TABLE ORDER(
	ORDER_ID			CHAR(9)		NOT NULL 		UNIQUE,
	VENDOR_ID			INT 		NOT NULL,
	EMPLOYEE_ID			CHAR(5) 	NOT NULL,
	ORDER_DATE			DATETIME 	NOT NULL, 
	PRIMARY KEY (ORDER_ID),
	FOREIGN KEY (VENDOR_ID),	REFERENCES VENDOR(VENDOR_ID),
	FOREIGN KEY (EMPLOYEE_ID)	REFERENCES EMPLOYEE(EMPLOYEE_ID)
	); 


CREATE TABLE ORDER_ITEM(
	PRODUCT_ID			INT NOT NULL,
	ORDER_ID			CHAR(9),
	ORDER_ITEM_QUAN		INT,
	PRIMARY KEY (PRODUCT_ID, ORDER_ID),
	FOREIGN KEY (PRODUCT_ID)
	FOREIGN KEY (ORDER_ID)
	); 


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
	DONOR_PHONE VARCHAR(30),
	DONOR_EMAIL VARCHAR(50),
	DONOR_REASON VARCHAR(200),
	PRIMARY KEY (PAY_SOURCE_ID),
	CONSTRAINT FK_DONOR_PAY_ID
		FOREIGN KEY (PAY_SOURCE_ID) 
		REFERENCES PAY_SOURCE(PAY_SOURCE_ID) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
	);



INSERT INTO VENDOR (VENDOR_NAME,VENDOR_STREET,VENDOR_CITY,VENDOR_PROVINCE,VENDOR_ZIP,VENDOR_COUNTRY,VENDOR_PHONE,VENDOR_CONTACT,VENDOR_DESCRIPT,VENDOR_EMAIL,VENDOR_STATUS)
VALUES
 ('Association for Computing Machinery','2 Penn Plaza, Suite 701','New York','NY','10121-0701','USA','212-869-7440','Corine Bailey','Computers','acmhelp@acm.org','Approved'),
('Elsevier','1600 JFK Boulevard','Philadelphia','PA','19103','USA','215-239-3689','William Durant','ScienceDirect','w.durant@elsevier.com','Pending Approval'),
('EBSCO','10 Estes Street','Ipswich','MA','01938','USA','978-356-6500','Janet Brown','Information Services','j.brown@ebsco.com','Approved'),
('Geopoliticalmonitor Intelligence Corp.','5700-100 King Street West','Toronto','ON','M5X 1C7','Canada','647-523-5631','Jeremy James','Geographic Materials','jjames@geopoliticalmonitor.com','Approved'),
('Imagine Canada','65 St Clair Avenue East, Suite 700','Toronto','ON','M4T 2Y3','Canada','1-800-263-1178 x305','Nicole Mitchell','Strengthen charities and their operations','nmitchell@imaginecanada.ca','Approved'),
('Impelsys','116 West 23rd Street, Suite 500','New York','NY','10011','USA','212-239-4138','Deepak Jayanna','Digital Content and Online Learning','deepak.jayanna@impelsys.com','Pending Approval'),
('Ithaka','2 Rector Street, 18th Floor','New York','NY','10006','USA','212-358-6448','Dan Paskett','Digital Asset Management','dan.paskett@ithaka.org','Approved'),
('Lynda','6410 Via Real','Carpinteria','CA','93013','USA','1-888-335-9632 x258','Michael Turner','Online Training in Programming and Business','mturner@lynda.com','Pending Approval'),
('MyBluePrint','310 Davenport Rd Suite 200','Toronto','ON','M4T 2Y3','Canada','1-888-901-5505','Damian Matheson','Curriculum Planning','damian.matheson@myBlueprint.ca','Approved'),
('National Film Board of Canada','P.O. Box 6100, Station Centre-ville','Montreal','QC','H3C 3H5','Canada','1-800-267-7710','','Educational Films','info@nfb.ca','Approved'),
('Recorded Books','270 Skipjack Road','Prince Frederick','MD','20678','USA','1-877-732-2898','Bryan Messersmith','Audio Books','bmessersmith@recordedbooks.com','Approved'),
('Statista Inc','55 Broad Street; 30th floor','New York','NY','10004','USA','212-433-2269','Johannes Meindl','Database for Market and Consumer Research','Johannes.Meindl@statista.com','Not Approved'),
('STEM Village','1 Yonge Street, Suite 1801','Toronto','ON','M5E 1W7','Canada','416-684-3289','Mark Applebaum','STEM kits','mark@stemvillage.com','Approved'),
('Taylor & Francis Group','6000 NW Broken Sound Parkway','Boca Raton','FL','33487','USA','818-416-5775','Susan Sanders','Digital Reference and E-books','susan.sanders@taylorandfrancis.com','Approved'),
('Third Iron','PO Box 270400','St. Paul','MN','55127','USA','855-649-7607 x702','Hayley J. H. Harris','Integration of Journal Platforms','hayley@thirdiron.com','Approved'),
('TumbleBooks','1853A Avenue Road','Toronto','ON','M5M 3Z4','Canada','1-866-622-9609','Rachela Naccarato','Online Children Books','rachela@tumblebooks.com','Approved'),
('University of Chicago Press','1427 E. 60th Street','Chicago','IL','60637','USA','773-702-7957','Jim Lilly','The Chicago Manual of Style Online','jlilly@press.uchicago.edu','Approved'),
('Variant Edition','10132 – 151 Street','Edmonton','AB','','Canada','780-452-9886','Brandon Schatz','Comics and Prose Books','library@variantedmonton.com','Pending Approval'),
('World Book','180 N LaSalle St','Chicago','IL','60601','USA','800-967-5325','Mike Tieman','Children Online Books','tieman@shaw.ca ','Approved'),
('WWD.com','Santa Monica Boulevard','Los Angeles','CA','','','310.484.2536','Randi Segal','Online Pop Culture Magazine','randi.segal@wwd.com','Approved');

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
	(12,'1000016','Contract'),
	(13,'1000017','Standing'),
	(14,'1000018','Standing'),
	(15,'1000019','Contract'),
	(16,'1000020','Contract');

INSERT INTO PRODUCT (PRODUCT_ID,PRODUCT_NAME,PRODUCT_PARENT_ID,PRODUCT_DESC,PRODUCT_EST_PRICE)
VALUES
('BK002530','Audio Books','BK000000','Audio Books',40.00),
('BK002896','E-Books','BK000000','Digital E-Books',40.00),
('BK056328','Comic Books','BK000000','Comics',10.00),
('FE154337','Circulation Desk','FE100000','Front Desk',3000),
('TR259788','Online Training','MG200000','Online Training Subscription',60),
('JM359788','Online Magazine','JM300000','Online Magazine Subscription',20),
('JM356953','Online Journal','JM300000','Online Journal Subscription',25),
('DB469833','Database Subscription','DB400000','Online Database Subscriptions',60),
('ST589743','STEM Kit','ST500000','STEM kits',40),
('CM656432','Scanner','CM600000','Computer Scanner',150),
('CM689885','Ink-Jet Printer','CM600000','Computer Printer',200),
('OS789433','Printing Paper','OS700000','Printer Paper',60),
('SW877463','Microsoft Office','SW800000','Computer Software',500),
('NP984526','Online Newspaper','NP900000','Online Newspaper Subscription',20),
('BK000000','Books','','Books',NULL),
('FE100000','Furniture and Equipment','','Furniture and Equipment',NULL),
('TR200000','Training','','Training',NULL),
('JM300000','Journal & Magazine','','Journal & Magazine',NULL),
('DB400000','Database Subscriptions','','Database Subscriptions',NULL),
('ST500000','STEM Related Materials','','STEM Related Materials',NULL),
('CM600000','Computer and Related Machinery','','Computer and Related Machinery',NULL),
('OS700000','Office Supply','','Office Supply',NULL),
('SW800000','Software','','Software',NULL),
('NP900000','Newspapers','','Newspapers', NULL);

INSERT INTO ORDER (ORDER_ID,VENDOR_ID,EMPLOYEE_ID,ORDER_DATE)
VALUES
('ORD100000',1,'KM001','5-Jan-18'),
('ORD100001',9,'KM001','8-Jan-18'),
('ORD100002',11,'KM001','11-Jan-18'),
('ORD100003',13,'KM001','15-Jan-18'),
('ORD100004',14,'KM001','19-Jan-18'),
('ORD100005',14,'KM001','22-Jan-18'),
('ORD100006',16,'HM001','26-Jan-18'),
('ORD100007',1,'KM001','29-Jan-18'),
('ORD100008',18,'KM001','1-Feb-18'),
('ORD100009',8,'HM001','1-Feb-18'),
('ORD100010',12,'KM001','2-Feb-18'),
('ORD100011',8,'KM001','5-Feb-18'),
('ORD100012',8,'KM001','8-Feb-18'),
('ORD100013',19,'KM001','12-Feb-18'),
('ORD100014',8,'KM001','15-Feb-18');	 

INSERT INTO ORDER_ITEM (PRODUCT_ID,ORDER_ID,ORDER_ITEM_QUAN)
VALUES
('BK002530','ORD100002',12),
('BK002896','ORD100004',12),
('ST589743','ORD100003',1),
('BK056328','ORD100006',12),
('CM656432','ORD100000',1),
('CM689885','ORD100000',2),
('DB469833','ORD100010',1),
('CM656432','ORD100000',1),
('CM689885','ORD100000',2),
('ST589743','ORD100003',1),
('TR259788','ORD100001',12),
('BK002896','ORD100005',14),
('CM656432','ORD100007',1),
('BK056328','ORD100008',12),
('TR259788','ORD100009',24);
		       
      
		       
INSERT INTO INVOICE (INVOICE_ID,EMPLOYEE_ID,ORDER_ID,VENDOR_ID,INVOICE_AMT,INVOICE_RECEIPT,INVOICE_INPUT_DATE,INVOICE_DUE_DATE,INVOICE_STATUS,INVOICE_DATE)
VALUES
('ACM145565','TJ002','ORD100000',1,405.00,'1-Mar-18','2-Mar-18','15-Mar-18','Approved','1-Feb-18'),
('MBP875456','TJ002','ORD100001',9,250.00,'1-Mar-18','2-Mar-18','15-Mar-18','Approved','2-Feb-18'),
('RB565222','TJ002','ORD100002',11,5465.00,'1-Mar-18','2-Mar-18','15-Mar-18','Approved','3-Feb-18'),
('SV5843','TJ002','ORD100003',13,451.00,'1-Mar-18','2-Mar-18','15-Mar-18','Approved','4-Feb-18'),
('TFG8422','TJ002','ORD100004',14,121.00,'2-Mar-18','2-Mar-18','15-Mar-18','Approved','5-Feb-18'),
('TFG3641','TJ002','ORD100005',14,135.00,'2-Mar-18','2-Mar-18','15-Mar-18','Approved','6-Feb-18'),
('TB021687','TJ002','ORD100006',16,584.00,'2-Mar-18','2-Mar-18','15-Mar-18','Approved','7-Feb-18'),
('ACM145566','TJ002','ORD100007',1,987.00,'2-Mar-18','2-Mar-18','15-Mar-18','Approved','7-Feb-18'),
('VE5132366','TJ002','ORD100008',18,632.00,'7-Mar-18','9-Mar-18','15-Mar-18','Approved','7-Feb-18'),
('LY599413','TJ002','ORD100009',8,159.00,'8-Mar-18','9-Mar-18','15-Mar-18','Pending Approval','7-Feb-18'),
('SI84133','TJ002','ORD100010',12,158.00,'9-Mar-18','9-Mar-18','15-Mar-18','Pending Approval','7-Feb-18'),
('LY599414','TJ002','ORD100011',8,289.00,'12-Mar-18','16-Mar-18','31-Mar-18','Pending Approval','12-Feb-18'),
('LY599415','TJ002','ORD100012',8,841.00,'12-Mar-18','16-Mar-18','31-Mar-18','Pending Approval','13-Feb-18'),
('WB65232','TJ002','ORD100013',19,1235.00,'12-Mar-18','16-Mar-18','31-Mar-18','Pending Approval','14-Feb-18'),
('LY599416','TJ002','ORD100014',8,869.00,'12-Mar-18','16-Mar-18','31-Mar-18','Pending Approval','15-Feb-18'),
('WB65233','TJ002','ORD100015',19,125.32,'12-Mar-18','16-Mar-18','31-Mar-18','Pending Approval','16-Feb-18'),
('WB65234','TJ002','ORD100016',19,1487.98,'12-Mar-18','16-Mar-18','31-Mar-18','Pending Approval','17-Feb-18'),
('RB565223','TJ002','ORD100017',11,504.05,'12-Mar-18','16-Mar-18','31-Mar-18','Pending Approval','18-Feb-18');
	    
INSERT INTO EMPLOYEE (EMPLOYEE_ID,EMPLOYEE_LNAME,EMPLOYEE_FNAME,EMPLOYEE_MID_INI,EMPLOYEE_PSWD)
VALUES	
('KM001','Mutly','Karen','R','strinkin1'),
('HM001','Morrison','Heather',,'little2'),
('TJ002','Jackson','Thomas','T','regown3');

INSERT INTO PAYMENT (PAYMENT_ID,VENDOR_ID,INVOICE_ID,EMPLOYEE_ID,PAYMENT_DATE,PAYMENT_AMOUNT)
VALUES	
('PM100000',1,'ACM145565','KM001','15-Mar-18',405.00),
('PM100001',9,'MBP875456','KM001','15-Mar-18',250.00),
('PM100002',11,'RB565222','KM001','15-Mar-18',3465.00),
('PM100003',13,'SV5843','KM001','15-Mar-18',451.00),
('PM100004',14,'TFG8422','KM001','15-Mar-18',121.00),
('PM100005',14,'TFG3641','KM001','15-Mar-18',135.00),
('PM100006',16,'TB021687','KM001','15-Mar-18',584.00),
('PM100007',1,'ACM145566','KM001','15-Mar-18',987.00);	
			
INSERT INTO PAY_SOURCE (PAY_SOURCE_ID,PAY_SOURCE_DESC,PAY_SOURCE_TOTAL,PAY_SOURCE_RELEASE,PAY_SOURCE_TYPE)
VALUES
('B20001','Library System Budget',100000.00,'1-Jan-18','B'),
('C20001','City Contribution',25000.00,'8-Jan-18','C'),
('C20002','City Contribution',15000.00,'8-Jan-18','C'),
('D30001','Donation',20000.00,'18-Jan-18','D'),
('D30002','Donation',3500.00,'18-Jan-18','D'),
('D30003','Donation',8000.00,'25-Jan-18','D'),
('D30004','Donation',500.00,'31-Jan-18','D'),
('D30005','Donation',1500.00,'31-Jan-18','D');	
		      
INSERT INTO FUNDING (PAYMENT_ID,PAY_SOURCE_ID,FUNDING_APPROVER)
VALUES
('PM100000','B20001','HM001'),
('PM100001','C20001','HM001'),
('PM100002','D30001','HM001'),
('PM100003','B20001','HM001'),
('PM100004','B20001','HM001'),
('PM100005','B20001','HM001'),
('PM100006','B20001','HM001'),
('PM100007','B20001','HM001'),
('PM100007','D30001','HM001');
		       	       
		       
INSERT INTO CITY (PAY_SOURCE_ID,CITY_DEPT)
VALUES		       
('C20001','Education'),
('C20002','Small Business Administration');


INSERT INTO DONOR (PAY_SOURCE_ID,DONOR_TYPE,DONOR_LNAME,DONOR_FNAME,DONOR_PHONE,DONOR_EMAIL,DONOR_REASON)
VALUES
('D30001','Individual','Freidman','Edna','647-656-5623','efriedman@yahoo.com','Husband Will'),
('D30002','Non-Profit Organization','Tennet','','565-565-2060','','Program Sponsorship'),
('D30003','For-Profit Organization','Glasgow','','210-365-2061','','Goodwill'),
('D30004','For-Profit Organization','Exxon','','712-865-2062','','Goodwill'),
('D30005','Government Grant','EPA','','891-565-8746','','Program Sponsorship');
