CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(30) NOT NULL,
  email VARCHAR(50) NOT NULL UNIQUE,
  phone VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(255) NOT NULL UNIQUE,
  price DECIMAL(10,2) NOT NULL CHECK (price > 0),
  category_id INT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM('Pending','Completed','Cancel') DEFAULT 'Pending',
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  UNIQUE (order_id, product_id)
);

INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyen Van An', 'an@gmail.com', '0912345678'),
('Tran Thi Binh', 'binh@gmail.com', '0923456789'),
('Le Quang Cuong', 'cuong@gmail.com', '0934567890'),
('Pham Minh Duc', 'duc@gmail.com', '0945678901'),
('Hoang Gia Han', 'han@gmail.com', '0956789012'),
('Do Thu Ha', 'ha@gmail.com', '0967890123'),
('Vu Tuan Kiet', 'kiet@gmail.com', '0978901234');

INSERT INTO categories (category_name) VALUES
('Dien thoai'),
('Laptop'),
('Phu kien'),
('Thiet bi mang');

INSERT INTO products (product_name, price, category_id) VALUES
('iPhone 15', 23990000.00, 1),
('Samsung S24', 20990000.00, 1),
('MacBook Air M2', 26990000.00, 2),
('Asus Vivobook', 15990000.00, 2),
('Tai nghe Bluetooth', 590000.00, 3),
('Chuot gaming', 450000.00, 3),
('Router WiFi 6', 1290000.00, 4),
('SSD 1TB', 1990000.00, 3),
('iPad Gen 10', 10990000.00, 1),
('Laptop Lenovo ThinkPad', 22990000.00, 2);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-08-02 10:15:00', 'Completed'),
(1, '2024-08-10 19:20:00', 'Pending'),
(2, '2024-08-05 08:05:00', 'Completed'),
(3, '2024-07-25 14:30:00', 'Cancel'),
(4, '2024-08-18 12:00:00', 'Completed'),
(6, '2024-08-21 09:45:00', 'Pending'),
(7, '2024-06-30 16:10:00', 'Completed'),
(2, '2024-08-22 20:10:00', 'Completed'),
(4, '2024-09-01 11:30:00', 'Completed'),
(5, '2024-09-03 15:05:00', 'Pending');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 5, 2),
(2, 2, 1),
(2, 6, 1),
(3, 3, 1),
(3, 7, 1),
(4, 4, 1),
(5, 6, 2),
(5, 5, 1),
(6, 7, 1),
(7, 5, 3),
(8, 9, 1),
(8, 5, 1),
(9, 10, 1),
(9, 8, 1),
(10, 2, 1);

-- A1) Lấy danh sách tất cả danh mục sản phẩm trong hệ thống
SELECT category_id, category_name
FROM categories;

-- A2) Lấy danh sách đơn hàng có trạng thái là COMPLETED
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE status = 'Completed';

-- A3) Lấy danh sách sản phẩm và sắp xếp theo giá giảm dần
SELECT product_id, product_name, price, category_id
FROM products
ORDER BY price DESC;

-- A4) Lấy 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên
SELECT product_id, product_name, price
FROM products
ORDER BY price DESC
LIMIT 5 OFFSET 2;

-- B1) Lấy danh sách sản phẩm kèm tên danh mục
SELECT
  p.product_id,
  p.product_name,
  p.price,
  c.category_name
FROM products p
JOIN categories c ON c.category_id = p.category_id;

-- B2) Lấy danh sách đơn hàng gồm: order_id, order_date, customer_name, status
SELECT
  o.order_id,
  o.order_date,
  cu.customer_name,
  o.status
FROM orders o
JOIN customers cu ON cu.customer_id = o.customer_id;

-- B3) Tính tổng số lượng sản phẩm trong từng đơn hàng
SELECT o.order_id, SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id;

-- B4) Thống kê số đơn hàng của mỗi khách hàng
SELECT cu.customer_id, cu.customer_name, COUNT(o.order_id) AS order_count
FROM customers cu
LEFT JOIN orders o ON o.customer_id = cu.customer_id
GROUP BY cu.customer_id, cu.customer_name;

-- B5
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2;

-- B6) Thống kê giá trung bình, thấp nhất và cao nhất của sản phẩm theo danh mục
SELECT c.category_id, c.category_name, AVG(p.price) AS avg_price, MIN(p.price) AS min_price, MAX(p.price) AS max_price
FROM categories c
JOIN products p ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

-- C1
SELECT product_id, product_name, price
FROM products
WHERE price > (
    SELECT AVG(price) 
    FROM products
);

-- C2
SELECT 
    customer_id, customer_name, email
FROM
    customers
WHERE
    customer_id IN (SELECT DISTINCT
            customer_id
        FROM
            orders);
            
-- C3) Lấy đơn hàng có tổng số lượng sản phẩm lớn nhất
SELECT order_id, total_quantity
FROM (
  SELECT order_id, SUM(quantity) AS total_quantity
  FROM order_items
  GROUP BY order_id
) t
WHERE total_quantity = (
  SELECT MAX(total_quantity)
  FROM (
    SELECT SUM(quantity) AS total_quantity
    FROM order_items
    GROUP BY order_id
  ) x
);

-- C5) Từ bảng tạm (subquery), thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
SELECT customer_id, total_quantity
FROM (
  SELECT o.customer_id, SUM(oi.quantity) AS total_quantity
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  GROUP BY o.customer_id
) t
ORDER BY total_quantity DESC;

-- C4 
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category_id = (
    SELECT category_id
    FROM products
    GROUP BY category_id
    ORDER BY AVG(price) DESC
    LIMIT 1
);

-- C6
SELECT *
FROM products
WHERE price = (
    SELECT MAX(price)
    FROM products
);