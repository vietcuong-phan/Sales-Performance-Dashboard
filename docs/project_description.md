# Sales Performance Dashboard: Mô tả dự án

Dashboard Power BI 3 trang (Overview, Product, Customer) phân tích hiệu quả bán hàng của một doanh nghiệp kinh doanh thiết bị điện tử, từ dữ liệu giao dịch 20.000 đơn hàng.

| Hạng mục | Nội dung |
|---|---|
| Công cụ | Power BI Desktop (Power Query, DAX) |
| Dữ liệu | 20.000 đơn hàng, 12.136 khách hàng, 16 SKU, 09/2023 đến 09/2024 (dữ liệu mô phỏng) |
| Sản phẩm bàn giao | File `.pbix`, 55 DAX measure, mô hình star schema, tài liệu kỹ thuật |
| Tài liệu liên quan | [Insights & Recommendations](./insights_recommendations.md), [KPI definitions](./kpi_definitions.md), [Data dictionary](../data/data_dictionary.md), [Model notes](../data_model/model_notes.md) |

## 1. Vấn đề cần giải quyết

Ban lãnh đạo kinh doanh cần một góc nhìn thống nhất để trả lời bốn nhóm câu hỏi:

| Nhóm | Câu hỏi |
|---|---|
| Hiệu quả kinh doanh | Doanh thu, lợi nhuận, biên lợi nhuận biến động thế nào theo tháng và so với tháng trước? |
| Sản phẩm | Nhóm hàng và SKU nào đóng góp nhiều nhất? Doanh thu có phụ thuộc vào một vài sản phẩm không? |
| Khách hàng | Ai đang mua, mua bao nhiêu lần, có quay lại không? Nhóm "thân thiết" có thực sự giá trị hơn không? |
| Vận hành | Tỷ lệ hủy đơn là bao nhiêu, vì sao hủy, trải nghiệm của khách (rating) ra sao? |

Dữ liệu gốc chỉ là một bảng phẳng 20.000 dòng, khó nhìn ra xu hướng, khó so sánh giữa các kỳ và không cho phép lọc theo nhiều chiều cùng lúc. Dự án chuyển bảng thô đó thành dashboard tương tác để ra quyết định nhanh hơn.

## 2. Dữ liệu đầu vào

**Nguồn:** một file CSV giao dịch bán hàng `Sales_Raw_data.csv`, 21 cột, mỗi dòng là một đơn hàng gồm một sản phẩm.

| Chỉ tiêu | Giá trị |
|---|---|
| Số đơn hàng | 20.000 (đơn hoàn thành 13.435, đơn bị hủy 6.565) |
| Số khách hàng | 12.136 |
| Số sản phẩm | 16 SKU thuộc 5 nhóm: Laptop, Smartphone, Tablet, Smartwatch, Headphones |
| Khoảng thời gian | 01/09/2023 đến 23/09/2024 |
| Doanh thu / lợi nhuận | 58,7 triệu / 46,2 triệu (gồm cả đơn bị hủy) |

**Các nhóm trường dữ liệu:**

- Đơn hàng: `OrderID`, `OrderDate`, `Quantity`, `OrderStatus`, `CancellationReason`, `ShippingType`, `PaymentType`, `Rating`
- Tài chính: `UnitPrice`, `UnitCost`, `Revenue`, `Cost`, `Profit`
- Khách hàng: `CustomerID`, `Gender`, `AgeGroup`, `Loyalty`
- Sản phẩm: `ProductID`, `SKU`, `ProductType`, `ProductName`

**Chất lượng dữ liệu:** không có `OrderID` trùng; giá trị trống duy nhất là `Rating` của 6.565 đơn bị hủy (hợp lý vì đơn hủy không có đánh giá). Doanh thu, chi phí, lợi nhuận khớp công thức `Revenue = Quantity × UnitPrice`, `Cost = Quantity × UnitCost`, `Profit = Revenue − Cost` ở 100% số dòng. Chi tiết xem [data dictionary](../data/data_dictionary.md).

## 3. Cách giải quyết vấn đề

### Bước 1: Làm sạch và mô hình hóa (Power Query)

- Ép kiểu dữ liệu, chọn lọc cột cho từng bảng, loại trùng để tạo bảng chiều.
- Xây mô hình star schema: `fact_sales` ở trung tâm, nối với `dim_customer`, `dim_product`, `dim_date` bằng ba quan hệ nhiều-một, một chiều.
- Tạo bảng lịch `dim_date` (2022 đến 2025) bằng Power Query, các cột sắp xếp (`MonthYearSort`, `AgeGroupSort`, `FirstOrderMonthSort`), bảng `Month Index` cho cohort và bảng `Parameter` (field parameter) để người xem đổi chỉ số hiển thị.

Chi tiết: [M_scripts.md](../power_query/M_scripts.md) và [model_notes.md](../data_model/model_notes.md).

### Bước 2: Xây thước đo (DAX)

55 measure đặt trong bảng `_Measures`, chia theo thư mục:

