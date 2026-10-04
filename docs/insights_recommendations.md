# Insights: & Recommendations:

Phân tích theo từng trang của dashboard. Mỗi phát hiện gồm số liệu đọc được từ dashboard hoặc tính từ cùng bộ dữ liệu và đề xuất.

## Số liệu nền

| Chỉ số | Giá trị |
|---|---|
| Số đơn hàng | 20.000 (hoàn thành 13.435, bị hủy 6.565) |
| Doanh thu / Chi phí / Lợi nhuận | 58,71 triệu / 12,48 triệu / 46,23 triệu |
| Biên lợi nhuận | 78,7% |
| Số sản phẩm bán ra | 110.365 (5,52 sản phẩm mỗi đơn) |
| Giá trị trung bình mỗi đơn (AOV) | 2.935 |
| Tỷ lệ hủy đơn | 32,8% |
| Rating trung bình (đơn hoàn thành) | 3,13 trên 5 |
| Số khách hàng | 12.136 (1,65 đơn mỗi khách) |

Doanh thu và lợi nhuận ở đây gồm cả đơn bị hủy. Riêng đơn hoàn thành: doanh thu 39,19 triệu, lợi nhuận 30,89 triệu.

---

## Trang 1: Overview

### 1.1 Tăng trưởng nhảy bậc rồi đi ngang

**Insights:**

- Quý 4/2023 chỉ có 797 đến 911 đơn mỗi tháng. Tháng 01/2024 vọt lên 2.049 đơn (số đơn +156,1%, doanh thu +153,3% so với tháng trước).
- Từ 02/2024 đến 08/2024, số đơn đi ngang trong khoảng 1.818 đến 2.049 đơn mỗi tháng, doanh thu 5,26 đến 6,14 triệu mỗi tháng.
- Biên lợi nhuận gần như không đổi, 78,5% đến 78,9% ở mọi tháng, nên lợi nhuận tăng giảm theo doanh thu.
- Mức giảm 26,2% số đơn và 28,4% doanh thu của tháng 09/2024 là do dữ liệu mới có đến ngày 23/09, không phải suy giảm thật.

**Recommendations:** đặt mục tiêu cụ thể để phá vỡ mức đi ngang (ví dụ doanh thu tháng) và theo dõi MoM theo kênh hoặc chiến dịch. Dữ liệu hiện chưa có trường kênh bán, nên cần bổ sung nếu muốn biết nguồn tăng trưởng.

### 1.2 Hủy đơn là điểm rò rỉ lớn nhất

**Insights:**

- 32,8% đơn bị hủy, tương ứng 19,52 triệu doanh thu (33,2% tổng doanh thu).
- Lý do hủy phân bố khá đều, mỗi lý do chiếm 16,2% đến 17,0% số đơn hủy.
- Ba lý do có thể xử lý bằng hệ thống gồm đơn trùng (16,8%), lỗi thanh toán (16,6%) và hết hàng (16,2%), cộng lại chiếm **49,6%** số đơn hủy.
- Tỷ lệ hủy gần như không đổi giữa các hình thức giao hàng (32,5% đến 33,7%) và dao động hẹp giữa các hình thức thanh toán (31,7% đến 34,3%), nên khó quy cho riêng một kênh.

**Recommendation:**

- Kiểm tra tồn kho theo thời gian thực trước khi chốt đơn; chặn đặt trùng (cùng khách, cùng sản phẩm trong thời gian ngắn); rà soát các bước dễ lỗi trong luồng thanh toán.
- Lý do "Found better price" (17,0%) nên được xem lại cùng chính sách giá và đối sánh đối thủ.
- Theo dõi `Cancellation Rate` theo từng lý do để biết biện pháp nào thật sự giảm được tỷ lệ hủy.

### 1.3 Trải nghiệm ở mức trung bình

**Insights:**

- Rating trung bình 3,13 trên 5. Trong các đơn hoàn thành: 29,0% đánh giá 1 đến 2 sao, 32,3% đánh giá 3 sao, 38,6% đánh giá 4 đến 5 sao.
- Rating gần như bằng nhau ở mọi nhóm sản phẩm (3,11 đến 3,15), nên chưa thấy nhóm nào là điểm sáng hay điểm nghẽn.

**Recommendations:** thu thêm lý do chấm điểm thấp (hiện dữ liệu chưa có) để biết cần cải thiện giao hàng, chất lượng sản phẩm hay chăm sóc sau bán.

### 1.4 Cơ cấu giao hàng và thanh toán

**Insights: (tỷ trọng doanh thu)**

