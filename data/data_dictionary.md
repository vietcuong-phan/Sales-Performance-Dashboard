# Data Dictionary

Mô tả bộ dữ liệu thô `data/raw/Sales_Raw_data.csv` dùng cho dashboard **Sales Performance Dashboard**.

## 1. Thông tin chung

| Hạng mục | Giá trị |
|---|---|
| Tên file | `Sales_Performance_Raw_data.csv` (UTF-8) |
| Số dòng / số cột | 20.000 dòng / 21 cột |
| Khoảng thời gian | 01/09/2023 đến 23/09/2024 (tháng 09/2024 mới có dữ liệu đến ngày 23) |
| Mức chi tiết (grain) | 1 dòng = 1 đơn hàng = 1 sản phẩm (`OrderID` duy nhất ở cả 20.000 dòng) |
| Số khách hàng / sản phẩm | 12.136 khách hàng / 16 sản phẩm (16 SKU, 5 nhóm sản phẩm) |
| Bản chất dữ liệu | Dữ liệu mô phỏng, dùng cho mục đích học tập và portfolio |

## 2. Mô tả 21 cột

Số thứ tự (#) là vị trí cột trong file CSV; các cột được xếp theo nhóm ý nghĩa nên thứ tự # không liên tục. Cột "Bảng trong mô hình" cho biết cột được nạp vào bảng nào sau khi qua Power Query. Tỷ lệ phần trăm của `Gender`, `AgeGroup`, `Loyalty` tính trên số khách hàng; các cột còn lại tính trên số đơn.

### Nhóm đơn hàng

| # | Cột | Kiểu | Mô tả | Giá trị / phạm vi | Bảng trong mô hình |
|---|---|---|---|---|---|
| 1 | `OrderID` | Text | Mã đơn hàng, định dạng `ORD000028` | 20.000 giá trị duy nhất | `fact_sales` |
| 2 | `OrderDate` | Date | Ngày đặt hàng | 2023-09-01 đến 2024-09-23 | `fact_sales` (nối với `dim_date[Date]`) |
| 17 | `OrderStatus` | Text | Trạng thái đơn | `Completed` 13.435 (67,2%); `Cancelled` 6.565 (32,8%) | `fact_sales` |
| 18 | `ShippingType` | Text | Hình thức giao hàng | `Standard` 10.047 (50,2%); `Express` 4.972 (24,9%); `Economy` 2.973 (14,9%); `Same-Day` 2.008 (10,0%) | `fact_sales` |
| 19 | `PaymentType` | Text | Hình thức thanh toán | `Credit Card` 6.945 (34,7%); `E-Wallet` 5.052 (25,3%); `Debit Card` 4.031 (20,2%); `Bank Transfer` 2.019 (10,1%); `Cash on Delivery` 1.953 (9,8%) | `fact_sales` |
| 20 | `Rating` | Integer | Điểm đánh giá của khách | 1 đến 5; để trống ở 6.565 đơn `Cancelled`. Phân bố (đơn Completed): 1 sao 1.562; 2 sao 2.337; 3 sao 4.345; 4 sao 3.198; 5 sao 1.993 | `fact_sales` |
| 21 | `CancellationReason` | Text | Lý do hủy đơn | Để trống ở 13.435 đơn `Completed`. Đơn `Cancelled`: `Found better price` 1.119; `Other` 1.110; `Duplicate order` 1.105; `Payment failed` 1.089; `Changed mind` 1.080; `Out of stock` 1.062 | `fact_sales` |

### Nhóm khách hàng

| # | Cột | Kiểu | Mô tả | Giá trị / phạm vi | Bảng trong mô hình |
|---|---|---|---|---|---|
| 3 | `CustomerID` | Text | Mã khách hàng, định dạng `C02325` | 12.136 giá trị duy nhất; mỗi khách có từ 1 đến 7 đơn (trung bình 1,65) | `fact_sales`, `dim_customer` |
| 4 | `Gender` | Text | Giới tính | `Female` 6.366 (52,5%); `Male` 5.770 (47,5%) | `dim_customer` |
| 5 | `AgeGroup` | Text | Nhóm tuổi | `Adult` 3.720 (30,7%); `Middle Age` 3.103 (25,6%); `Young Adult` 2.133 (17,6%); `Mature` 1.958 (16,1%); `Senior` 1.222 (10,1%) | `dim_customer` |
| 6 | `Loyalty` | Text | Nhãn khách hàng thân thiết có sẵn trong dữ liệu nguồn (không phải điểm RFM tính trong mô hình) | `Yes` 8.444 (69,6%); `No` 3.692 (30,4%) | `dim_customer` |

### Nhóm sản phẩm

| # | Cột | Kiểu | Mô tả | Giá trị / phạm vi | Bảng trong mô hình |
|---|---|---|---|---|---|
| 7 | `ProductID` | Text | Mã sản phẩm, `P0001` đến `P0016` | 16 giá trị | `fact_sales`, `dim_product` |
| 8 | `SKU` | Text | Mã SKU, ví dụ `LAP-0011`, `SMA-0002` | 16 giá trị, khớp 1-1 với `ProductID` | `dim_product` |
| 9 | `ProductType` | Text | Nhóm sản phẩm | `Laptop`, `Smartphone`, `Tablet`, `Smartwatch`, `Headphones` | `dim_product` |
| 10 | `ProductName` | Text | Tên sản phẩm, ví dụ `Laptop Model A` | 16 giá trị | `dim_product` |
| 12 | `UnitPrice` | Number | Giá bán một sản phẩm | 71,71 đến 1.358,56 (theo từng sản phẩm, không đổi theo thời gian) | `dim_product` |
| 13 | `UnitCost` | Number | Giá vốn một sản phẩm | 5,76 đến 327,14 | `dim_product` |

### Nhóm số lượng và tài chính

| # | Cột | Kiểu | Mô tả | Giá trị / phạm vi | Bảng trong mô hình |
|---|---|---|---|---|---|
| 11 | `Quantity` | Integer | Số sản phẩm trong đơn | 1 đến 14, trung bình 5,52 | `fact_sales` |
| 14 | `Revenue` | Number | Doanh thu của đơn | 71,71 đến 19.019,84, trung bình 2.935,44 | `fact_sales` |
| 15 | `Cost` | Number | Chi phí của đơn | 5,76 đến 4.579,96, trung bình 624,05 | `fact_sales` |
| 16 | `Profit` | Number | Lợi nhuận của đơn | 65,95 đến 14.439,88, trung bình 2.311,39 (luôn dương) | `fact_sales` |

## 3. Quan hệ giữa các cột

Các công thức dưới đây đã được kiểm tra, khớp với 100% số dòng (sai số làm tròn 0,01):

| Công thức | Ý nghĩa |
|---|---|
| `Revenue = Quantity × UnitPrice` | Doanh thu bằng số lượng nhân giá bán |
| `Cost = Quantity × UnitCost` | Chi phí bằng số lượng nhân giá vốn |
| `Profit = Revenue − Cost` | Lợi nhuận bằng doanh thu trừ chi phí |
| `OrderStatus = Cancelled` <=> `Rating` trống <=> `CancellationReason` có giá trị | Chỉ đơn bị hủy mới có lý do hủy và không có đánh giá |

## 4. Kết quả kiểm tra chất lượng dữ liệu

| Kiểm tra | Kết quả |
|---|---|
| Trùng `OrderID` | 0 |
| Giá trị trống (null) | Chỉ có ở `Rating` (6.565 dòng, toàn bộ là đơn `Cancelled`) |
| `CancellationReason` | Chuỗi rỗng ở 13.435 đơn `Completed`; mọi đơn `Cancelled` đều có lý do |
| Toàn vẹn khóa ngoại | Mọi `CustomerID` trong `fact_sales` đều có trong `dim_customer` và ngược lại |
| Ánh xạ sản phẩm | 16 `ProductID` <=> 16 `SKU` <=> 16 `ProductName`, khớp 1-1 |
| `Profit` | Luôn dương (nhỏ nhất 65,95) |

## 5. Lưu ý khi sử dụng

1. **Tiền tố SKU không phải mã nhóm sản phẩm.** `SMA-` được dùng cho cả Smartphone (`SMA-0001` đến `SMA-0003`) và Smartwatch (`SMA-0007` đến `SMA-0010`). Luôn dùng `ProductType` để phân nhóm, không tách tiền tố của `SKU`.
2. **`Revenue` và `Profit` gồm cả đơn bị hủy.** Doanh thu của riêng đơn `Completed` thấp hơn tổng doanh thu khoảng một phần ba; cần lọc `OrderStatus` khi muốn tính doanh thu thực.
3. **`Loyalty` là nhãn có sẵn.** Nó không được tính từ hành vi mua trong bộ dữ liệu này (khách `Yes` và `No` có tần suất mua gần như bằng nhau), nên không nên đồng nhất với phân khúc RFM.
4. **Thuộc tính khách hàng lặp ở từng dòng đơn.** `Gender`, `AgeGroup`, `Loyalty` được ghi lại ở mỗi đơn của cùng một khách; khi tạo `dim_customer`, mô hình giữ dòng đầu tiên của mỗi `CustomerID`.
5. **Dữ liệu mô phỏng.** Biên lợi nhuận rất cao (khoảng 78,7%), và các phân bố như lý do hủy, rating, hình thức giao hàng gần như phẳng. Nên đọc kết quả phân tích như bài thực hành kỹ thuật, không phải kết luận kinh doanh thực tế.
6. **Tháng cuối chưa đủ.** Tháng 09/2024 chỉ có dữ liệu đến ngày 23, nên các so sánh MoM của tháng này bị lệch xuống.

## 6. Từ dữ liệu thô đến mô hình

| Bảng | Nguồn | Cột lấy từ CSV | Cột bổ sung |
|---|---|---|---|
| `fact_sales` | CSV | `OrderID`, `OrderDate`, `CustomerID`, `ProductID`, `Quantity`, `Revenue`, `Cost`, `Profit`, `OrderStatus`, `ShippingType`, `PaymentType`, `Rating`, `CancellationReason` | Không |
| `dim_customer` | CSV (loại trùng theo `CustomerID`) | `CustomerID`, `Gender`, `AgeGroup`, `Loyalty` | `AgeGroupSort` (Power Query); `OrderCount`, `ProductCount`, `FirstOrderDate`, `FirstOrderMonth`, `FirstOrderMonthSort` (DAX) |
| `dim_product` | CSV (loại trùng theo `ProductID`) | `ProductID`, `SKU`, `ProductType`, `ProductName`, `UnitPrice`, `UnitCost` | Không |
| `dim_date` | Tạo bằng Power Query | Không dùng CSV | 14 cột lịch (xem `power_query/M_scripts.md`) |

Chi tiết các bước biến đổi nằm trong [`power_query/M_scripts.md`](../power_query/M_scripts.md).
