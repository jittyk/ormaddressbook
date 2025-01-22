<!-- Ensure the user is logged in -->
<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="../cfAddressbook/login.cfm">
</cfif>

<cfset currentDate = now()>
<cfset variables.datasource = "dsn_address_book">
<cfset currentYear = year(currentDate)>
<cfset selectedYear = structKeyExists(form, "year") ? form.year : currentYear>
<cfset selectedMonth = structKeyExists(form, "month") ? form.month : month(currentDate)>
<cfset firstDayOfMonth = createDate(selectedYear, selectedMonth, 1)>
<cfset daysInMonth = daysInMonth(firstDayOfMonth)>
<cfset totalCells = 42>
<cfset dayOfWeek = dayOfWeek(firstDayOfMonth)>
<cfset filledCells = dayOfWeek + daysInMonth - 1>
<cfset emptyCells = totalCells - filledCells>

<!-- Query the holidays -->
<cfquery name="qryHolidays" datasource="#variables.datasource#">
    SELECT 
        int_month, 
        int_day, 
        str_holiday_title
    FROM tbl_holidays
</cfquery>

<!-- Create an array for holiday dates -->
<cfset holidays = []>
<cfloop query="qryHolidays">
    <cfset arrayAppend(holidays, createDate(selectedYear, qryHolidays.int_month, qryHolidays.int_day))>
</cfloop>

<!-- Query the events -->
<cfquery name="qryEvents" datasource="#variables.datasource#">
    SELECT 
        dt_event_date,
        str_event_title,
        str_description,
        str_recurrence_type,
        days_of_week,
        days_of_month,
        int_recurring_duration
    FROM tbl_events
</cfquery>

<!-- Process recurring events -->
<cfset recurringEvents = []>
<cfloop query="qryEvents">

    <!-- Set the start date -->
    <cfset startDate = qryEvents.dt_event_date>
    
    <!-- Determine the end date based on the recurrence type -->
    <cfif qryEvents.str_recurrence_type EQ "daily">
        <!-- Daily: Add the number of days (int_recurring_duration) to the start date -->
        <cfset endDate = dateAdd("d", qryEvents.int_recurring_duration-1, startDate)>
    <cfelseif qryEvents.str_recurrence_type EQ "weekly">
        <!-- Weekly: Add weeks (int_recurring_duration * 7 days) -->
        <cfset endDate = dateAdd("m", qryEvents.int_recurring_duration * 7, startDate)>
    <cfelseif qryEvents.str_recurrence_type EQ "monthly">
        <!-- Monthly: Add months (int_recurring_duration) -->
        <cfset endDate = dateAdd("m", qryEvents.int_recurring_duration, startDate)>
    <cfelse>
        <!-- None: Start and end date are the same -->
        <cfset endDate = startDate>
    </cfif>

    
    <!-- Daily Recurrence -->
    <cfif str_recurrence_type EQ "daily">
        <cfset eventdate = startDate>
        <cfloop condition="eventDate LTE endDate">
            <cfset arrayAppend(recurringEvents, eventDate)>
            <cfset eventDate = dateAdd("d", 1, eventDate)>
        </cfloop>
    </cfif>
    
    <cfif str_recurrence_type EQ "weekly">
        <!--- Mapping day names to their corresponding integer values --->
        <cfset dayNamesToNumbers = {
            "Sunday" = 1,
            "Monday" = 2,
            "Tuesday" = 3,
            "Wednesday" = 4,
            "Thursday" = 5,
            "Friday" = 6,
            "Saturday" = 7
        }>
        
        <!--- Convert the comma-separated days_of_week values from the query result (day names) to an array of integers --->
        <cfset selectedDays = []>
        <cfloop array="#listToArray(qryEvents.days_of_week)#" index="dayName">
            <cfset arrayAppend(selectedDays, dayNamesToNumbers[dayName])>
        </cfloop>
        
        <cfset eventdate = startDate>
        
        <cfloop condition="eventdate LTE endDate">
            <!--- Get the day of the week (integer value) --->
            <cfset day = dayOfWeek(eventdate)>
            
            <!--- Check if the selectedDays array contains the current day number --->
            <cfif arrayContains(selectedDays, day)>
                <!--- Append the eventdate to recurringEvents if the day matches --->
                <cfset arrayAppend(recurringEvents, eventdate)>
            </cfif>
            
            <!--- Increment the eventdate by 1 day to check the next day --->
            <cfset eventdate = dateAdd("d", 1, eventdate)>
        </cfloop>
    </cfif>
    
    <!-- Monthly Recurrence -->
    <cfif str_recurrence_type EQ "monthly">
        <cfset selectedDates = listToArray(qryEvents.days_of_month)>
        <cfset currentDate = startDate>
        <cfloop condition="currentDate LTE endDate">
            <!-- Check if the day of the month is in the selected dates -->
            <cfif arrayContains(selectedDates, day(currentDate))>
                <cfset arrayAppend(recurringEvents, currentDate)>
            </cfif>
            <cfset currentDate = dateAdd("d", 1, currentDate)>
        </cfloop>
    </cfif>
</cfloop>
<cfquery name="qryNonRecurringEvents" datasource="#variables.datasource#">
    SELECT 
        dt_event_date,
        str_event_title,
        str_description
    FROM tbl_events
    WHERE str_recurrence_type = "none"
</cfquery>

<!-- Process Non-Recurring Events -->
<cfset nonRecurringEvents = []>
<cfloop query="qryNonRecurringEvents">
    <cfset arrayAppend(nonRecurringEvents, qryNonRecurringEvents.dt_event_date)>
</cfloop>

<!-- Combine Recurring and Non-Recurring Events -->
<cfset allEvents = recurringEvents>
<cfset arrayAppend(allEvents, nonRecurringEvents)>

<!-- Process the calendar data -->
<cfset datesData = []>
<cfloop index="day" from="1" to="#daysInMonth#">
    <cfset selectedDate = createDate(selectedYear, selectedMonth, day)>
    <cfset formattedDate = dateFormat(selectedDate, "yyyy-mm-dd")>
    <cfset isToday = (
        day EQ day(now()) 
        AND selectedMonth EQ month(now()) 
        AND selectedYear EQ year(now())
    )>
    <cfset isHoliday = false>
    <cfset hasEvent = false>

    <!-- Mark Sundays as holidays -->
    <cfif dayOfWeek(selectedDate) EQ 1>
        <cfset isHoliday = true>
    </cfif>
    <!-- Mark second and fourth Saturdays as holidays -->
    <cfif dayOfWeek(selectedDate) EQ 7 AND (int((day - 1) / 7) EQ 1 OR int((day - 1) / 7) EQ 3)>
        <cfset isHoliday = true>
    </cfif>
    
    <!-- Check if the date is in the holiday list -->
    <cfif arrayContains(holidays, selectedDate)>
        <cfset isHoliday = true>
    </cfif>
    
    <cfif arrayContains(allEvents, selectedDate)>
        <cfset hasEvent = true>
    </cfif>
    <!-- Append the day's data -->
    <cfset arrayAppend(datesData, { 
        "day" = day, 
        "isToday" = isToday, 
        "isHoliday" = isHoliday, 
        "hasEvent" = hasEvent, 
        "selectedDate" = selectedDate 
    })>
</cfloop>