- Giao hàng: Standard 49,8%, Express 25,2%, Economy 15,0%, Same-Day 10,1%.
- Thanh toán: thẻ tín dụng 34,8%, ví điện tử 25,6%, thẻ ghi nợ 20,0%, chuyển khoản 9,8%, thanh toán khi nhận hàng 9,7%.

**Recommendations:** thẻ tín dụng và ví điện tử cùng chiếm 60,4% doanh thu, nên ưu tiên độ ổn định của hai cổng thanh toán này.

---

## Trang 2: Product

### 2.1 Doanh thu phụ thuộc vào Laptop và Smartphone

**Insights:**

| Nhóm | Tỷ trọng doanh thu | Tỷ trọng lợi nhuận |
|---|---|---|
| Laptop | 40,4% | 37,8% |
| Smartphone | 37,4% | 38,7% |
| Tablet | 11,9% | 11,6% |
| Smartwatch | 7,5% | 8,7% |
| Headphones | 2,8% | 3,3% |

- Biểu đồ Pareto: 7 trên 16 SKU tạo ra 85,7% doanh thu.
- Hai SKU lớn nhất là SMA-0002 (18,7%) và LAP-0011 (16,9%); ba SKU đầu cộng lại đạt 49,0%.

**Recommendations:** bảo vệ tồn kho và giá của nhóm SKU dẫn đầu, đồng thời xây kế hoạch giảm rủi ro phụ thuộc, ví dụ đẩy mạnh Tablet và các SKU tầm trung (TAB-0005 đóng góp 7,9%).

### 2.2 Biên lợi nhuận cao nhất nằm ở nhóm doanh thu nhỏ

**Insights:** Headphones có biên 92,8% và Smartwatch 91,6%, so với Smartphone 81,4%, Tablet 76,2% và Laptop 73,7%. Hai nhóm biên cao nhất chỉ chiếm 10,3% doanh thu.

**Recommendations:** thử bán kèm Smartwatch hoặc Headphones với Laptop và Smartphone (gói combo, ưu đãi mua kèm) để nâng lợi nhuận mỗi đơn mà không cần thêm khách. Đo bằng `Basket Size` và `Profit Margin %` của nhóm thử nghiệm.

### 2.3 Smartphone dẫn đầu về số lượng, Laptop dẫn đầu về giá trị đơn

**Insights:** Smartphone bán nhiều nhất (33.502 sản phẩm, 6.027 đơn). Laptop có giá trị trung bình mỗi đơn cao nhất, 6.090 so với 3.647 của Smartphone (gấp khoảng 1,7 lần).

**Recommendations:** dùng Smartphone làm sản phẩm thu hút khách mới và Laptop làm mục tiêu nâng cấp cho khách đã mua. Đây là giả thuyết: dữ liệu hiện tại chưa cho biết khách Smartphone có chuyển sang mua Laptop hay không, cần theo dõi chuỗi mua của từng khách để kiểm chứng.

### 2.4 Tablet bị hủy nhiều nhất

**Insights:** Tablet có tỷ lệ hủy cao nhất (34,4%), Headphones thấp nhất (30,5%). Chênh lệch giữa các nhóm không lớn (khoảng 4 điểm phần trăm), nhưng Tablet cũng là nhóm mất nhiều doanh thu nhất vì hủy đơn (34,6% doanh thu của nhóm).

**Recommendations:** rà soát tồn kho, giá và mô tả sản phẩm của Tablet trước, vì đây là nhóm có tỷ lệ hủy cao nhất.

---

## Trang 3: Customer

### 3.1 Phần lớn khách chỉ mua một lần

**Insights:**

- 7.012 khách (57,8%) chỉ có một đơn; 3.162 khách có hai đơn, 1.325 khách có ba đơn, 637 khách có từ bốn đơn trở lên.
- Khách quay lại (5.124 khách, 42,2%) tạo ra 64,7% doanh thu. 20% khách chi tiêu nhiều nhất chiếm 48,7% doanh thu.

**Recommendations:** làm chương trình mua lại sau khoảng 30 đến 60 ngày (voucher, bảo hành mở rộng, phụ kiện đi kèm), ưu tiên nhóm khách đã mua hai lần để kéo lên lần thứ ba. Theo dõi bằng `Repeat Customer Rate` và `Frequency`.

### 3.2 Tỷ lệ quay lại thấp và không cải thiện theo thời gian

**Insights:** ở ma trận cohort, mỗi nhóm khách chỉ quay lại khoảng 8% đến 11% mỗi tháng sau tháng đầu tiên (trung bình 8,1% ở tháng thứ 1, 8,7% ở tháng thứ 2, rồi quanh 10%). Các cohort mới không tốt hơn cohort cũ.

