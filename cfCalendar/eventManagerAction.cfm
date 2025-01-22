<!-- Define function to query events -->
<cffunction name="getEvents" access="public" returntype="query" output="false">
    <cfargument name="selectedDate" type="date" required="true">
    <cfargument name="datasource" type="string" required="true">

    <cfset var qryEvents = "" />
    <cfset var formattedDate = dateFormat(arguments.selectedDate, "yyyy-mm-dd") />
    <cfset var startDate = dateAdd("d", -30, arguments.selectedDate) />
    <cfset var endDate = dateAdd("d", 30, arguments.selectedDate) />

    <cfquery name="qryEvents" datasource="#arguments.datasource#">
        SELECT 
            int_event_id AS id,
            str_event_title,
            str_description,
            str_reminder_email,
            str_priority,
            str_time_constraint,
            dt_start_time,
            dt_end_time,
            bit_mail_sent,
            dt_event_date,
            days_of_week,
            days_of_month,
            str_recurrence_type,
            int_recurring_duration
        FROM tbl_events
        WHERE 
            (str_recurrence_type = 'none' AND dt_event_date = <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date">)
            OR 
            (str_recurrence_type = 'daily' AND dt_event_date <= <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date"> 
                AND DATE_ADD(dt_event_date, INTERVAL int_recurring_duration - 1 DAY) >= <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date">
            )
            <!--- Match weekly recurrence for multiple days of the week --->
            OR 
            (
                str_recurrence_type = 'weekly'
                AND dt_event_date <= <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date">
                AND DATE_ADD(dt_event_date, INTERVAL int_recurring_duration MONTH) >= <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date">
                AND FIND_IN_SET(DAYNAME(<cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date">), days_of_week) > 0
                AND days_of_week IS NOT NULL
                AND days_of_week != ''
                
            )

            OR 
            (str_recurrence_type = 'monthly' AND dt_event_date <= <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date">
                AND FIND_IN_SET(DAY(<cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date">), days_of_month) > 0
                AND DATE_ADD(dt_event_date, INTERVAL int_recurring_duration MONTH) >= <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date">
            )
    </cfquery>
    
    <cfreturn qryEvents />
</cffunction>

<!-- Control Block -->
<cfset variables.datasource = "dsn_address_book">

<!-- Determine the selected date -->
<cfif structKeyExists(form, "date")>
    <cfset selectedDate = parseDateTime(form.date)>
<cfelse>
    <cfset selectedDate = now()> <!-- Default to current date if not provided -->
</cfif>

<!-- Query events for the selected date -->
<cfset qryEvents = getEvents(selectedDate, variables.datasource)>

<!-- Store queried events and the selected date in variables -->
<cfset variables.qryEvents = qryEvents>
<cfset variables.selectedDate = selectedDate>