| Nhóm | Số measure | Nội dung chính |
|---|---|---|
| 00 Base Measures | 12 | Số đơn, doanh thu, chi phí, lợi nhuận, biên lợi nhuận, số sản phẩm, rating, tỷ lệ hủy, số khách |
| 01 Overview | 11 (+2 measure màu) | Các cặp `PM` và `MoM %` cho từng KPI (dùng `DATEADD`), `Profit YTD` |
| 02 Product Performance | 14 | Basket Size, doanh thu mỗi sản phẩm, AOV, Pareto theo SKU (`RANKX` và doanh thu lũy kế %), tỷ trọng lợi nhuận |
| 03 Customer | 16 | Doanh thu mỗi khách, tần suất mua, khách quay lại, active rate, Cohort Retention % |

Chi tiết: [measures_catalog.md](../dax_measures/measures_catalog.md) và [KPI definitions](./kpi_definitions.md).

### Bước 3: Thiết kế dashboard 3 trang

| Trang | Câu hỏi trả lời | Thành phần chính |
|---|---|---|
| **Overview** | Kinh doanh đang thế nào? | Thẻ KPI (Orders, Revenue, Profit, Cancellation Rate, Rating) có so sánh MoM; biểu đồ kết hợp số đơn và tỷ lệ hủy; Cost, Profit và Profit YTD theo tháng; waterfall Units Sold theo ProductType; donut khách theo Loyalty; ma trận theo tháng |
| **Product** | Cái gì bán chạy, cái gì sinh lời? | KPI Units Sold, Basket Size, Avg Revenue per Unit; ma trận ProductType → SKU; biểu đồ Pareto theo SKU; Profit theo nhóm; đường Profit theo tháng (đổi chỉ số bằng field parameter) |
| **Customer** | Ai mua và có quay lại không? | KPI Customers, Frequency, Revenue per Customer, Repeat Customers, Active Rate; phân bố khách theo số đơn và số sản phẩm; scatter theo nhóm tuổi; ma trận nhóm tuổi theo thứ trong tuần; ma trận cohort retention |

### Bước 4: Trải nghiệm người dùng

Bộ slicer dùng chung giữa các trang (ngày, trạng thái đơn, nhóm sản phẩm, hình thức giao hàng, hình thức thanh toán), nút điều hướng giữa 3 trang và nút xóa toàn bộ bộ lọc.

## 4. Outcome

- **Dashboard tự phục vụ:** người xem tự lọc theo thời gian, trạng thái, nhóm hàng, hình thức giao và thanh toán mà không cần xuất lại báo cáo.
- **KPI có so sánh tháng trước:** các thẻ KPI hiển thị mũi tên và phần trăm thay đổi MoM kèm mã màu, đọc được trong vài giây.
- **Mô hình dữ liệu chuẩn, mở rộng được:** thêm bảng chiều hoặc measure mới mà không phải sửa lại nền.
- **Ba lớp phân tích liên kết:** Overview (tổng quan) → Product (bán gì) → Customer (ai mua, có quay lại không).
- **Bộ tài liệu đầy đủ:** data dictionary, script M, catalog 55 measure, ghi chú mô hình và bảng đối soát số liệu, giúp người khác hiểu và tái lập dashboard.

## 5. Insights & Recommendations (summary)

Phần phân tích đầy đủ theo từng trang nằm ở [insights_recommendations.md](./insights_recommendations.md). Năm phát hiện chính:

1. **Doanh thu tập trung:** Laptop và Smartphone chiếm 77,8% doanh thu; 7 trên 16 SKU tạo hơn 85% doanh thu.
2. **Tăng trưởng đi ngang:** sau bước nhảy ở tháng 01/2024, số đơn ổn định ở mức khoảng 1.800 đến 2.050 đơn mỗi tháng, trong khi số khách mới giảm hơn một nửa.
3. **Hủy đơn là điểm rò rỉ lớn nhất:** 32,8% đơn bị hủy, tương ứng 19,5 triệu doanh thu; gần một nửa số đơn hủy đến từ ba lý do xử lý được bằng hệ thống (lỗi thanh toán, đơn trùng, hết hàng).
4. **Giữ chân khách còn yếu:** 57,8% khách chỉ mua một lần; khách quay lại (42,2%) tạo ra 64,7% doanh thu.
5. **Nhãn Loyalty chưa phân biệt được hành vi:** khách "Yes" và "No" có tần suất mua bằng nhau (1,65 đơn mỗi khách).

## 6. Hạn chế và hướng phát triển

| Hạn chế | Hướng phát triển |
|---|---|
| Doanh thu và lợi nhuận đang tính cả đơn bị hủy (doanh thu của riêng đơn hoàn thành là 39,2 triệu) | Thêm measure `Net Revenue`, `Net Profit` lọc đơn hoàn thành và dùng làm KPI chính |
| Nhãn `Loyalty` là dữ liệu có sẵn, không phải kết quả tính từ hành vi | Xây phân khúc RFM (Recency, Frequency, Monetary) bằng DAX và thay thế nhãn hiện tại |
| Chưa có biểu đồ khách mới so với khách cũ | Thêm visual tách số đơn và doanh thu theo khách mới và khách quay lại |
| Dữ liệu mô phỏng: biên lợi nhuận khoảng 78,7% và nhiều phân bố gần như phẳng | Đọc kết quả như bài thực hành kỹ thuật phân tích; với dữ liệu thật cần kiểm định lại từng kết luận |
| Một số measure còn lỗi nhỏ (xem mục Known issues trong `measures_catalog.md`) | Sửa trong file `.pbix` và cập nhật lại các file `.dax` |
