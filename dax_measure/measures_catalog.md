# Measures Catalog

Danh mục 55 DAX measure của dashboard **Sales Performance Dashboard**, đều nằm trong bảng `_Measures`. Mã nguồn đầy đủ nằm trong thư mục [`dax_measures/`](./).

## Quy ước đặt tên

| Hậu tố / tiền tố | Ý nghĩa |
|---|---|
| `PM` | Previous Month: giá trị của tháng liền trước, tính bằng `DATEADD(dim_date[Date], -1, MONTH)` |
| `MoM %` | Month-over-Month: kết quả dạng text gồm mũi tên và phần trăm thay đổi, dùng cho thẻ KPI. Mũi tên lên/xuống lấy từ `UNICHAR(11165)` và `UNICHAR(11167)` |
| `CF` | Conditional Formatting: trả về tên màu (`green`, `red`, `navy`, `grey`) để tô màu thẻ KPI |
| `(Pareto)` | Nhóm measure phục vụ biểu đồ Pareto theo SKU |

Mẫu chung của measure `MoM %`:

```dax
VAR _CM     = [Measure]
VAR _PM     = CALCULATE([Measure], DATEADD(dim_date[Date], -1, MONTH))
VAR _perc   = DIVIDE(_CM - _PM, _PM)
VAR _format = SWITCH(
    TRUE(),
    _perc > 0, UNICHAR(11165) & " " & FORMAT(_perc, "0.0%"),
    _perc < 0, UNICHAR(11167) & " " & FORMAT(_perc * -1, "0.0%"),
    FORMAT(_perc, "0.0%")
)
RETURN _format
```

Điều kiện để `DATEADD` hoạt động đúng: `dim_date` phải liên tục (không thiếu ngày) và được Mark as date table trên cột `Date`. Nếu MoM trả về 0,0% ở mọi nơi, kiểm tra trước tiên khoảng ngày của `dim_date`.

## Danh mục theo nhóm

### 00 Base Measures (12)

File nguồn: `00_base_measures.dax`

| # | Measure | Ý nghĩa | Logic chính | Kiểu | Dùng ở trang |
|---|---|---|---|---|---|
| 1 | `Total Orders` | Số đơn hàng (mỗi OrderID là một đơn) | `DISTINCTCOUNT(OrderID)` | Số | Overview, Product |
| 2 | `Completed Orders` | Số đơn hoàn thành | `Total Orders lọc OrderStatus = "Completed"` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 3 | `Cancelled Orders` | Số đơn bị hủy | `Total Orders lọc OrderStatus = "Cancelled"` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 4 | `Completed Rate` | Tỷ lệ đơn hoàn thành | `Completed Orders / Total Orders` | % | Hỗ trợ (không đặt trực tiếp lên visual) |
| 5 | `Cancellation Rate` | Tỷ lệ hủy đơn | `Cancelled Orders / Total Orders` | % | Overview, Product |
| 6 | `Total Revenue` | Tổng doanh thu (gồm cả đơn bị hủy) | `SUM(Revenue)` | Số | Overview, Product |
| 7 | `Total Cost` | Tổng chi phí | `SUM(Cost)` | Số | Overview, Product |
| 8 | `Total Profit` | Tổng lợi nhuận (gồm cả đơn bị hủy) | `SUM(Profit)` | Số | Customer, Overview, Product |
| 9 | `Profit Margin %` | Biên lợi nhuận | `Total Profit / Total Revenue` | % | Product |
| 10 | `Total Units Sold` | Tổng số sản phẩm bán ra | `SUM(Quantity)` | Số | Customer, Overview, Product |
| 11 | `Average Rating` | Điểm đánh giá trung bình (chỉ đơn Completed có rating) | `AVERAGE(Rating) lọc Completed` | Số | Overview, Product |
| 12 | `Total Customers` | Số khách hàng duy nhất | `DISTINCTCOUNT(CustomerID)` | Số | Customer, Overview |

### 01 Overview (11)

File nguồn: `01_overview_mom.dax`

| # | Measure | Ý nghĩa | Logic chính | Kiểu | Dùng ở trang |
|---|---|---|---|---|---|
| 1 | `Total Orders PM` | Số đơn tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 2 | `Orders MoM %` | Thay đổi số đơn so với tháng trước, kèm mũi tên | `(CM - PM) / PM` | Text | Overview, Product |
| 3 | `Total Revenue PM` | Doanh thu tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 4 | `Revenue MoM %` | Thay đổi doanh thu so với tháng trước, kèm mũi tên | `(CM - PM) / PM` | Text | Overview |
| 5 | `Total Profit PM` | Lợi nhuận tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 6 | `Profit MoM %` | Thay đổi lợi nhuận so với tháng trước, kèm mũi tên | `(CM - PM) / PM` | Text | Overview |
| 7 | `Cancellation Rate PM` | Tỷ lệ hủy tháng trước | `DATEADD(-1 MONTH)` | % | Hỗ trợ (không đặt trực tiếp lên visual) |
| 8 | `Cancellation Rate MoM %` | Thay đổi tỷ lệ hủy so với tháng trước (tương đối) | `(CM - PM) / PM` | Text | Overview |
| 9 | `Average Rating PM` | Rating trung bình tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 10 | `Average Rating MoM %` | Thay đổi rating so với tháng trước (không có mũi tên) | `(CM - PM) / PM` | Text | Overview |
| 11 | `Profit YTD` | Lợi nhuận lũy kế từ đầu năm, reset mỗi năm | `TOTALYTD(Total Profit, Date)` | Số | Overview, Product |

### Conditional formatting, không có display folder (2)

File nguồn: `01_overview_mom.dax`

