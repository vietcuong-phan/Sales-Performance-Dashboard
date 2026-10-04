# KPI Definitions

Định nghĩa từng chỉ số (KPI) trên dashboard **Sales Performance Dashboard**: ý nghĩa nghiệp vụ, công thức, measure tương ứng, cách đọc và giá trị toàn kỳ để đối chiếu. Mã DAX đầy đủ nằm trong [`dax_measures/`](../dax_measures/), danh mục 55 measure trong [`measures_catalog.md`](../dax_measures/measures_catalog.md).

**Quy ước:** giá trị toàn kỳ tính khi không áp dụng slicer nào (01/09/2023 đến 23/09/2024). Đơn vị tiền tệ theo dữ liệu nguồn, không ghi ký hiệu.

---

## 1. Nhóm hiệu quả kinh doanh (trang Overview)

| KPI | Định nghĩa nghiệp vụ | Công thức | Measure | Giá trị toàn kỳ |
|---|---|---|---|---|
| Total Orders | Số đơn hàng, mỗi `OrderID` là một đơn | Đếm `OrderID` duy nhất | `Total Orders` | 20.000 |
| Total Revenue | Tổng doanh thu, gồm cả đơn bị hủy | Tổng `Revenue` | `Total Revenue` | 58.708.772,25 |
| Total Cost | Tổng giá vốn của các đơn | Tổng `Cost` | `Total Cost` | 12.480.915,55 |
| Total Profit | Tổng lợi nhuận gộp, gồm cả đơn bị hủy | Tổng `Profit` (bằng Revenue trừ Cost) | `Total Profit` | 46.227.856,70 |
| Profit Margin % | Lợi nhuận trên mỗi đơn vị doanh thu | Total Profit / Total Revenue | `Profit Margin %` | 78,74% |
| Profit YTD | Lợi nhuận lũy kế từ đầu năm dương lịch, đặt lại về 0 mỗi năm | `TOTALYTD` của Total Profit theo ngày | `Profit YTD` | Tăng dần theo tháng trong từng năm |
| Cancellation Rate | Tỷ lệ đơn bị hủy trên tổng số đơn | Cancelled Orders / Total Orders | `Cancellation Rate` | 32,83% (6.565 đơn) |
| Completed Rate | Tỷ lệ đơn hoàn thành trên tổng số đơn | Completed Orders / Total Orders | `Completed Rate` | 67,18% (13.435 đơn) |
| Average Rating | Điểm đánh giá trung bình của khách, thang 1 đến 5; chỉ đơn hoàn thành có rating | Trung bình `Rating` của đơn Completed | `Average Rating` | 3,13 |

**Lưu ý**

- Doanh thu và lợi nhuận chưa trừ đơn bị hủy. Với đơn hoàn thành: doanh thu 39.192.978,85 và lợi nhuận 30.887.265,40. Muốn xem số thực thu, lọc `OrderStatus = Completed` bằng slicer.
- Biên lợi nhuận là biên gộp (chưa gồm chi phí vận hành, marketing, giao hàng), và ở mức 78,74% rất cao so với thực tế, do dữ liệu mô phỏng.

---

## 2. Nhóm sản phẩm (trang Product)

| KPI | Định nghĩa nghiệp vụ | Công thức | Measure | Giá trị toàn kỳ |
|---|---|---|---|---|
| Total Units Sold | Tổng số sản phẩm bán ra | Tổng `Quantity` | `Total Units Sold` | 110.365 |
| Basket Size | Số sản phẩm trung bình trong một đơn | Total Units Sold / Total Orders | `Basket Size` | 5,52 |
| Avg Revenue per Unit | Doanh thu trung bình trên một sản phẩm | Total Revenue / Total Units Sold | `Avg Revenue per Unit` | 531,95 |
| Avg Order Value (AOV) | Giá trị trung bình của một đơn | Total Revenue / Total Orders | `Avg Order Value` | 2.935,44 |
| SKU Revenue Rank | Thứ hạng của SKU theo doanh thu (hạng 1 là cao nhất) | `RANKX` trên toàn bộ SKU | `SKU Revenue Rank` | Dùng cho Pareto |
| Cumulative Revenue % (Pareto) | Phần trăm doanh thu lũy kế khi cộng dồn các SKU từ cao đến thấp | Doanh thu của các SKU có hạng nhỏ hơn hoặc bằng hạng hiện tại / tổng doanh thu | `Cumulative Revenue % (Pareto)` | 7 SKU đầu đạt 85,7% |
| Profit Distribution % | Tỷ trọng lợi nhuận của một tháng trên lợi nhuận toàn kỳ | Total Profit / Total Profit (bỏ lọc ngày) | `Profit Distribution %` | Tổng các tháng bằng 100% |

**Lưu ý**

- `Avg Revenue per Unit` và `Avg Order Value` là hai khái niệm khác nhau: một tính trên sản phẩm, một tính trên đơn. `AOV = Basket Size × Avg Revenue per Unit`.
- Đường Pareto đọc từ trái sang phải: SKU nào còn nằm trong phần đạt khoảng 80% đầu tiên là nhóm tạo phần lớn doanh thu.

---

## 3. Nhóm khách hàng (trang Customer)

