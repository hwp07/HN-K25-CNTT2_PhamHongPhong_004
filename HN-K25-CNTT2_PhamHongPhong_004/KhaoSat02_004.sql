CREATE DATABASE test2;
USE test2;

CREATE TABLE Majors (
	major_id VARCHAR(5) PRIMARY KEY,
    major_name VARCHAR(150) UNIQUE,
    department VARCHAR(100),
    duration_years INT,
    tuition_fee DECIMAL(15,2),
    status ENUM('Active', 'Suspended', 'Full') DEFAULT ('Active')
);

ALTER TABLE Majors 
ADD CONSTRAINT chk_tuition_fee CHECK (tuition_fee > 0);

CREATE TABLE Candidates (
	candidate_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    hometown VARCHAR(100)
);

ALTER TABLE Candidates
ADD COLUMN birth_year INT;

CREATE TABLE Applications (
	app_id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_id VARCHAR(5),
    major_id VARCHAR(5),
    apply_date DATE,
    priority_score DECIMAL(4,2),
    
    FOREIGN KEY (candidate_id) REFERENCES Candidates (candidate_id),
    FOREIGN KEY (major_id) REFERENCES Majors (major_id)
);

CREATE TABLE Admissions (
	admission_id INT AUTO_INCREMENT PRIMARY KEY,
    app_id INT,
    total_score DECIMAL(4,2),
    result ENUM('Admitted', 'Rejected', 'Pending'),
    
    FOREIGN KEY (app_id) REFERENCES Applications (app_id)
);


INSERT INTO Majors 
VALUES 
('M01', 'Công nghệ thông tin', 'CNTT', 4, 30000000.00, 'Active'), 
('M02', 'Quản trị kinh doanh', 'Kinh tế', 4, 25000000.00, 'Active'), 
('M03', 'Ngôn ngữ Anh', 'Ngoại ngữ', 4, 22000000.00, 'Full'), 
('M04', 'Kỹ thuật ô tô', 'Cơ khí', 5, 28000000.00, 'Active'), 
('M05', 'Trí tuệ nhân tạo', 'CNTT', 4, 45000000.00, 'Active');

INSERT INTO Candidates 
VALUES 
('C01', 'Nguyễn Phan Anh', 'anh.np@gmail.com', '0912345678', 'Hà Nội', 2006), 
('C02', 'Trần Thị Mai', 'mai.tt@gmail.com', '0987654321', 'Đà Nẵng', 2006), 
('C03', 'Nguyễn Minh Khôi', 'khoi.nm@gmail.com', '0944556677', 'Hải Phòng', 2005), 
('C04', 'Lê Bảo Châu', 'chau.lb@gmail.com', '0966112233', 'TP HCM', 2006), 
('C05', 'Ngô Quang Đăng', 'dang.nq@gmail.com', '0977889900', 'Cần Thơ', 2006);

INSERT INTO Applications 
VALUES 
(1, 'C01', 'M01', '2025-11-10', 0.50), 
(2, 'C03', 'M05', '2025-11-12', 0.00), 
(3, 'C05', 'M01', '2025-11-15', 1.00), 
(4, 'C02', 'M02', '2025-12-01', 0.00), 
(5, 'C01', 'M05', '2025-12-05', 0.50), 
(6, 'C04', 'M03', '2025-12-10', 0.00);

INSERT INTO Admissions 
VALUES 
(1, 1, 27.50, 'Admitted'), 
(2, 2, 24.00, 'Pending'), 
(3, 3, 29.00, 'Admitted');

SELECT * FROM Majors;
SELECT * FROM Candidates;
SELECT * FROM Applications;
SELECT * FROM Admissions;

-- Cập nhật hometown của thí sinh 'C02' thành 'Quảng Nam'.
UPDATE Candidates
SET hometown = 'Quảng Nam'
WHERE candidate_id = 'C02';

-- Giảm học phí (tuition_fee) đi 10% cho tất cả các ngành thuộc khoa 'Ngoại ngữ'.
UPDATE Majors
SET tuition_fee = tuition_fee * 0.9
WHERE department =  'Ngoại ngữ';

