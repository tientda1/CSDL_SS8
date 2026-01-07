CREATE DATABASE mini_project_ss08;
USE mini_project_ss08;

-- Xóa bảng nếu đã tồn tại (để chạy lại nhiều lần)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

-- Bảng khách hàng
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO guests (guest_name, phone) VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'), -- 2 ngày
(1, 3, '2024-03-05', '2024-03-10'), -- 5 ngày
(2, 2, '2024-02-01', '2024-02-03'), -- 2 ngày
(2, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
(4, 1, '2024-06-10', '2024-06-11'); -- 1 ngày


-- P1: Truy vấn dữ liệu cơ bản
-- C1 : Liệt kê tên khách và số điện thoại của tất cả khách hàng
select guest_name, phone from guests;

-- C2 : Liệt kê các loại phòng khác nhau trong khách sạn
select room_type from rooms;

-- C3 : Hiển thị loại phòng và giá thuê theo ngày, sắp xếp theo giá tăng dần
select room_type, price_per_day from rooms
order by price_per_day asc;

-- C4: Hiển thị các phòng có giá thuê lớn hơn 1.000.000
select * from rooms
where price_per_day > 1000000;

-- C5 : Liệt kê các lần đặt phòng diễn ra trong năm 2024
select * from bookings
where check_in < '2025-1-1' and check_out >= '2024-1-1';

-- C6 : Cho biết số lượng phòng của từng loại phòng
select room_type, count(*) as room_count from rooms
group by room_type;

-- P2 : Truy vấn nâng cao
-- C1 : Hãy liệt kê danh sách các lần đặt phòng, Với mỗi lần đặt phòng, hãy hiển thị:○Tên khách hàng○Loại phòng đã đặt○Ngày nhận phòng (check_in)

select b.booking_id, g.guest_name, r.room_type, b.check_in from bookings b
join guests g on g.guest_id = b.guest_id
join rooms r on r.room_id = b.room_id;

-- C2 : Cho biết mỗi khách đã đặt phòng bao nhiêu lần

select g.guest_id, g.guest_name, count(b.booking_id) booking_count from guests g
left join bookings b on b.guest_id = g.guest_id
group by g.guest_id, g.guest_name;

-- C3 : Tính doanh thu của mỗi phòng

select  r.room_id, r.room_type, r.price_per_day, sum(datediff(b.check_out, b.check_in) * r.price_per_day) as total_revenue
from rooms r
join bookings b on r.room_id = b.room_id
group by r.room_id, r.room_type, r.price_per_day

-- C4 : Hiển thị tổng doanh thu của từng loại phòng

select r.room_id, r.room_type,
       count(*) * r.price_per_day as doanh_thu
from rooms r
join bookings b on r.room_id = b.room_id
group by r.room_id, r.room_type, r.price_per_day;

-- C5 : Tìm những khách đã đặt phòng từ 2 lần trở lên
select guest_name, count(*) as total_bookings
from guests g
join bookings b on g.guest_id = b.guest_id
group by g.guest_name
having count(*) >= 2;

-- C6 : Tìm loại phòng có số lượt đặt phòng nhiều nhất
select r.room_type, count(*) as total_bookings
from bookings b
join rooms on b.room_id = r.room_id
group by r.room_type
order by total_bookings DESC
limit 1;

-- P3 : Truy vấn lồng
-- C1 : Hiển thị những phòng có giá thuê cao hơn giá trung bình của tất cả các phòng
select room_id, room_type, price_per_day
from rooms
where price_per_day > (select avg(price_per_day) from rooms);

-- C2 : Hiển thị những khách chưa từng đặt phòng
select g.guest_id, g.guest_name, g.phone
from guests g
left join bookings b on g.guest_id = b.guest_id
where b.booking_id is null;

-- C3 : Tìm phòng được đặt nhiều lần nhất
select r.room_id, r.room_type, count(b.booking_id) as total_bookings
from bookings b
join rooms r on b.room_id = r.room_id
group by r.room_id, r.room_type
order by total_bookings desc limit 1;
 