**Recommendations:** thử nghiệm các tác động khác nhau ở tháng thứ 1 (nhắc mua lại, ưu đãi lần hai) và so sánh cohort có và không có tác động.

### 3.3 Số khách mới giảm mạnh, đơn hàng ngày càng dựa vào khách cũ

**Insights:**

- Số khách mới mỗi tháng giảm từ 1.670 (01/2024) xuống 775 (08/2024), tức giảm 54%.
- Trong lúc đó số đơn đi ngang quanh 2.000 mỗi tháng. Tỷ trọng đơn đến từ khách đã mua ở tháng trước đó tăng từ 14% (01/2024: 288 trên 2.049 đơn) lên 60% (08/2024: 1.209 trên 2.020 đơn).
- Nói cách khác, mức đi ngang của đơn hàng hiện được giữ bởi khách quay lại, trong khi nguồn khách mới đang thu hẹp.

**Recommendations:** (1) bảo vệ và nâng tỷ lệ quay lại vì đây đang là nguồn đơn lớn nhất; (2) tìm nguyên nhân khách mới giảm (ngân sách thu hút khách, kênh, mùa vụ). Chỉ số này tính ngoài dashboard từ cùng bộ dữ liệu; nên thêm một biểu đồ tách đơn và doanh thu theo khách mới và khách quay lại vào trang Customer.

### 3.4 Nhãn Loyalty chưa phân biệt được hành vi

**Insights:** nhóm Loyalty "Yes" chiếm 69,6% khách và 70,0% doanh thu. Tần suất mua của hai nhóm bằng nhau (1,65 đơn mỗi khách); doanh thu mỗi khách của nhóm "Yes" chỉ cao hơn khoảng 2% (4.867 so với 4.771).

**Recommendations:** xây lại phân khúc bằng RFM (Recency, Frequency, Monetary) thay vì dùng cờ có sẵn trong dữ liệu nguồn, rồi mới thiết kế ưu đãi theo phân khúc.

### 3.5 Nhân khẩu học và thời điểm mua

**Insights:**

- Tỷ trọng doanh thu theo nhóm tuổi: Adult 31,4%, Middle Age 25,3%, Young Adult 17,5%, Mature 15,8%, Senior 10,0%. Nữ chiếm 52,9% doanh thu, nam 47,1%.
- Doanh thu theo thứ trong tuần khá đều: thứ Tư cao nhất (8,83 triệu), thứ Năm thấp nhất (8,04 triệu), chênh khoảng 10%.

**Recommendations:** tập trung nội dung và ưu đãi vào hai nhóm tuổi lõi (Adult, Middle Age); thử A/B các khung khuyến mãi theo ngày để kiểm tra có tạo được khác biệt hay không, vì dữ liệu hiện chưa cho thấy ngày nào nổi bật.

---

## Thứ tự ưu tiên hành động

| Ưu tiên | Hành động | KPI theo dõi | Trang |
|---|---|---|---|
| 1 | Giảm hủy đơn do lý do kỹ thuật (tồn kho, đơn trùng, lỗi thanh toán) | Cancellation Rate | Overview |
| 2 | Chương trình mua lại cho khách đã mua một lần | Repeat Customer Rate, Cohort Retention % | Customer |
| 3 | Tìm nguyên nhân khách mới giảm và bổ sung biểu đồ khách mới so với khách cũ | Số khách mới mỗi tháng | Customer |
| 4 | Xây phân khúc RFM thay cho nhãn Loyalty | Doanh thu mỗi khách theo phân khúc | Customer |
| 5 | Thử bán kèm Smartwatch hoặc Headphones với Laptop và Smartphone | Basket Size, Profit Margin % | Product |
| 6 | Thu thập lý do chấm điểm thấp | Average Rating | Overview |

## Lưu ý khi đọc kết quả

1. **Doanh thu và lợi nhuận gồm cả đơn bị hủy.** Khi cần số thực thu, lọc `OrderStatus = Completed` bằng slicer hoặc thêm measure `Net Revenue`.
2. **Dữ liệu.** Biên lợi nhuận khoảng 78,7%, lý do hủy, rating và retention gần như phẳng là dấu hiệu của dữ liệu sinh ngẫu nhiên có kiểm soát. Các kết luận phù hợp để minh họa quy trình phân tích, không phải để ra quyết định kinh doanh thật.
3. **Tháng 09/2024 chưa đủ ngày** (đến 23/09), nên so sánh MoM của tháng này bị lệch xuống.