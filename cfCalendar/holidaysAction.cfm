<cfparam name="form.view" default="all">
<cfset currentYear = year(now())>
<cfset variables.selectedYear = structKeyExists(form, "year") ? form.year : currentYear>

<!--- Fetch holidays from the database --->
<cfquery name="qryholidays" datasource="dsn_address_book">
    SELECT int_holiday_id, int_month, int_day, str_holiday_title
    FROM tbl_holidays
    ORDER BY int_month, int_day ASC
</cfquery>
<cfset selectedYear = year(now())> <!-- Set to the current year -->

<cfset holidays = []> <!-- Initialize an empty array to store holidays -->

<cfloop query="qryholidays">
    <!-- Create a date for each holiday using the current year, month, and day from the query -->
    <cfset variables.holidayDate = createDate(selectedYear, qryholidays.int_month, qryholidays.int_day)>
    
    <!-- Add the holidayDate to the holidays array -->
    <cfset arrayAppend(holidays, variables.holidayDate)>
</cfloop>
