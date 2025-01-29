<cfparam name="form.view" default="all">
<cfset currentYear = year(now())>
<cfset variables.selectedYear = structKeyExists(form, "year") ? form.year : currentYear>

<!-- Fetch holidays using ORM -->
<cfset holidays = EntityLoad("Holiday")>
<cfset holidaysArray = []> <!-- Initialize an empty array to store holidays -->

<cfloop array="#holidays#" index="holiday">
    <!-- Create a date for each holiday using the current year, month, and day from the ORM object -->
    <cfset variables.holidayDate = createDate(selectedYear, holiday.getInt_month(), holiday.getInt_day())>
    
    <!-- Add the holidayDate and title to the holidays array -->
    <cfset arrayAppend(holidaysArray, {date=variables.holidayDate, title=holiday.getStr_holiday_title()})>
</cfloop>

<!-- Sort the holidaysArray by date using a custom function -->
<cfset arraySort(holidaysArray, function(a, b) {
    return compare(a.date, b.date);
})>