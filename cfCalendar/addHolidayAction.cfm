<cfset holidayTitle = trim(form.holidayTitle)>
<cfset holidayMonth = form.holidayMonth>
<cfset holidayDay = form.holidayDay>

<!-- Check if the form is submitted with required values -->
<cfif holidayTitle neq "" and holidayMonth and holidayDay>

    <!-- Insert the holiday into the database -->
    <cfquery datasource="dsn_address_book">
        INSERT INTO tbl_holidays (int_month, int_day, str_holiday_title)
        VALUES (
            <cfqueryparam value="#holidayMonth#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#holidayDay#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#holidayTitle#" cfsqltype="cf_sql_varchar">
        )
    </cfquery>

    <cfset message = "Holiday added successfully!">
<cfelse>
    <cfset message = "Please fill in all fields.">
</cfif>

<!-- Redirect to a confirmation page or back to the holidays list -->
<cfset redirectURL = "holidays.cfm">
<cflocation url="#redirectURL#" addtoken="no">