-- Xóa các kết quả xét tuyển (Admissions) có trạng thái là 'Rejected'.
DELETE FROM Admissions
WHERE result = 'Rejected';

-- Cập nhật status của các ngành có học phí trên 40,000,000 thành 'Full'.
UPDATE Majors
SET status = 'Full'
WHERE tuition_fee >  40000000;

-- Cập nhật priority_score thành 0 cho tất cả hồ sơ nộp trong tháng 11/2025 mà điểm ưu tiên đang để trống (NULL). 
UPDATE Applications
SET priority_score = 0
WHERE apply_date > '2025-11-01'
	AND apply_date < '2025-11-30'
    AND apply_date IS NULL;
    
-- Liệt kê các ngành học có học phí từ 20,000,000 đến 30,000,000 VNĐ.
SELECT major_name, tuition_fee
FROM Majors
WHERE tuition_fee > 20000000 AND tuition_fee < 30000000;

-- Lấy full_name, email của thí sinh có họ 'Nguyễn'.
SELECT full_name, email
FROM Candidates
WHERE full_name LIKE 'Nguyễn%';

-- Hiển thị major_name, department, sắp xếp theo tuition_fee giảm dần.
SELECT major_name, department 
FROM Majors
ORDER BY tuition_fee DESC;

-- Lấy ra 3 thí sinh có năm sinh (birth_year) nhỏ nhất (lớn tuổi nhất).
SELECT * FROM Candidates
ORDER BY birth_year ASC
LIMIT 3;

-- Hiển thị danh sách hồ sơ đăng ký (Applications) nộp trong tháng 11/2025.
SELECT * FROM Applications
WHERE apply_date > '2025-11-01'
	AND apply_date < '2025-11-30';
    
-- Tìm ngành học có tên bắt đầu bằng 'Công nghệ' hoặc kết thúc bằng 'Anh'.
SELECT major_name
FROM Majors
WHERE major_name LIKE 'Công nghệ %' OR major_name LIKE '% Anh';

-- Lấy thông tin hồ sơ có điểm ưu tiên nằm trong khoảng từ 0.25 đến 0.75.
SELECT * FROM Applications
WHERE priority_score > 0.25 AND priority_score < 0.75;

-- Sắp xếp danh sách thí sinh theo quê quán (hometown) từ A-Z.
SELECT full_name, hometown
FROM Candidates
ORDER BY hometown ASC;

-- Hiển thị app_id, full_name (thí sinh), major_name (ngành), apply_date của các thí sinh quê ở 'Hà Nội'.
SELECT a.app_id, c.full_name, m.major_name, a.apply_date
FROM Applications a 
	JOIN Candidates c ON c.candidate_id = a.candidate_id
    JOIN Majors m ON m.major_id = a.major_id
WHERE c.hometown = 'Hà Nội';

-- Thống kê mỗi khoa (department) hiện có bao nhiêu ngành đào tạo.
SELECT department, COUNT(department) AS total
FROM Majors
GROUP BY department;

-- Liệt kê tên ngành học và tổng số hồ sơ đã đăng ký vào ngành đó (hiển thị cả ngành chưa có hồ sơ).
SELECT m.major_name, COUNT(a.major_id) AS total
FROM Majors m
	LEFT JOIN Applications a ON m.major_id = a.major_id
GROUP BY m.major_id;

-- Tìm các ngành học chưa từng có thí sinh nào đăng ký.


-- Tính tổng học phí dự kiến thu được từ những thí sinh đã trúng tuyển (Admitted) theo từng ngành.
SELECT m.major_name, SUM(m.tuition_fee) AS Total
FROM majors m
	JOIN applications a ON m.major_id = a.major_id
    JOIN admissions ad ON ad.app_id = a.app_id
WHERE  ad.result = 'Admitted'
GROUP BY m.major_name;

-- Tìm ngành học có mức học phí cao nhất trong hệ thống.
SELECT major_name 
FROM majors
ORDER BY tuition_fee DESC
LIMIT 1;

-- Liệt kê thông tin các thí sinh sinh năm 2006 đã trúng tuyển vào khoa 'CNTT'.  

    
    

