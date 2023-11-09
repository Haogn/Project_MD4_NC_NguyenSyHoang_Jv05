CREATE DATABASE project_MD4_NC;
USE project_MD4_NC;


-- tao bảng customers
CREATE TABLE customers(
                          customers_Id VARCHAR(4) PRIMARY KEY NOT NULL ,
                          customers_name VARCHAR(100) NOT NULL ,
                          email VARCHAR(100) NOT NULL ,
                          phone VARCHAR(25) NOT NULL ,
                          address VARCHAR(255)NOT NULL
);

-- tạo bảng order
CREATE TABLE orders(
                       order_id VARCHAR(4) PRIMARY KEY NOT NULL ,
                       customers_Id VARCHAR(4) NOT NULL ,
                       order_date DATE NOT NULL ,
                       total_amount DOUBLE NOT NULL
);

-- thêm khoá ngoại
ALTER TABLE orders
    ADD CONSTRAINT fk_customers FOREIGN KEY (customers_Id)
        REFERENCES customers(customers_Id);

-- tạo bảng Products
CREATE TABLE products (
                          product_id VARCHAR(4) PRIMARY KEY NOT NULL ,
                          product_name VARCHAR(255) NOT NULL ,
                          description TEXT,
                          price DOUBLE NOT NULL ,
                          status BIT default 1 NOT NULL
) ;

CREATE TABLE order_details (
                               order_id VARCHAR(4) NOT NULL ,
                               product_id VARCHAR(4) NOT NULL ,
                               quantity INT(11) NOT NULL ,
                               price DOUBLE NOT NULL ,
                               CONSTRAINT fk_o FOREIGN KEY (order_id) REFERENCES orders(order_id),
                               CONSTRAINT fk_p FOREIGN KEY (product_id) REFERENCES products(product_id),
                               PRIMARY KEY (order_id,product_id)
) ;

-- thêm dữ liệu bảng customers
INSERT INTO customers(customers_Id, customers_name, email, phone, address)
VALUES ('C001','Nguyễn Trung Mạnh','manhnt@gmail.com','0987654321','Cầu Giấy - Hà Nội'),
       ('C002','Hồ Hải nam','namhh@gmail.com','0987123456','Ba Vì - Hà Nội'),
       ('C003','Tô Ngọc Vũ','vutn@gmail.com','09871234567','Lai Châu - Sơn La'),
       ('C004','Phạm Ngọc Anh','anhpn@gmail.com','0987654444','TP Vinh - Nghệ An'),
       ('C005','Trương Minh Cường','cuongtm@gmail.com','0987655555','Hai Bà Trưng - Hà Nội');
SELECT * from customers;

-- Thêm dữ liệu bảng produts
INSERT INTO products(product_id, product_name, description, price)
VALUES ('P001','Iphone 13 ProMax', 'Bản 512G , xanh lá',22999999),
       ('P002','Dell Vostro V3510', 'Core i5, RAM 8GB',14999999),
       ('P003','Macbool Pro M2', '8CPU 10GPU 8GB 256GB',28999999),
       ('P004','Apple Watch Utra', 'Titanium Alpine Loop Small',18999999),
       ('P005','Airpods', 'Spatial Audio',4090000);

-- Thêm dữ liệu bảng order
INSERT INTO orders(order_id, customers_Id, total_amount,order_date )
VALUES ('H001','C001',52999997,'2023-2-22'),
       ('H002','C001',80999997,'2023-3-11'),
       ('H003','C002',54359998,'2023-1-22'),
       ('H004','C003',102999995,'2023-3-14'),
       ('H005','C003',80999997,'2023-3-12'),
       ('H006','C004',110449994,'2023-2-1'),
       ('H007','C004',79999996,'2023-3-29'),
       ('H008','C005',29999998,'2023-2-14'),
       ('H009','C005',28999999,'2023-1-10'),
       ('H010','C005',149999994,'2023-4-1');
SELECT * from orders;

