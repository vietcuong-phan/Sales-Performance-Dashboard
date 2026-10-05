# EDA Findings

Kết luận từ bước khám phá và kiểm tra dữ liệu `Sales_Raw_data.csv` trước khi đưa vào Power BI. Mã nguồn và kết quả từng bước nằm trong notebook [`data_profiling.ipynb`](./data_profiling.ipynb).

## 1. Tóm tắt

| # | Kết luận | Tác động lên mô hình |
|---|---|---|
| 1 | Dữ liệu sạch: không trùng dòng, không trùng `OrderID`, không thừa khoảng trắng, 20 trên 20 kiểm tra toàn vẹn đạt (xem mục 3) | Không cần loại dòng hay điền giá trị thiếu |
| 2 | Giá trị trống chỉ có ở `Rating` (6.565 dòng) và `CancellationReason` (13.435 dòng), đúng theo logic nghiệp vụ | Giữ nguyên giá trị trống, không điền |
| 3 | Doanh thu, chi phí, lợi nhuận khớp công thức ở 100% số dòng | Dùng trực tiếp cột nguồn, không tính lại |
| 4 | Giá trị lớn ở `Revenue` (670 đơn vượt ngưỡng IQR) đều hợp lệ vì do số lượng nhân đơn giá | Giữ lại, không coi là ngoại lai cần loại |
| 5 | Dữ liệu liên tục 389 ngày (01/09/2023 đến 23/09/2024), tháng cuối chỉ đến ngày 23 | `dim_date` phủ rộng hơn dữ liệu; ghi chú khi đọc MoM của tháng 09/2024 |
| 6 | Doanh thu và lợi nhuận gồm cả đơn bị hủy (32,8% số đơn) | Cần slicer `OrderStatus` hoặc measure doanh thu thuần |
| 7 | Nhiều dấu hiệu cho thấy dữ liệu mô phỏng (biên lợi nhuận 78,7%, phân bố gần phẳng) | Đọc kết quả như bài thực hành phân tích |

## 2. Cấu trúc dữ liệu

| Hạng mục | Giá trị |
|---|---|
| Số dòng / số cột | 20.000 / 21 |
| Mức chi tiết | 1 dòng = 1 đơn hàng = 1 sản phẩm |
| Khoảng thời gian | 01/09/2023 đến 23/09/2024 (389 ngày) |
| Số khách / sản phẩm / nhóm sản phẩm | 12.136 / 16 SKU / 5 nhóm |
| Kiểu dữ liệu | 1 cột ngày, 1 cột số nguyên (`Quantity`), 5 cột số thực (đơn giá, giá vốn, doanh thu, chi phí, lợi nhuận) cộng `Rating`, các cột còn lại là text |

Mô tả từng cột xem [`data_dictionary.md`](../data/data_dictionary.md).

## 3. Chất lượng dữ liệu

### 3.1 Kết quả kiểm tra toàn vẹn (20 trên 20 đạt)

| Nhóm | Kiểm tra | Kết quả |
|---|---|---|
| Khóa và định dạng | `OrderID` duy nhất; `OrderID` dạng `ORD` cộng 6 chữ số; `CustomerID` dạng `C` cộng 5 chữ số; `ProductID` dạng `P` cộng 4 chữ số; `SKU` dạng `AAA-0000` | Đạt |
| Giá trị trống | Không có giá trị trống ngoài `Rating` và `CancellationReason` | Đạt |
| Ánh xạ sản phẩm | Mỗi `ProductID` chỉ ứng với một SKU, nhóm, tên, đơn giá, giá vốn; `ProductID` và `SKU` khớp 1-1 | Đạt |
| Thuộc tính khách | `Gender`, `AgeGroup`, `Loyalty` không đổi giữa các đơn của cùng một `CustomerID` | Đạt(*) |
| Miền giá trị | `Quantity` từ 1 đến 14; đơn giá lớn hơn giá vốn và giá vốn lớn hơn 0; `Profit` luôn dương (nhỏ nhất 65,95); `Rating` từ 1 đến 5; `OrderStatus` chỉ gồm `Completed` và `Cancelled` | Đạt |
| Đẳng thức tài chính | `Revenue = Quantity × UnitPrice`; `Cost = Quantity × UnitCost`; `Profit = Revenue − Cost` (sai số làm tròn 0,011) | Đạt |
| Logic trạng thái | `Rating` trống khi và chỉ khi đơn `Cancelled`; `CancellationReason` có giá trị khi và chỉ khi đơn `Cancelled` | Đạt |
| Ngày tháng | `OrderDate` không trống, hợp lệ | Đạt |

\(*) Kiểm tra này quyết định việc loại trùng `dim_customer` theo `CustomerID` trong Power Query có an toàn hay không (bước đó giữ dòng đầu tiên của mỗi khách). Cần xác nhận lại sau khi chạy notebook trên file CSV gốc.

