# Power Query (M) scripts

Tài liệu này ghi lại toàn bộ phần xử lý dữ liệu của dashboard **Sales Performance Dashboard**: bốn truy vấn Power Query (M), ba bảng/cột tạo bằng DAX và các thiết lập đi kèm sau khi nạp dữ liệu.

## 1. Tổng quan

Nguồn dữ liệu là một file CSV duy nhất (`data/raw/Sales_Performance_Raw_data.csv`, 20.000 dòng, 21 cột). Dữ liệu đã sạch (không trùng `OrderID`, không thiếu giá trị ngoài các trường hợp hợp lý, xem `data/data_dictionary.md`) nên phần M chỉ làm ba việc: ép kiểu, tách bảng fact/dim và tạo bảng lịch.

| Truy vấn | Vai trò | Số dòng | Số cột | Ghi chú |
|---|---|---|---|---|
| `fact_sales` | Bảng sự kiện | 20.000 | 13 | 1 dòng = 1 đơn hàng, sắp xếp theo `OrderDate` |
| `dim_customer` | Bảng chiều khách hàng | 12.136 | 5 từ M, thêm 5 cột DAX | Loại trùng theo `CustomerID` |
| `dim_product` | Bảng chiều sản phẩm | 16 | 6 | Loại trùng theo `ProductID` |
| `dim_date` | Bảng lịch | 1.461 | 14 | 01/01/2022 đến 31/12/2025, tạo hoàn toàn bằng M |

## 2. Thiết lập trước khi chạy: tham số `FilePath`

Trong file `.pbix` hiện tại, đường dẫn CSV đang là đường dẫn cứng trên máy tác giả. Để người khác tải repo về vẫn refresh được dữ liệu, các script dưới đây dùng một tham số tên `FilePath`.

Tạo tham số: **Home -> Transform data -> Manage Parameters -> New Parameter**, đặt tên `FilePath`, kiểu `Text`, giá trị là đường dẫn tuyệt đối tới file CSV trên máy bạn, ví dụ:

```
C:\path\to\sales-performance-dashboard\data\raw\Sales_Performance_Raw_data.csv
```

Sau khi đổi máy, chỉ cần vào **Transform data -> Edit parameters** để trỏ lại đường dẫn, không phải sửa từng truy vấn.

## 3. Các truy vấn

### 3.1 `fact_sales`

```m
let
    Source = Csv.Document(
        File.Contents(FilePath),
        [Delimiter = ",", Columns = 21, Encoding = 65001]
    ),
    #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {
        {"OrderID", type text}, {"OrderDate", type date}, {"CustomerID", type text},
        {"Gender", type text}, {"AgeGroup", type text}, {"Loyalty", type text},
        {"ProductID", type text}, {"SKU", type text}, {"ProductType", type text},
        {"ProductName", type text}, {"Quantity", Int64.Type}, {"UnitPrice", type number},
        {"UnitCost", type number}, {"Revenue", type number}, {"Cost", type number},
        {"Profit", type number}, {"OrderStatus", type text}, {"ShippingType", type text},
        {"PaymentType", type text}, {"Rating", Int64.Type}, {"CancellationReason", type text}
    }),
    #"Removed Other Columns" = Table.SelectColumns(#"Changed column type", {
        "OrderID", "OrderDate", "CustomerID", "ProductID", "Quantity",
        "Revenue", "Cost", "Profit", "OrderStatus", "ShippingType",
        "PaymentType", "Rating", "CancellationReason"
    }),
    #"Sorted Rows" = Table.Sort(#"Removed Other Columns", {{"OrderDate", Order.Ascending}})
in
    #"Sorted Rows"
```

| Bước | Mục đích |
|---|---|
| `Promoted headers` | Dùng dòng đầu làm tên cột |
| `Changed column type` | Ép kiểu cho cả 21 cột (ngày, số nguyên, số thực, text) |
| `Removed Other Columns` | Giữ 13 cột thuộc về sự kiện bán hàng; thuộc tính khách và sản phẩm tách sang bảng chiều |
| `Sorted Rows` | Sắp xếp theo ngày đặt hàng |

### 3.2 `dim_customer`