| KPI | Định nghĩa nghiệp vụ | Công thức | Measure | Giá trị toàn kỳ |
|---|---|---|---|---|
| Total Customers | Số khách hàng duy nhất có đơn trong ngữ cảnh lọc | Đếm `CustomerID` duy nhất | `Total Customers` | 12.136 |
| Revenue per Customer | Doanh thu trung bình mỗi khách | Total Revenue / Total Customers | `Revenue per Customer` | 4.837,57 |
| Frequency | Số đơn trung bình mỗi khách | Total Orders / Total Customers | `Frequency` | 1,65 |
| Repeat Customers | Số khách có hơn một đơn trong ngữ cảnh lọc | Đếm khách có Total Orders lớn hơn 1 | `Repeat Customers` | 5.124 |
| Repeat Customer Rate | Tỷ lệ khách quay lại | Repeat Customers / Total Customers | `Repeat Customer Rate` | 42,22% |
| Active Customer Rate | Tỷ lệ khách có đơn trong kỳ trên toàn bộ khách trong bảng khách hàng | Total Customers / số khách trong `dim_customer` | `Active Customer Rate` | 100% |
| Cohort Retention % | Với nhóm khách có cùng tháng mua đầu tiên (cohort), phần trăm khách có đơn ở tháng thứ N sau đó | Khách của cohort có đơn ở tháng (cohort + N) / quy mô cohort | `Cohort Retention %` | Khoảng 8% đến 11% mỗi tháng |

**Lưu ý**

- `Repeat Customers` và `Repeat Customer Rate` phụ thuộc ngữ cảnh lọc: khi chọn một tháng, khách chỉ được tính là "quay lại" nếu có từ hai đơn trong tháng đó.
- `Active Customer Rate` luôn bằng 100% khi xem toàn kỳ vì mọi khách trong bảng khách hàng đều có ít nhất một đơn; chỉ có ý nghĩa khi lọc theo tháng hoặc nhóm khách.
- `Cohort Retention %`: hàng là tháng mua đầu tiên (`FirstOrderMonth`), cột là số tháng kể từ đó (`Month Index`, từ 0 đến 12). Cột 0 luôn là 100%. Một khách được tính là quay lại nếu có bất kỳ đơn nào, kể cả đơn sau đó bị hủy. Các ô vượt quá ngày dữ liệu cuối (23/09/2024) được để trống, không phải 0%.
- Thuộc tính `OrderCount` và `ProductCount` (dùng cho hai biểu đồ phân bố) được tính cố định lúc refresh, không đổi theo slicer.

---

## 4. So sánh với tháng trước (MoM)

Mỗi thẻ KPI có một measure `... MoM %` trả về chữ gồm mũi tên và phần trăm thay đổi, ví dụ "mũi tên lên 12,5%".

| Thành phần | Định nghĩa |
|---|---|
| Kỳ so sánh (`PM`) | Giá trị của cùng chỉ số ở tháng liền trước, tính bằng `DATEADD(dim_date[Date], -1, MONTH)` |
| Công thức | (Giá trị tháng này − Giá trị tháng trước) / Giá trị tháng trước |
| Mũi tên | Mũi tên lên khi tăng, mũi tên xuống khi giảm (`UNICHAR` 11165 và 11167); không có mũi tên khi bằng 0 |
| Màu | Measure `CF Revenue MoM %`: xanh khi tăng, đỏ khi giảm. Với tỷ lệ hủy, màu đảo ngược (giảm là tốt) |

| Measure MoM | Chỉ số gốc | Trang |
|---|---|---|
| `Orders MoM %` | Total Orders | Overview, Product |
| `Revenue MoM %` | Total Revenue | Overview |
| `Profit MoM %` | Total Profit | Overview |
| `Cancellation Rate MoM %` | Cancellation Rate | Overview |
| `Average Rating MoM %` | Average Rating | Overview |
| `Units Sold MoM %`, `Basket Size MoM %`, `Avg Revenue per Unit MoM %` | Tương ứng | Product |
| `Customers MoM %`, `Revenue per Customer MoM %`, `Frequency MoM %`, `Repeat Customer MoM %`, `Active Customer Rate MoM %` | Tương ứng | Customer |

**Lưu ý**

- MoM chỉ có ý nghĩa khi ngữ cảnh lọc là một tháng. Với khoảng nhiều tháng, giá trị so sánh là cùng khoảng đó lùi một tháng.
- Với các chỉ số dạng tỷ lệ (`Cancellation Rate`, `Active Customer Rate`), MoM là thay đổi tương đối, không phải thay đổi theo điểm phần trăm.
- Tháng 09/2024 mới có dữ liệu đến ngày 23, nên MoM của tháng này bị lệch xuống.
- Một số lỗi nhỏ của nhóm measure MoM và màu được ghi trong mục Known issues của `measures_catalog.md` (ví dụ `CF Cancellation Rate MoM %` đang tính trên doanh thu thay vì tỷ lệ hủy).

---

## 5. Chỉ số nên bổ sung

| Chỉ số | Lý do | Gợi ý định nghĩa |
|---|---|---|
| Net Revenue, Net Profit | Doanh thu và lợi nhuận hiện gồm đơn bị hủy | Total Revenue và Total Profit lọc `OrderStatus = Completed` |
| New Customers, Returning Customers | Cho thấy đơn hàng đến từ khách mới hay khách quay lại | Khách có tháng mua đầu tiên bằng tháng đang xem (mới) và các khách còn lại (quay lại) |
| RFM Segment | Nhãn `Loyalty` hiện có không phân biệt được hành vi mua | Điểm Recency, Frequency, Monetary theo phân vị, gộp thành phân khúc |