### 3.2 Giá trị trống

| Cột | Số dòng trống | Tỷ lệ | Nguyên nhân |
|---|---|---|---|
| `Rating` | 6.565 | 32,82% | Toàn bộ là đơn `Cancelled`, đơn hủy không có đánh giá |
| `CancellationReason` | 13.435 | 67,18% | Toàn bộ là đơn `Completed`, đơn hoàn thành không có lý do hủy |

## 4. Thống kê mô tả và ngoại lai

| Cột | Nhỏ nhất | Trung vị | Trung bình | Lớn nhất |
|---|---|---|---|---|
| `Quantity` | 1 | 5 | 5,52 | 14 |
| `UnitPrice` | 71,71 | 370,62 | 530,57 | 1.358,56 |
| `Revenue` | 71,71 | 1.910,92 | 2.935,44 | 19.019,84 |
| `Cost` | 5,76 | 339,36 | 624,05 | 4.579,96 |
| `Profit` | 65,95 | 1.566,18 | 2.311,39 | 14.439,88 |

**Ngoại lai (quy tắc IQR):**

| Cột | Ngưỡng trên | Số đơn vượt ngưỡng | Tỷ lệ |
|---|---|---|---|
| `Quantity` | 11,5 | 97 | 0,48% |
| `Revenue` | 9.317,95 | 670 | 3,35% |
| `Profit` | 7.012,90 | 689 | 3,45% |

Tất cả 670 đơn có doanh thu cao đều thuộc Laptop (575 đơn) và Smartphone (95 đơn), và đều thỏa `Revenue = Quantity × UnitPrice`. Đây là đơn lớn thật sự chứ không phải lỗi nhập liệu, nên được giữ lại. Phân bố doanh thu lệch phải, vì vậy khi báo cáo nên dùng thêm trung vị (1.910,92) bên cạnh trung bình (2.935,44).

## 5. Phân bố theo nhóm

| Cột | Phân bố |
|---|---|
| `OrderStatus` | Completed 67,2%; Cancelled 32,8% |
| `ShippingType` | Standard 50,2%; Express 24,9%; Economy 14,9%; Same-Day 10,0% |
| `PaymentType` | Credit Card 34,7%; E-Wallet 25,3%; Debit Card 20,2%; Bank Transfer 10,1%; Cash on Delivery 9,8% |
| `ProductType` (theo đơn) | Smartphone 30,1%; Tablet 20,6%; Smartwatch 19,7%; Laptop 19,4%; Headphones 10,1% |
| `Gender` (theo khách) | Female 52,5%; Male 47,5% |
| `AgeGroup` (theo khách) | Adult 30,7%; Middle Age 25,6%; Young Adult 17,6%; Mature 16,1%; Senior 10,1% |
| `Loyalty` (theo khách) | Yes 69,6%; No 30,4% |

## 6. Thời gian

- Dữ liệu liên tục 389 ngày, mọi ngày đều có ít nhất một đơn (trung bình 51,4 đơn mỗi ngày, ít nhất 2, nhiều nhất 91).
- Tháng đầu (09/2023) chỉ có 190 đơn, các tháng 10 đến 12/2023 từ 797 đến 911 đơn, rồi tháng 01/2024 nhảy lên 2.049 đơn (+156,1%).
- Từ 02/2024 đến 08/2024, số đơn đi ngang trong khoảng 1.818 đến 2.049 đơn mỗi tháng.
- Biên lợi nhuận gần như không đổi giữa các tháng (khoảng 78,5% đến 78,9%). Tỷ lệ hủy dao động từ 30,9% đến 36,1%, không có xu hướng rõ.
- Tháng 09/2024 chỉ có dữ liệu đến ngày 23 (1.490 đơn), nên mọi so sánh với tháng trước của tháng này đều bị lệch xuống (−26,2% số đơn).

## 7. Khách hàng

| Chỉ số | Giá trị |
|---|---|
| Khách chỉ mua 1 đơn | 7.012 (57,8%) |
| Khách có 2 / 3 / 4 / từ 5 đơn trở lên | 3.162 (26,1%) / 1.325 (10,9%) / 504 (4,2%) / 133 (1,1%) |
| Khách quay lại (hơn 1 đơn) | 5.124 (42,2%), tạo ra 64,7% doanh thu |
| 20% khách chi tiêu nhiều nhất | 48,7% doanh thu |
| Số đơn tối đa của một khách | 7 |

Nhãn `Loyalty` có sẵn trong dữ liệu không phản ánh hành vi mua: nhóm "Yes" và "No" đều có 1,65 đơn mỗi khách, doanh thu mỗi khách chênh nhau khoảng 2% (4.867 so với 4.771).

