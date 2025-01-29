<cfset holidayTitle = trim(form.holidayTitle)>
<cfset holidayMonth = form.holidayMonth>
<cfset holidayDay = form.holidayDay>

<!-- Check if the form is submitted with required values -->
<cfif holidayTitle neq "" and holidayMonth and holidayDay>
    <!-- Create a new instance of the Holiday object -->
    <cfset holiday = entityNew("Holiday")>

    <!-- Set the values -->
    <cfset holiday.setInt_month(holidayMonth)>
    <cfset holiday.setInt_day(holidayDay)>
    <cfset holiday.setStr_holiday_title(holidayTitle)>

    <!-- Save the object -->
    <cfset entitySave(holiday)>

    <cfset message = "Holiday added successfully!">
<cfelse>
    <cfset message = "Please fill in all fields.">
</cfif>

<!-- Redirect to a confirmation page or back to the holidays list -->
<cfset redirectURL = "holidays.cfm">
<cflocation url="#redirectURL#" addtoken="no">
