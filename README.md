# Sales Performance Dashboard
<br>
Dashboard Power BI 3 trang Overview, Product, Customer phân tích hiệu quả bán hàng của một doanh nghiệp kinh doanh thiết bị điện tử: doanh thu và lợi nhuận, sản phẩm, hành vi khách hàng và tỷ lệ hủy đơn, từ 20.000 đơn hàng.

**Overview**

| Chỉ số | Giá trị |
|---|---|
| Số đơn hàng | 20.000 |
| Số khách hàng | 12.136 |
| Doanh thu / Lợi nhuận | 58,7 triệu / 46,2 triệu (biên 78,7%) |
| Tỷ lệ hủy đơn | 32,8% |
| Rating trung bình | 3,13 trên 5 |
| Khoảng thời gian | 09/2023 đến 09/2024 |


## Mục lục

1. [Vấn đề cần giải quyết](#1-vấn-đề-cần-giải-quyết)
2. [Dữ liệu đầu vào](#2-dữ-liệu-đầu-vào)
3. [Cách giải quyết vấn đề](#3-cách-giải-quyết-vấn-đề)
4. [Outcome](#4-outcome)
5. [Insights & Recommendations](#5-insights--recommendations)
6. [Cấu trúc repository](#6-cấu-trúc-repository)
7. [Hướng dẫn chạy lại](#7-hướng-dẫn-chạy-lại)
8. [Hạn chế và hướng phát triển](#8-hạn-chế-và-hướng-phát-triển)

---

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

**Nguồn:** File CSV giao dịch bán hàng [`Sales_Raw_data.csv`](data/raw/Sales_Raw_data.csv), 21 cột, mỗi dòng là một đơn hàng gồm một sản phẩm.

| Chỉ tiêu | Giá trị |
|---|---|
| Số đơn hàng | 20.000 (hoàn thành 13.435, bị hủy 6.565) |
| Số khách hàng | 12.136 |
| Số sản phẩm | 16 SKU thuộc 5 nhóm: Laptop, Smartphone, Tablet, Smartwatch, Headphones |
| Khoảng thời gian | 01/09/2023 đến 23/09/2024 |

**Các nhóm trường dữ liệu**

- Đơn hàng: `OrderID`, `OrderDate`, `Quantity`, `OrderStatus`, `CancellationReason`, `ShippingType`, `PaymentType`, `Rating`
- Tài chính: `UnitPrice`, `UnitCost`, `Revenue`, `Cost`, `Profit`
- Khách hàng: `CustomerID`, `Gender`, `AgeGroup`, `Loyalty`
- Sản phẩm: `ProductID`, `SKU`, `ProductType`, `ProductName`

**Chất lượng dữ liệu** (kiểm tra bằng Python trong [`eda/`](eda/)): không có dòng trùng, 20 trên 20 kiểm tra toàn vẹn đạt, giá trị trống duy nhất là `Rating` của các đơn bị hủy (hợp lý vì đơn hủy không có đánh giá). `Revenue`, `Cost`, `Profit` khớp công thức `Revenue = Quantity × UnitPrice`, `Cost = Quantity × UnitCost`, `Profit = Revenue − Cost` ở 100% số dòng.

Mô tả chi tiết từng cột: [`data/data_dictionary.md`](data/data_dictionary.md).

## 3. Cách giải quyết vấn đề

### Bước 1: Khám phá và kiểm tra dữ liệu (Python)

Notebook [`eda/01_data_profiling.ipynb`](eda/data_profiling.ipynb) kiểm tra giá trị trống, trùng lặp, định dạng mã, quy tắc nghiệp vụ, ngoại lai và đối soát số liệu với dashboard. Kết luận nằm trong [`eda/eda_findings.md`](eda/eda_findings.md).

### Bước 2: Làm sạch và mô hình hóa (Power Query)

- Ép kiểu dữ liệu, chọn lọc cột cho từng bảng, loại trùng để tạo bảng chiều.
- Xây mô hình star schema: `fact_sales` ở trung tâm, nối với `dim_customer`, `dim_product`, `dim_date` bằng ba quan hệ nhiều-một, một chiều.
- Tạo bảng lịch `dim_date` (2022 đến 2025), các cột sắp xếp (`MonthYearSort`, `AgeGroupSort`, `FirstOrderMonthSort`), bảng `Month Index` cho cohort và bảng `Parameter` (field parameter) để người xem đổi chỉ số hiển thị.

<img width="861" height="502" alt="star_schema" src="https://github.com/user-attachments/assets/5768284a-f253-41f9-ac99-c26d6efcd85c" />

Chi tiết: [`power_query/M_scripts.md`](power_query/M_scripts.md), [`power_query/dim_date.pq`](power_query/dim_date.pq), [`data_model/model_notes.md`](data_model/model_notes.md).

### Bước 3: Xây thước đo (DAX)

55 measure đặt trong bảng `_Measures`, chia theo thư mục:

| Nhóm | Số measure | Nội dung chính |
|---|---|---|
| 00 Base Measures | 12 | Số đơn, doanh thu, chi phí, lợi nhuận, biên lợi nhuận, số sản phẩm, rating, tỷ lệ hủy, số khách |
| 01 Overview | 13 | Các cặp `PM` và `MoM %` cho từng KPI (dùng `DATEADD`), `Profit YTD`, measure màu |
| 02 Product Performance | 14 | Basket Size, doanh thu mỗi sản phẩm, AOV, Pareto theo SKU (`RANKX`, doanh thu lũy kế %), tỷ trọng lợi nhuận |
| 03 Customer | 16 | Doanh thu mỗi khách, tần suất mua, khách quay lại, active rate, Cohort Retention % |

Mã nguồn: [`dax_measures/`](dax_measures/). Danh mục đầy đủ: [`measures_catalog.md`](dax_measures/measures_catalog.md). Định nghĩa KPI: [`docs/kpi_definitions.md`](docs/kpi_definitions.md).

### Bước 4: Thiết kế dashboard 3 trang

| Trang | Câu hỏi trả lời | Thành phần chính |
|---|---|---|
| **Overview** | Kinh doanh đang thế nào? | Thẻ KPI (Orders, Revenue, Profit, Cancellation Rate, Rating) có so sánh MoM; biểu đồ kết hợp số đơn và tỷ lệ hủy; Cost, Profit và Profit YTD theo tháng; waterfall Units Sold theo ProductType; donut khách theo Loyalty; ma trận theo tháng |
| **Product** | Cái gì bán chạy, cái gì sinh lời? | KPI Units Sold, Basket Size, Avg Revenue per Unit; ma trận ProductType -> SKU; biểu đồ Pareto theo SKU; Profit theo nhóm; đường Profit theo tháng (đổi chỉ số bằng field parameter) |
| **Customer** | Ai mua và có quay lại không? | KPI Customers, Frequency, Revenue per Customer, Repeat Customers, Active Rate; phân bố khách theo số đơn và số sản phẩm; scatter theo nhóm tuổi; ma trận nhóm tuổi theo thứ trong tuần; ma trận cohort retention |

### Bước 5: Trải nghiệm người dùng

Bộ slicer dùng chung giữa các trang (ngày, trạng thái đơn, nhóm sản phẩm, hình thức giao hàng, hình thức thanh toán), nút điều hướng giữa 3 trang và nút xóa toàn bộ bộ lọc.

## 4. Outcome

- **Dashboard tự phục vụ:** người xem tự lọc theo thời gian, trạng thái, nhóm hàng, hình thức giao và thanh toán mà không cần xuất lại báo cáo.
- **KPI có so sánh tháng trước:** các thẻ KPI hiển thị mũi tên và phần trăm thay đổi MoM kèm mã màu, đọc được trong vài giây.
- **Mô hình dữ liệu chuẩn, mở rộng được:** thêm bảng chiều hoặc measure mới mà không phải sửa lại nền.
- **Ba lớp phân tích liên kết:** Overview (tổng quan) -> Product (bán gì) -> Customer (ai mua, có quay lại không).
- **Bộ tài liệu đầy đủ:** data dictionary, script M, catalog 55 measure, ghi chú mô hình và bảng đối soát số liệu, giúp người khác hiểu và tái lập dashboard.

## 5. Insights & Recommendations

Tóm tắt theo từng trang. Phân tích đầy đủ, kèm bằng chứng và thứ tự ưu tiên hành động: [`docs/insights_recommendations.md`](docs/insights_recommendations.md).

### 5.1. Trang Overview

<img width="1162" height="658" alt="01_overview_page" src="https://github.com/user-attachments/assets/239afd79-e3d1-4198-a650-d2084523e522" />

| Insight | Recommendation |
|---|---|
| **Tăng trưởng nhảy bậc rồi đi ngang.** Quý 4/2023 chỉ 797 đến 911 đơn mỗi tháng; tháng 01/2024 vọt lên 2.049 đơn (+156,1%), sau đó đi ngang ở mức 1.818 đến 2.049 đơn mỗi tháng. Biên lợi nhuận ổn định 78,5% đến 78,9% | Đặt mục tiêu cụ thể để phá vỡ mức đi ngang; bổ sung dữ liệu kênh bán để biết nguồn tăng trưởng |
| **Hủy đơn là điểm rò rỉ lớn nhất.** 32,8% đơn bị hủy, bằng 19,5 triệu doanh thu. Ba lý do xử lý được bằng hệ thống (đơn trùng 16,8%, lỗi thanh toán 16,6%, hết hàng 16,2%) chiếm 49,6% số đơn hủy | Kiểm tra tồn kho trước khi chốt đơn, chặn đặt trùng, đơn giản hóa bước thanh toán; xem lại chính sách giá với lý do "Found better price" (17,0%) |
| **Trải nghiệm ở mức trung bình.** Rating 3,13 trên 5; 29,0% đánh giá 1 đến 2 sao; rating gần như bằng nhau ở mọi nhóm sản phẩm | Thêm lý do chấm điểm thấp để biết cần cải thiện giao hàng, sản phẩm hay chăm sóc sau bán |
| **Thẻ tín dụng và ví điện tử chiếm 60,4% doanh thu** | Ưu tiên độ ổn định của hai cổng thanh toán này |

### 5.2. Trang Product

<img width="1162" height="663" alt="02_product_page" src="https://github.com/user-attachments/assets/9fe93269-92d1-4ea4-bb2a-61a29b3428a1" />

| Insight | Recommendation |
|---|---|
| **Doanh thu phụ thuộc vào Laptop và Smartphone:** 77,8% doanh thu. 7 trên 16 SKU tạo 85,7% doanh thu; SMA-0002 (18,7%) và LAP-0011 (16,9%) lớn nhất | Bảo vệ tồn kho và giá của nhóm SKU dẫn đầu; đẩy mạnh Tablet và SKU tầm trung để giảm rủi ro phụ thuộc |
| **Biên lợi nhuận cao nhất nằm ở nhóm doanh thu nhỏ:** Headphones 92,8% và Smartwatch 91,6% so với Laptop 73,7%, nhưng chỉ chiếm 10,3% doanh thu | Thử bán kèm Smartwatch hoặc Headphones với Laptop và Smartphone; đo bằng Basket Size và Profit Margin % |
| **Smartphone dẫn đầu về số lượng, Laptop dẫn đầu về giá trị đơn** (6.090 so với 3.647, gấp khoảng 1,7 lần) | Dùng Smartphone để thu hút khách mới, Laptop làm mục tiêu nâng cấp (giả thuyết cần kiểm chứng) |
| **Tablet bị hủy nhiều nhất:** 34,4% so với 30,5% của Headphones | Rà soát tồn kho, giá và mô tả sản phẩm của Tablet trước |

### 5.3. Trang Customer

<img width="1165" height="661" alt="03_customer_page" src="https://github.com/user-attachments/assets/d1cda4cb-169f-4e14-8937-47f7069df121" />

| Insight | Recommendation |
|---|---|
| **Phần lớn khách chỉ mua một lần:** 57,8% khách có đúng 1 đơn; khách quay lại (42,2%) tạo ra 64,7% doanh thu | Chương trình mua lại sau 30 đến 60 ngày (voucher, bảo hành mở rộng, phụ kiện); ưu tiên kéo khách từ lần mua thứ hai lên thứ ba |
| **Tỷ lệ quay lại thấp và không cải thiện:** mỗi cohort chỉ quay lại khoảng 8% đến 11% mỗi tháng | Thử nghiệm các tác động ở tháng thứ nhất (nhắc mua lại, ưu đãi lần hai) và so sánh với nhóm đối chứng |
| **Khách mới giảm 54%** (1.670 ở 01/2024 xuống 775 ở 08/2024) trong khi số đơn đi ngang; tỷ trọng đơn từ khách đã mua trước đó tăng từ 14% lên 60% | Bảo vệ tỷ lệ quay lại vì đây là nguồn đơn lớn nhất; tìm nguyên nhân khách mới giảm; thêm biểu đồ khách mới so với khách quay lại |
| **Nhóm tuổi lõi** là Adult (31,4% doanh thu) và Middle Age (25,3%); doanh thu theo thứ trong tuần khá đều (chênh khoảng 10%) | Tập trung nội dung và ưu đãi vào hai nhóm tuổi lõi; thử A/B khung khuyến mãi theo ngày |

## 6. Cấu trúc repository

```
sales-performance-dashboard/
├── README.md
├── .gitignore
├── data/
│   ├── raw/Sales_Raw_data.csv
│   └── data_dictionary.md
├── eda/
│   ├── 01_data_profiling.ipynb
│   └── eda_findings.md
├── power_query/
│   ├── M_scripts.md
│   └── dim_date.pq
├── data_model/
│   └── model_notes.md
├── dax_measures/
│   ├── 00_base_measures.dax
│   ├── 01_overview_mom.dax
│   ├── 02_product_pareto.dax
│   ├── 03_customer_cohort.dax
│   └── measures_catalog.md
├── report/
│   └── Sales_Performance_Dashboard.pbix
├── docs/
│   ├── project_description.md
│   ├── insights_recommendations.md
│   └── kpi_definitions.md
└── screenshots/
    ├── 01_overview.png
    ├── 02_product.png
    └── 03_customer.png
```

## 7. Hướng dẫn chạy

**Yêu cầu:** Power BI Desktop (Windows). Để chạy notebook: Python 3 với `pandas`, `numpy`, `matplotlib`, `jupyter`.

1. Tải repo về máy: `gh repo clone vietcuong-phan/Sales-Performance-Dashboard`.
2. Mở `dashboard/Sales_Performance_Dashboard.pbix` bằng Power BI Desktop.
3. Vào **Home -> Transform data -> Edit parameters**, đặt tham số `FilePath` trỏ tới file `data/raw/Sales_Raw_data.csv` trên máy bạn, rồi chọn **Close & Apply**.
4. Đối soát số liệu theo bảng ở mục 8 của [`data_model/model_notes.md`](data_model/model_notes.md) (ví dụ tổng doanh thu 58.708.772,25 và 20.000 đơn).
5. Chạy lại phần kiểm tra dữ liệu: mở `eda/01_data_profiling.ipynb` từ thư mục `eda/` và chọn **Restart & Run All**.

## 8. Hạn chế và hướng phát triển

| Hạn chế | Hướng phát triển |
|---|---|
| Doanh thu và lợi nhuận đang tính cả đơn bị hủy | Thêm measure `Net Revenue`, `Net Profit` chỉ tính đơn hoàn thành |
| Nhãn `Loyalty` là dữ liệu có sẵn, không phải kết quả tính từ hành vi | Xây phân khúc RFM bằng DAX |
| Chưa có biểu đồ khách mới so với khách quay lại | Thêm visual tách số đơn và doanh thu theo hai nhóm khách |
| Dữ liệu mô phỏng: biên lợi nhuận khoảng 78,7%, nhiều phân bố gần như phẳng | Đọc kết quả như bài thực hành kỹ thuật; với dữ liệu thật cần kiểm định lại từng kết luận |
| Một số measure còn lỗi nhỏ (xem mục Known issues trong [`measures_catalog.md`](dax_measures/measures_catalog.md)) | Sửa trong file `.pbix` và cập nhật lại các file `.dax` |

---