```m
let
    Source = Csv.Document(
        File.Contents(FilePath),
        [Delimiter = ",", Columns = 21, Encoding = 65001]
    ),
    #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {
        {"OrderID", type text}, {"OrderDate", type date}, {"CustomerID", type text},
        {"Gender", type text}, {"AgeGroup", type text}, {"Loyalty", type text},
        {"ProductID", type text}, {"SKU", type text}, {"ProductType", type text},
        {"ProductName", type text}, {"Quantity", Int64.Type}, {"UnitPrice", type number},
        {"UnitCost", type number}, {"Revenue", type number}, {"Cost", type number},
        {"Profit", type number}, {"OrderStatus", type text}, {"ShippingType", type text},
        {"PaymentType", type text}, {"Rating", Int64.Type}, {"CancellationReason", type text}
    }),
    #"Removed Other Columns" = Table.SelectColumns(
        #"Changed column type", {"CustomerID", "Gender", "AgeGroup", "Loyalty"}
    ),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns", {"CustomerID"}),
    #"Added AgeGroupSort" = Table.AddColumn(#"Removed Duplicates", "AgeGroupSort", each
        if [AgeGroup] = "Young Adult" then 1
        else if [AgeGroup] = "Adult" then 2
        else if [AgeGroup] = "Middle Age" then 3
        else if [AgeGroup] = "Mature" then 4
        else if [AgeGroup] = "Senior" then 5
        else 99, Int64.Type)
in
    #"Added AgeGroupSort"
```

- `Table.Distinct` theo `CustomerID` giữ **dòng đầu tiên** của mỗi khách. Vì Gender, AgeGroup, Loyalty được lặp lại ở từng đơn trong file gốc, nên cần kiểm tra các thuộc tính này không đổi giữa các đơn của cùng một khách.
- `AgeGroupSort` được tạo ở bước M (không phải cột DAX) để dùng làm cột sắp xếp cho `AgeGroup` theo thứ tự tuổi, tránh lỗi phụ thuộc vòng khi tạo bằng DAX.

### 3.3 `dim_product`

```m
let
    Source = Csv.Document(
        File.Contents(FilePath),
        [Delimiter = ",", Columns = 21, Encoding = 65001]
    ),
    #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {
        {"OrderID", type text}, {"OrderDate", type date}, {"CustomerID", type text},
        {"Gender", type text}, {"AgeGroup", type text}, {"Loyalty", type text},
        {"ProductID", type text}, {"SKU", type text}, {"ProductType", type text},
        {"ProductName", type text}, {"Quantity", Int64.Type}, {"UnitPrice", type number},
        {"UnitCost", type number}, {"Revenue", type number}, {"Cost", type number},
        {"Profit", type number}, {"OrderStatus", type text}, {"ShippingType", type text},
        {"PaymentType", type text}, {"Rating", Int64.Type}, {"CancellationReason", type text}
    }),
    #"Removed Other Columns" = Table.SelectColumns(
        #"Changed column type",
        {"ProductID", "SKU", "ProductType", "ProductName", "UnitPrice", "UnitCost"}
    ),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns", {"ProductID"})
in
    #"Removed Duplicates"
```

### 3.4 `dim_date`

```m
let
    StartDate = #date(2022, 1, 1),
    EndDate = #date(2025, 12, 31),
    DayCount = Duration.Days(EndDate - StartDate) + 1,
    DateList = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),
    ToTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),
    ChangeType = Table.TransformColumnTypes(ToTable, {{"Date", type date}}),
    AddYear = Table.AddColumn(ChangeType, "Year", each Date.Year([Date]), Int64.Type),
    AddQuarter = Table.AddColumn(AddYear, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),
    AddMonthNum = Table.AddColumn(AddQuarter, "MonthNumber", each Date.Month([Date]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonthNum, "MonthName", each Date.ToText([Date], "MMMM"), type text),
    AddYearMonth = Table.AddColumn(AddMonthName, "YearMonth", each Date.ToText([Date], "yyyy-MM"), type text),
    AddDay = Table.AddColumn(AddYearMonth, "Day", each Date.Day([Date]), Int64.Type),
    AddDayName = Table.AddColumn(AddDay, "DayName", each Date.ToText([Date], "dddd"), type text),
    AddDayOfWeek = Table.AddColumn(AddDayName, "DayOfWeekNumber", each Date.DayOfWeek([Date], Day.Monday) + 1, Int64.Type),
    AddWeekNum = Table.AddColumn(AddDayOfWeek, "WeekOfYear", each Date.WeekOfYear([Date]), Int64.Type),
    AddIsWeekend = Table.AddColumn(AddWeekNum, "IsWeekend", each Date.DayOfWeek([Date], Day.Monday) >= 5, type logical),
    AddMonthYear = Table.AddColumn(AddIsWeekend, "MonthYear", each Date.ToText([Date], "MMM yyyy"), type text),
    AddMonthYearSort = Table.AddColumn(AddMonthYear, "MonthYearSort", each [Year] * 100 + [MonthNumber], Int64.Type),
    #"Inserted Day Name" = Table.AddColumn(AddMonthYearSort, "Day Name", each Date.DayOfWeekName([Date]), type text)
in
    #"Inserted Day Name"
```

