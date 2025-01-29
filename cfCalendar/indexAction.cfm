<!-- Ensure the user is logged in -->
<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="../cfAddressbook/login.cfm">
</cfif>

<cfset currentDate = now()>
<cfset currentYear = year(currentDate)>
<cfset selectedYear = structKeyExists(form, "year") ? form.year : currentYear>
<cfset selectedMonth = structKeyExists(form, "month") ? form.month : month(currentDate)>
<cfset firstDayOfMonth = createDate(selectedYear, selectedMonth, 1)>
<cfset daysInMonth = daysInMonth(firstDayOfMonth)>
<cfset totalCells = 42>
<cfset dayOfWeek = dayOfWeek(firstDayOfMonth)>
<cfset filledCells = dayOfWeek + daysInMonth - 1>
<cfset emptyCells = totalCells - filledCells>

<!-- Query holidays -->
<cfset holidays = EntityLoad("Holiday", { int_month = selectedMonth })>
<cfset holidayDates = []>
<cfloop array="#holidays#" index="holiday">
    <cfset arrayAppend(holidayDates, createDate(selectedYear, holiday.getInt_month(), holiday.getInt_day()))>
</cfloop>

<!-- Query events -->
<cfset events = EntityLoad("Event")>
<cfset recurringEvents = []>
<cfset nonRecurringEvents = []>

<cfloop array="#events#" index="event">
    <cfset startDate = event.getDt_event_date()>
    <cfif event.getStr_recurrence_type() EQ "daily">
        <cfset endDate = dateFormat(dateAdd("d", event.getInt_recurring_duration() - 1, startDate),"yyyy-mm-dd")>
        <cfset currentDate = startDate>
        <cfloop condition="currentDate LTE endDate">
            <cfset arrayAppend(recurringEvents, currentDate)>
            <cfset currentDate = dateFormat(dateAdd("d", 1, currentDate),"yyyy-mm-dd")>
        </cfloop>
    <cfelseif event.getStr_recurrence_type() EQ "weekly"> 

        <!-- Calculate the recurrence end date -->
        <cfset endDate = dateAdd("m", event.getInt_recurring_duration() - 1, startDate)>
    
        <!-- Get the days of the week as integers -->
        <cfset daysOfWeekArray = listToArray(event.getDays_of_week())>
        <cfset daysOfWeekIntegers = arrayMap(daysOfWeekArray, function(dayName) {
            return event.getDayOfWeekInteger(dayName);
        })>
    
        <!-- Initialize the current date for the loop -->
        <cfset currentDate = startDate>
    
        <!-- Loop through each day to check recurrence -->
        <cfloop condition="currentDate LTE endDate">
            <cfif arrayContains(daysOfWeekIntegers, dayOfWeek(currentDate))>
                <cfset arrayAppend(recurringEvents, currentDate)>
            </cfif>
    
            <!-- Move to the next day -->
            <cfset currentDate = dateAdd("d", 1, currentDate)>
        </cfloop>
    
    <cfelseif event.getStr_recurrence_type() EQ "monthly">
        <cfset endDate = dateAdd("m", event.getInt_recurring_duration(), startDate)>
        <cfset daysOfMonthArray = listToArray(event.getDays_of_month())>
        <cfset currentDate = startDate>
        <cfloop condition="currentDate LTE endDate">
            <cfif arrayContains(daysOfMonthArray, day(currentDate))>
                <cfset arrayAppend(recurringEvents, currentDate)>
            </cfif>
            <cfset currentDate = dateAdd("d", 1, currentDate)>
        </cfloop>
    <cfelse>
        <cfset arrayAppend(nonRecurringEvents, startDate)>
    </cfif>
</cfloop>

<!-- Combine events -->
<cfset allEvents = []>

<cfloop array="#recurringEvents#" index="event">
    <cfset arrayAppend(allEvents, DateFormat(event,"yyyy-mm-dd"))>
</cfloop>

<cfloop array="#nonRecurringEvents#" index="event">
    <cfset arrayAppend(allEvents, DateFormat(event,"yyyy-mm-dd"))>
</cfloop>
  
<cfset datesData = []>
<cfloop index="day" from="1" to="#daysInMonth#">
    <cfset selectedDate = createDate(selectedYear, selectedMonth, day)>
    <cfset isHoliday = arrayContains(holidayDates, selectedDate)>
    
    <cfset hasEvent = arrayContains(allEvents, selectedDate)>
    <cfset arrayAppend(datesData, { 
        "day" = day, 
        "isToday" = (selectedDate EQ currentDate), 
        "isHoliday" = isHoliday, 
        "hasEvent" = hasEvent ,
        "selectedDate" = selectedDate 
    })>
</cfloop>