-- Thêm dữ liệu bảng order_detail
INSERT INTO order_details(order_id, product_id,price, quantity )
VALUES ('H001','P002',14999999,1),
       ('H001','P004',18999999,2),
       ('H002','P001',22999999,1),
       ('H002','P003',28999999,2),
       ('H003','P004',18999999,2),
       ('H003','P005',4090000,4),
       ('H004','P002',14999999,3),
       ('H004','P003',28999999,2),
       ('H005','P001',22999999,1),
       ('H005','P003',28999999,2),
       ('H006','P003',4090000,5),
       ('H006','P002',14999999,6),
       ('H007','P004',18999999,3),
       ('H007','P001',22999999,1),
       ('H008','P002',14999999,2),
       ('H009','P003',28999999,1),
       ('H010','P003',28999999,2),
       ('H010','P001',22999999,4);

# Bài 3: Truy vấn dữ liệu [30 điểm]:
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
SELECT customers_name as Tên,
       email,
       phone as 'Số điện thoại',
        address as 'Đia chỉ'
FROM customers ;
-- Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
-- thoại và địa chỉ khách hàng).
SELECT customers_name as Tên,
       phone as 'Số điện thoại',
        address as 'Địa chỉ',
        o.order_date as 'Thời gian'
FROM customers c
         JOIN orders o ON c.customers_Id = o.customers_Id
where MONTH(order_date) = 3 and YEAR(order_date) = 2023;

-- Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
-- tháng và tổng doanh thu ).
SELECT MONTH(order_date) as Tháng,
    SUM(total_amount) as 'Tổng doanh thu'
FROM orders
GROUP BY MONTH(order_date)
ORDER BY Tháng;

-- Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
-- hàng, địa chỉ , email và số điên thoại).
SELECT  customers_name as 'Tên khách hàng',
        address as 'Địa chỉ',
        email ,
        phone as 'Số điện thoại',
        o.order_date as 'Thời gian'
FROM customers
         LEFT JOIN orders o on customers.customers_Id = o.customers_Id
Where o.customers_Id is not null and MONTH(order_date) != 2 ;

-- Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
-- sản phẩm, tên sản phẩm và số lượng bán ra).
SELECT p.product_id  as 'Mã sản phẩm',
        product_name as 'Tên sản phẩm',
        COUNT(quantity) as 'Số lượng sản phẩm đã bán'
FROM products p
         JOIN order_details od on p.product_id = od.product_id
         JOIN orders o on o.order_id = od.order_id
WHERE MONTH(o.order_date) = 3
GROUP BY p.product_id;

-- Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
SELECT c.customers_Id as 'Mã khách hàng',
        customers_name as 'Tên khách hàng',
        SUM(price) as 'Mức chi tiêu'
FROM customers c
         JOIN order_details JOIN orders o on c.customers_Id = o.customers_Id
GROUP BY c.customers_Id
ORDER BY `Mức chi tiêu` DESC ;

-- Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm)
SELECT customers_name  as 'Tên khách hàng',
        SUM(price) as 'Tổng tiền',
        order_date as 'Ngày tạo đơn',
        SUM(quantity) as 'Số lượng sản phẩm'
FROM order_details
         JOIN orders o on order_details.order_id = o.order_id
         JOIN customers c on o.customers_Id = c.customers_Id
GROUP BY customers_name, order_date
HAVING SUM(quantity) >= 5
ORDER BY  `Số lượng sản phẩm`;

# Bài 4: Tạo View, Procedure [30 điểm]:
/*
1 - Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
tiền và ngày tạo hoá đơn
*/
CREATE VIEW vw_customer_information
as
SELECT customers_name as 'Tên khách hàng',
        phone as 'Số điện thoại',
        address as 'Địa chỉ',
        total_amount as 'Tổng tiền',
        order_date as 'Ngày tạo đơn'
FROM customers c
         JOIN orders o on c.customers_Id = o.customers_Id;

/*
2- Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
số đơn đã đặt.
*/
CREATE VIEW vw_total_order_customers
AS
SELECT customers_name as 'Tên khách hàng',
        address as 'Địa chỉ',
        phone as 'Số điện thoại',
        COUNT(o.order_id) as 'Tổng đơn'
FROM orders o
         JOIN customers c on o.customers_Id = c.customers_Id
GROUP BY customers_name, address, phone;

/*
3- Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
bán ra của mỗi sản phẩm.
*/
CREATE VIEW vw_product_information
AS
SELECT product_name as 'Tên sản phẩm',
        description as 'Mô tả',
        p.price as 'Giá',
        SUM(quantity) as 'Tổng số lượng đã bán'