- Khoảng ngày (2022 đến 2025) phủ rộng hơn dữ liệu thật (01/09/2023 đến 23/09/2024) để các phép so sánh theo tháng không bị cắt ở biên. Nếu khoảng ngày lệch khỏi dữ liệu, các measure MoM sẽ trả về 0,0%.
- `MonthYear` (dạng "Sep 2023") là nhãn hiển thị, `MonthYearSort` (dạng 202309) là cột để sắp xếp đúng thứ tự thời gian.
- Bảng có hai cột tên ngày trong tuần: `DayName` ("Monday", theo cài đặt ngôn ngữ của Power BI) và `Day Name` (do `Date.DayOfWeekName`). Trên dashboard, visual ma trận dùng `DayName`.

## 4. Thành phần tạo bằng DAX (ngoài Power Query)

### 4.1 Cột tính toán của `dim_customer`

```dax
OrderCount          = CALCULATE ( COUNTROWS ( fact_sales ) )
ProductCount        = CALCULATE ( DISTINCTCOUNT ( fact_sales[ProductID] ) )
FirstOrderDate      = CALCULATE ( MIN ( fact_sales[OrderDate] ) )
FirstOrderMonth     = FORMAT ( [FirstOrderDate], "MMM YYYY" )
FirstOrderMonthSort = YEAR ( dim_customer[FirstOrderDate] ) * 100 + MONTH ( dim_customer[FirstOrderDate] )
```

`OrderCount` và `ProductCount` phục vụ hai biểu đồ phân bố khách hàng (theo số đơn, theo số sản phẩm). `FirstOrderMonth` là trục hàng của ma trận cohort retention, `FirstOrderMonthSort` dùng để sắp xếp cột này theo thời gian.

### 4.2 Bảng tính toán

```dax
-- Bảng chứa toàn bộ measure (không chứa dữ liệu)
_Measures = ROW ( "Placeholder", BLANK () )

-- Trục cột cho ma trận cohort (offset tháng 0 đến 12), bảng không có quan hệ
Month Index = SELECTCOLUMNS ( GENERATESERIES ( 0, 12, 1 ), "Month Index", [Value] )

-- Field parameter: người xem đổi chỉ số hiển thị của biểu đồ đường ở trang Product
Parameter =
{
    ( "Profit",     NAMEOF ( '_Measures'[Total Profit] ),     0 ),
    ( "Revenue",    NAMEOF ( '_Measures'[Total Revenue] ),    1 ),
    ( "Cost",       NAMEOF ( '_Measures'[Total Cost] ),       2 ),
    ( "Units Sold", NAMEOF ( '_Measures'[Total Units Sold] ), 3 )
}
```

Cột đầu của bảng `Parameter` đang có tên `Product_product.perfomance` (sai chính tả "perfomance"); có thể đổi tên thành `Metric` cho gọn, không ảnh hưởng đến measure.

## 5. Thiết lập sau khi nạp dữ liệu

| Thiết lập | Cách làm | Lý do |
|---|---|---|
| Đánh dấu bảng lịch | Chọn `dim_date` -> **Table tools -> Mark as date table** -> cột `Date` | `DATEADD` và `TOTALYTD` cần bảng lịch liên tục và được đánh dấu |
| Quan hệ | `fact_sales[OrderDate]` -> `dim_date[Date]`, `fact_sales[CustomerID]` -> `dim_customer[CustomerID]`, `fact_sales[ProductID]` -> `dim_product[ProductID]` | Cả ba đều nhiều-một (M:1), một chiều, đang hoạt động |
| Cột sắp xếp | `MonthYear` theo `MonthYearSort`; `AgeGroup` theo `AgeGroupSort`; `FirstOrderMonth` theo `FirstOrderMonthSort` | Tránh sắp xếp theo thứ tự chữ cái |
| Tắt Auto date/time | **File -> Options -> Current file -> Data Load -> bỏ chọn Auto date/time** | File hiện còn các bảng ngày tự động (`DateTableTemplate_...`, `LocalDateTable_...`); tắt đi để mô hình gọn và tránh xung đột với `dim_date` |

## 6. Gợi ý cải tiến (chưa áp dụng trong file .pbix)

Hiện ba truy vấn `fact_sales`, `dim_customer`, `dim_product` lặp lại cùng ba bước đầu (đọc CSV, nâng tiêu đề, ép kiểu), nghĩa là file CSV bị đọc ba lần khi refresh. Có thể tách thành một truy vấn staging không nạp vào mô hình, rồi để ba truy vấn kia tham chiếu tới nó:

```m
// Truy vấn "raw_sales" (tắt Enable load)
let
    Source = Csv.Document(File.Contents(FilePath), [Delimiter = ",", Columns = 21, Encoding = 65001]),
    #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", { /* như mục 3.1 */ })
in
    #"Changed column type"

// Truy vấn "dim_product" rút gọn còn:
let
    Source = Table.SelectColumns(raw_sales, {"ProductID", "SKU", "ProductType", "ProductName", "UnitPrice", "UnitCost"}),
    #"Removed Duplicates" = Table.Distinct(Source, {"ProductID"})
in
    #"Removed Duplicates"
```