## 8. Sản phẩm

| Nhóm | Tỷ trọng doanh thu | Biên lợi nhuận | Giá trị trung bình mỗi đơn |
|---|---|---|---|
| Laptop | 40,4% | 73,7% | 6.089,78 |
| Smartphone | 37,4% | 81,4% | 3.646,84 |
| Tablet | 11,9% | 76,2% | 1.700,30 |
| Smartwatch | 7,5% | 91,6% | 1.112,50 |
| Headphones | 2,8% | 92,8% | 814,48 |

7 trên 16 SKU tạo ra 80% doanh thu (biểu đồ Pareto ở mục 9 của notebook).

## 9. Hủy đơn và đánh giá

- **Tỷ lệ hủy theo nhóm** dao động hẹp: theo sản phẩm từ 30,5% (Headphones) đến 34,4% (Tablet); theo hình thức giao 32,5% đến 33,7%; theo hình thức thanh toán 31,7% (E-Wallet) đến 34,3% (Bank Transfer).
- **Lý do hủy** phân bố gần như đều, mỗi lý do chiếm 16,2% đến 17,0% số đơn hủy (cao nhất: Found better price 17,0%; thấp nhất: Out of stock 16,2%).
- **Doanh thu của đơn bị hủy:** 19,52 triệu, bằng 33,2% tổng doanh thu.
- **Rating** (đơn hoàn thành): 1 đến 2 sao 29,0%, 3 sao 32,3%, 4 đến 5 sao 38,6%; trung bình 3,13, gần như bằng nhau ở mọi nhóm sản phẩm (3,11 đến 3,15).

## 10. Quyết định xử lý dữ liệu cho bước Power Query

| Quyết định | Lý do |
|---|---|
| Không loại dòng nào, không điền giá trị thiếu | Dữ liệu sạch; giá trị trống của `Rating` và `CancellationReason` có ý nghĩa nghiệp vụ |
| Giữ cả đơn `Cancelled` trong `fact_sales`, phân biệt bằng cột `OrderStatus` | Cần phân tích tỷ lệ và lý do hủy; người xem lọc bằng slicer |
| Giữ các đơn có doanh thu cao | Hợp lệ theo công thức, không phải lỗi |
| Dùng nguyên `Revenue`, `Cost`, `Profit` từ nguồn | Đã kiểm tra khớp công thức ở 100% số dòng |
| Tạo `dim_customer` bằng cách loại trùng theo `CustomerID` | Thuộc tính khách không đổi giữa các đơn (xem chú thích ở mục 3.1) |
| Tạo `dim_product` bằng cách loại trùng theo `ProductID` | `ProductID` ứng 1-1 với SKU, tên, đơn giá, giá vốn |
| Phân nhóm sản phẩm bằng `ProductType`, không tách từ tiền tố `SKU` | `SMA-` dùng chung cho cả Smartphone và Smartwatch |
| `dim_date` phủ 2022 đến 2025 | Phủ rộng hơn dữ liệu để các phép so sánh tháng trước không bị cắt ở biên |

## 11. Rủi ro và lưu ý khi đọc kết quả

1. **Dữ liệu mô phỏng.** Giá vốn chỉ bằng khoảng 7% đến 29% giá bán nên biên lợi nhuận lên tới 78,7%, rất cao so với thực tế ngành điện tử. Lý do hủy, rating, hình thức giao và thanh toán phân bố gần như phẳng. Kết luận phù hợp để minh họa quy trình phân tích, không dùng để ra quyết định kinh doanh thật.
2. **Doanh thu và lợi nhuận gồm đơn bị hủy.** Doanh thu của riêng đơn hoàn thành là 39,19 triệu so với 58,71 triệu tổng; lợi nhuận tương ứng 30,89 triệu so với 46,23 triệu.
3. **Tháng cuối chưa đủ ngày** (đến 23/09/2024) và **tháng đầu ở giai đoạn khởi động** (190 đơn), nên MoM của hai tháng này không nên diễn giải như xu hướng.
4. **`Loyalty` là nhãn có sẵn**, chưa phải phân khúc tính từ hành vi.
5. **Tiền tố SKU gây hiểu nhầm** giữa Smartphone và Smartwatch (cùng `SMA-`).

## 12. Việc nên làm tiếp

- Tạo phân khúc RFM từ lịch sử mua để thay cho nhãn `Loyalty`.
- Thêm measure doanh thu thuần và lợi nhuận thuần (chỉ đơn hoàn thành) làm KPI chính.
- Tách đơn theo khách mới và khách quay lại để theo dõi sức khỏe tăng trưởng.
- Nếu có dữ liệu thật: kiểm định lại mức độ phẳng của lý do hủy và rating, và bổ sung trường kênh bán hàng, ngày giao hàng.
