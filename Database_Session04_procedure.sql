use Demo;
select * from categories;
select * from product;
-- Lấy ra tất cả các sản phẩm có tên danh mục là Danh mục 1, Danh mục 2, Danh mục 7
-- Cách 1: Chúng ta sử dụng join để liên kết 2 bảng
select p.*, c.cat_name
from product p join categories c on p.cat_id = c.cat_id
where c.cat_name in ('Danh mục 1',"Danh mục 2","Danh mục 7");
-- Cách 2: Truy vấn lồng: kết quả của câu lệnh truy vấn này là đầu vào
-- của câu lệnh truy vấn khác
-- Bước 1: Tạo 1 câu truy vấn lấy ra các mã danh mục có tên là DM1, DM2, DM7
-- Bước 2: Tạo 1 câu truy vấn lây thông tin các sản phẩm có mã danh 
-- mục thuộc kết quả của câu lệnh truy vấn 1
select *
from product p
where p.cat_id in (
	select c.cat_id
	from categories c
	where c.cat_name in ('Danh mục 1','Danh mục 2','Danh mục 7'));
/*
	Procedure == method of Java: Khi tạo procedure (build) thì procedure sẽ
    được lưu vào bộ nhớ của database, khi gọi procedure thì không phải buil lại
    
    Syntax:
    DELIMITER &&
    CREATE PROCEDURE [procedure_name](
		[IN | OUT | INOUT] params datatype,
        [IN | OUT | INOUT] params datatype
    )
    BEGIN
    END &&
    DELIMITER &&;
    
    kết quả của câu lệnh truy vấn thì mặc định trả ra 1 đối tượng resultset
*/
-- 1. Xây dựng 1 procedure cho phép lấy thông tin tất cả các sản phẩm
DELIMITER &&
create procedure find_all_product()
BEGIN
	-- Block statements: thực hiện chức năng của procedure
    select * from product;
END &&
DELIMITER &&;
-- Gọi procedure để chạy
call find_all_product();
-- 2. Xây dựng procedure cho phép lấy ra số lượng sản phẩm trong 1 danh mục
DELIMITER &&
create procedure get_cnt_product_by_cat_id(
	-- Tham số vào
	cat_id_in int,
    OUT cnt_product int
)
BEGIN
	-- Đếm số lượng các sản phẩm có mã danh mục là cat_id_in và gán vào cho tham số ra cnt_product    
	set cnt_product = (select count(p.product_id) from product p where p.cat_id = cat_id_in);
END &&
DELIMITER &&;
call get_cnt_product_by_cat_id(1,@cnt_product);
select @cnt_product;
-- 3. Xây dựng procedure cho phép lấy tên danh mục theo mã danh mục
DELIMITER &&
create procedure find_name_by_cat_id(
	cat_id_in int,
    OUT cat_name_out varchar(100)
)
BEGIN
	set cat_name_out = (select c.cat_name from categories c where c.cat_id = cat_id_in limit 1);
END &&
DELIMITER &&;
call find_name_by_cat_id(2,@name);
select @name;
-- 4. Xây dựng procedure cho phép thêm mới một danh mục
DELIMITER &&
create procedure add_categories(
	name_in varchar(100),
    des_in text,
    status_in bit
)
BEGIN
	insert into categories(cat_name, cat_descriptions, cat_status)
    values(name_in, des_in, status_in);
END &&
DELIMITER &&;
call add_categories('Danh mục test proc','Mô tả danh mục test',1);
select * from categories;

-- 5. Xây dựng procedure cho phép cập nhật 1 danh mục theo mã danh mục
DELIMITER &&
create procedure update_categories(
	id_in int,
    name_in varchar(100),
    des_in text,
    status_in bit
)
BEGIN
	update categories
    set cat_name = name_in,
		cat_descriptions = des_in,
        cat_status = status_in
	where cat_id = id_in;
END &&
DELIMITER &&;
call update_categories(10,'Danh mục test','Mô tả test',0);
-- 6.  Xây dựng procedure cho phép xóa danh mục theo mã danh mục
DELIMITER &&
create procedure delete_categories(id_in int)
BEGIN
	delete from categories where cat_id = id_in;
END &&
DELIMITER &&;
call delete_categories(10);
/*
	1. Xây dựng bảng Book_Type gồm các thông tin sau:
		- book_type_id int, PK, Auto_increment
        - book_type_name varchar(100), not null, unique
        - book_type_descriptions text
        - book_type_status bit
	2. Xây dựng bảng Books gồm các thông tin sau:
		- book_id char(4) PK,
        - book_name varchar(200) not null, unique
        - book_price float, check(price>0),
        - created date,
        - book_content text not null,
        - publisher varchar(150) not null,
        - no_of_pages int not null,
        - author varchar(100),
        - book_type_id int not null, FK (Book_type)
        - book_status bit
	3. Thêm mỗi bảng 10 dữ liệu
    4. Xây dựng các procedure sau:
		4.1. Cho phép lấy tất cả các loại sách có trạng thái là 1
        4.2. Cho phép thêm mới 1 loại sách
        4.3. Cho phép cập nhật thông tin loại sách
        4.4. Cho phép xóa loại sách theo mã loại sách:
			- Nếu loại sách chưa chứa giá trị sách thì cho xóa sách và trả về kết quả là 1 (if-else mysql)
            - Nếu loại sách đã chứa sách thì không cho xóa và trả về kết quả là 0
		4.5. Cho phép lấy tất cả sách: gồm thông tin sách, tên loại sách
        4.6. Cho phép thêm mới sách
        4.7. Cho phép cập nhật sách theo mã sách
        4.8. Cho phép xóa sách theo mã sách
        4.9. Thống kê số lượng sách theo loại sách
*/