FROM products p
         JOIN order_details od on p.product_id = od.product_id
GROUP BY product_name, description, p.price;

/*
4. Đánh Index cho trường `phone` và `email` của bảng Customer.
*/
ALTER TABLE customers
    ADD INDEX idx_phone (phone) ;
ALTER TABLE customers
    ADD INDEX idx_email (email) ;
/*
5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
*/
delimiter //
CREATE PROCEDURE prod_find_customers_by_id(id VARCHAR(4))
BEGIN
SELECT * from customers
WHERE customers_Id = id ;
END ;
// delimiter ;
/*
6- Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
*/
delimiter //
CREATE PROCEDURE prod_product_information()
BEGIN
SELECT product_id as 'Mã sản phẩm',
        product_name as 'Tên sản phẩm',
        description as 'Mô tả',
        price as 'Giá',
        case status when 1 then 'Mở bán' when 0 then 'Hết hành' end  as 'Tình trạng'
FROM products;
END ;
// delimiter ;
DROP PROCEDURE prod_product_information;
/*
7- Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
*/
delimiter //
CREATE PROCEDURE prod_order_by_customersId(id VARCHAR(4))
BEGIN
SELECT order_id as 'Mã đơn hàng',
        customers_Id as 'Mã khách hàng',
        order_date as 'Thời gian đặt hàng',
        total_amount as 'Tổng đơn hàng'
from orders
where customers_Id = id;
END ;
// delimiter ;
/*
8- Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
*/
delimiter //
CREATE PROCEDURE prod_create_order( newCustomersId VARCHAR(4), newDate DATE, newTotal DOUBLE)
BEGIN
    DECLARE last_orderId INT ;
    DECLARE new_orderId VARCHAR(4);

    set last_orderId = (
        SELECT CAST(substring(order_id,2,4) as SIGNED )
        FROM orders
        ORDER BY substring(order_id,2,4) DESC
        LIMIT 1
    );

    SET new_orderId = (
        CASE
            WHEN (last_orderId + 1 ) < 10 then concat('H00', (last_orderId + 1))
            WHEN  (last_orderId + 1) < 100 then concat('H0', (last_orderId + 1))
            END
        );

INSERT INTO orders(order_id, customers_Id, order_date, total_amount)
VALUES(new_orderId, newCustomersId,newDate,newTotal);
SELECT order_id as 'Mã đơn hàng',
        customers_Id as 'Mã khách hàng',
        order_date as 'Ngày tạo đơn',
        total_amount as 'Tổng tiền'
FROM orders
WHERE order_id = new_orderId AND customers_Id = newCustomersId;
END ;
// delimiter ;


/*
Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc.
*/
delimiter //
CREATE PROCEDURE prod_show_product_by_time(time_start DATE , time_end DATE)
BEGIN
SELECT
    product_name as 'Tên sản phẩm',
        order_date as 'Ngày tạo đơn',
        SUM(quantity) as 'Số lượng sản phẩm'
FROM orders o
         JOIN order_details od on o.order_id = od.order_id
         JOIN products p on od.product_id = p.product_id
WHERE order_date between time_start and time_end
GROUP BY product_name, order_date;
END ;
// delimiter ;

call prod_show_product_by_time( '2023-02-01','2023-03-30');


/*
Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê.
*/

delimiter //
CREATE PROCEDURE prod_show_count_product_by_month(month INT, year INT)
BEGIN
SELECT
    product_name as 'Tên sản phẩm',
        description as 'Mô tả',
        SUM(quantity) as 'Số lượng sản phẩm bán ra'

FROM order_details od
         JOIN orders o on o.order_id = od.order_id
         JOIN products p on od.product_id = p.product_id
WHERE month(order_date) = month and year(order_date) = year
group by product_name, description
order by `Số lượng sản phẩm bán ra`;
END ;
// delimiter ;
DROP PROCEDURE prod_show_count_product_by_month;
call prod_show_count_product_by_month(3,2023);

SELECT
    product_name as 'Tên sản phẩm',
        description as 'Mô tả',
        SUM(quantity) as 'Số lượng sản phẩm bán ra'
FROM order_details od
         JOIN orders o on o.order_id = od.order_id
         JOIN products p on od.product_id = p.product_id
WHERE month(order_date) = 2 and year(order_date)
group by product_name, description;
