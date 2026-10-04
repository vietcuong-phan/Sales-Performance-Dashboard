/*
================================================================================
 Query    : dim_date
 Project  : Sales Performance Dashboard (Power BI)
 Purpose  : Calendar (date dimension) table, built entirely in Power Query.
            No source file needed.
 Range    : 2022-01-01 to 2025-12-31 (1,461 days, one row per day, no gaps)
            The data itself runs 2023-09-01 to 2024-09-23; the wider range keeps
            previous-month comparisons (DATEADD) from being cut off at the edges.
 Grain    : 1 row = 1 calendar day
 Key      : [Date]  ->  related to fact_sales[OrderDate]  (many-to-one, single direction)
 Columns  : 14

   Column           Type     Example      Notes
   ---------------  -------  -----------  ---------------------------------------------
   Date             date     2024-01-15   Key. Mark this table as a date table on this column
   Year             integer  2024
   Quarter          text     Q1
   MonthNumber      integer  1
   MonthName        text     January      Language follows the Power BI locale
   YearMonth        text     2024-01      Sortable text, handy for exports
   Day              integer  15           Day of month
   DayName          text     Monday       Used on the Customer page matrix
   DayOfWeekNumber  integer  1            Monday = 1 ... Sunday = 7, sort column for DayName
   WeekOfYear       integer  3
   IsWeekend        logical  FALSE        TRUE for Saturday and Sunday
   MonthYear        text     Jan 2024     Display label on charts and matrices
   MonthYearSort    integer  202401       Sort column for MonthYear
   Day Name         text     Monday       Duplicate of DayName (Date.DayOfWeekName)

 After loading:
   1. Table tools > Mark as date table > choose [Date]
   2. Set Sort by column:  MonthYear -> MonthYearSort,  DayName -> DayOfWeekNumber
   3. Turn off File > Options > Current file > Data Load > Auto date/time
 To change the range, edit StartDate / EndDate below. Keep the range continuous
 and wide enough to cover all of fact_sales[OrderDate].
================================================================================
*/
let
    // --- 1. Date range ------------------------------------------------------
    StartDate = #date(2022, 1, 1),
    EndDate = #date(2025, 12, 31),
    DayCount = Duration.Days(EndDate - StartDate) + 1,

    // --- 2. One row per day -------------------------------------------------
    DateList = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),
    ToTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),
    ChangeType = Table.TransformColumnTypes(ToTable, {{"Date", type date}}),

    // --- 3. Calendar attributes ---------------------------------------------
    AddYear = Table.AddColumn(ChangeType, "Year", each Date.Year([Date]), Int64.Type),
    AddQuarter = Table.AddColumn(AddYear, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),
    AddMonthNum = Table.AddColumn(AddQuarter, "MonthNumber", each Date.Month([Date]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonthNum, "MonthName", each Date.ToText([Date], "MMMM"), type text),
    AddYearMonth = Table.AddColumn(AddMonthName, "YearMonth", each Date.ToText([Date], "yyyy-MM"), type text),
    AddDay = Table.AddColumn(AddYearMonth, "Day", each Date.Day([Date]), Int64.Type),
    AddDayName = Table.AddColumn(AddDay, "DayName", each Date.ToText([Date], "dddd"), type text),

    // --- 4. Weekday helpers (Monday-first week) -----------------------------
    AddDayOfWeek = Table.AddColumn(AddDayName, "DayOfWeekNumber", each Date.DayOfWeek([Date], Day.Monday) + 1, Int64.Type),
    AddWeekNum = Table.AddColumn(AddDayOfWeek, "WeekOfYear", each Date.WeekOfYear([Date]), Int64.Type),
    AddIsWeekend = Table.AddColumn(AddWeekNum, "IsWeekend", each Date.DayOfWeek([Date], Day.Monday) >= 5, type logical),

    // --- 5. Display label and its sort key ----------------------------------
    AddMonthYear = Table.AddColumn(AddIsWeekend, "MonthYear", each Date.ToText([Date], "MMM yyyy"), type text),
    AddMonthYearSort = Table.AddColumn(AddMonthYear, "MonthYearSort", each [Year] * 100 + [MonthNumber], Int64.Type),

    // --- 6. Extra day-name column (kept as in the .pbix) --------------------
    #"Inserted Day Name" = Table.AddColumn(AddMonthYearSort, "Day Name", each Date.DayOfWeekName([Date]), type text)
in
    #"Inserted Day Name"