| # | Measure | Ý nghĩa | Logic chính | Kiểu | Dùng ở trang |
|---|---|---|---|---|---|
| 1 | `CF Revenue MoM %` | Màu cho KPI: xanh khi doanh thu tăng, đỏ khi giảm | `SWITCH theo (CM - PM) / PM của Revenue` | Màu | Customer, Overview, Product |
| 2 | `CF Cancellation Rate MoM %` | Màu cho KPI hủy đơn: xanh khi giảm, đỏ khi tăng (xem Known issue #1) | `SWITCH theo (CM - PM) / PM` | Màu | Overview, Product |

### 02 Product Performance (14)

File nguồn: `02_product_pareto.dax`

| # | Measure | Ý nghĩa | Logic chính | Kiểu | Dùng ở trang |
|---|---|---|---|---|---|
| 1 | `Basket Size` | Số sản phẩm trung bình mỗi đơn | `Total Units Sold / Total Orders` | Số | Product |
| 2 | `Avg Revenue per Unit` | Doanh thu trung bình mỗi sản phẩm | `Total Revenue / Total Units Sold` | Số | Product |
| 3 | `Avg Order Value` | Giá trị trung bình mỗi đơn (AOV) | `Total Revenue / Total Orders` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 4 | `SKU Revenue Rank` | Xếp hạng SKU theo doanh thu (Dense) | `RANKX(ALL(SKU), Total Revenue)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 5 | `Cumulative Revenue (Pareto)` | Doanh thu lũy kế đến hạng SKU hiện tại | `CALCULATE(Total Revenue, SKU có rank <= hạng hiện tại)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 6 | `Cumulative Revenue % (Pareto)` | % doanh thu lũy kế, dùng cho đường Pareto | `Cumulative / tổng doanh thu mọi SKU` | % | Product |
| 7 | `Profit Distribution %` | Tỷ trọng lợi nhuận của từng tháng trên toàn kỳ | `Total Profit / Total Profit(ALL dim_date)` | % | Overview |
| 8 | `Profit Distribution % (Product)` | Tỷ trọng lợi nhuận của từng nhóm sản phẩm | `Total Profit / Total Profit(ALL dim_product)` | % | Hỗ trợ (không đặt trực tiếp lên visual) |
| 9 | `Units Sold PM` | Số sản phẩm bán ra tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 10 | `Units Sold MoM %` | Thay đổi số sản phẩm bán ra so với tháng trước | `(CM - PM) / PM` | Text | Product |
| 11 | `Avg Revenue per Unit PM` | Doanh thu/sản phẩm tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 12 | `Avg Revenue per Unit MoM %` | Thay đổi doanh thu/sản phẩm so với tháng trước | `(CM - PM) / PM` | Text | Product |
| 13 | `Basket Size PM` | Basket size tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 14 | `Basket Size MoM %` | Thay đổi basket size so với tháng trước | `(CM - PM) / PM` | Text | Product |

### 03 Customer (16)

File nguồn: `03_customer_cohort.dax`

| # | Measure | Ý nghĩa | Logic chính | Kiểu | Dùng ở trang |
|---|---|---|---|---|---|
| 1 | `Revenue per Customer` | Doanh thu trung bình mỗi khách | `Total Revenue / Total Customers` | Số | Customer |
| 2 | `Frequency` | Tần suất mua: số đơn trung bình mỗi khách | `Total Orders / Total Customers` | Số | Customer |
| 3 | `Repeat Customers` | Số khách có hơn 1 đơn trong ngữ cảnh lọc | `COUNTROWS(FILTER(VALUES(CustomerID), Total Orders > 1))` | Số | Customer |
| 4 | `Repeat Customer Rate` | Tỷ lệ khách quay lại | `Repeat Customers / Total Customers` | % | Hỗ trợ (không đặt trực tiếp lên visual) |
| 5 | `Active Customer Rate` | Tỷ lệ khách có đơn trong kỳ trên toàn bộ khách trong dim_customer | `Total Customers / DISTINCTCOUNT(dim_customer[CustomerID])` | % | Customer |
| 6 | `Customers PM` | Số khách tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 7 | `Customers MoM %` | Thay đổi số khách so với tháng trước | `(CM - PM) / PM` | Text | Customer |
| 8 | `Revenue per Customer PM` | Doanh thu/khách tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 9 | `Revenue per Customer MoM %` | Thay đổi doanh thu/khách so với tháng trước | `(CM - PM) / PM` | Text | Customer |
| 10 | `Frequency PM` | Tần suất mua tháng trước | `DATEADD(-1 MONTH)` | Số | Hỗ trợ (không đặt trực tiếp lên visual) |
| 11 | `Frequency MoM %` | Thay đổi tần suất mua so với tháng trước | `(CM - PM) / PM` | Text | Customer |
| 12 | `Repeat Customer Rate PM` | Tỷ lệ khách quay lại tháng trước (chưa dùng ở measure nào) | `DATEADD(-1 MONTH)` | % | Hỗ trợ (không đặt trực tiếp lên visual) |
| 13 | `Repeat Customer MoM %` | Thay đổi số khách quay lại so với tháng trước | `(CM - PM) / PM trên Repeat Customers` | Text | Customer |
| 14 | `Active Customer Rate PM` | Active rate tháng trước | `DATEADD(-1 MONTH)` | % | Hỗ trợ (không đặt trực tiếp lên visual) |
| 15 | `Active Customer Rate MoM %` | Thay đổi active rate so với tháng trước (tương đối) | `(CM - PM) / PM` | Text | Customer |
| 16 | `Cohort Retention %` | % khách của cohort (tháng mua đầu tiên) quay lại mua ở tháng thứ N | `Khách active ở tháng (cohort + N) / quy mô cohort` | % | Customer |