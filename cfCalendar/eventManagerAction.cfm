<cffunction name="getEvents" access="public" returntype="array" output="false">
    <cfargument name="selectedDate" type="date" required="true">
    <cfargument name="datasource" type="string" required="true">
    
    <cfset var formattedDate = dateFormat(arguments.selectedDate, "yyyy-mm-dd") />
    <cfset var startDate = dateAdd("d", -30, arguments.selectedDate) />
    <cfset var endDate = dateAdd("d", 30, arguments.selectedDate) />
    <cfset var events = [] />
    
    <!--- Fetch events with ORM ---> 
    <cfset var allEvents = entityLoad("Event")>

    <!--- Loop through all events and filter by recurrence rules --->
    <cfloop array="#allEvents#" index="event">
        <cfset var eventDate = event.getDt_event_date()>
        <cfset var recurrenceType = event.getStr_recurrence_type()>

        <!--- Handle "none" recurrence type --->
        <cfif recurrenceType eq "none" AND dateFormat(eventDate, "yyyy-mm-dd") eq formattedDate>
            <cfset arrayAppend(events, event)>
        
        <!--- Handle "daily" recurrence type --->
        <cfelseif recurrenceType eq "daily">
            <!-- Calculate the next occurrence of the event based on the recurring duration -->
            <cfset var endDate = dateAdd("d", event.getInt_recurring_duration() - 1, eventDate)>
            <cfif eventDate LTE arguments.selectedDate AND endDate GTE arguments.selectedDate>
                <cfset arrayAppend(events, event)>
            </cfif>
       
        <!--- Handle "weekly" recurrence type --->
    <cfelseif recurrenceType eq "weekly">
        <!-- Calculate the next occurrence by adding weeks to the event date -->
        <cfset var endDate = dateAdd("ww", event.getInt_recurring_duration(), eventDate)>
        
        <cfif eventDate LTE arguments.selectedDate AND endDate GTE arguments.selectedDate>
            <!-- Convert comma-separated string to an array -->
            <cfset var eventDays = listToArray(event.getDays_of_week())>
            <cfset var dayIntegers = []>
    
            <!-- Loop through the array -->
            <cfloop array="#eventDays#" index="day">
                <cfset arrayAppend(dayIntegers, event.getDayOfWeekInteger(trim(day)))>
            </cfloop>
    
            <!-- Convert array to list for comparison -->
            <cfset dayIntegers = arrayToList(dayIntegers)>
            <cfset var dayOfWeek = dayOfWeek(arguments.selectedDate)>
    
            <!-- Check if the selected day exists in the eventDays -->
            <cfif findNoCase(dayOfWeek, dayIntegers)>
                <cfset arrayAppend(events, event)>
            </cfif>
        </cfif>
    
        
        <!--- Handle "monthly" recurrence type --->
        <cfelseif recurrenceType eq "monthly">
            <!-- Calculate the next occurrence by adding months to the event date -->
            <cfset var endDate = dateAdd("m", event.getInt_recurring_duration(), eventDate)>
            <cfif eventDate LTE arguments.selectedDate AND endDate GTE arguments.selectedDate>
                <!-- Check if the day of the selected date matches the event's recurrence days -->
                <cfset var dayOfMonth = day(arguments.selectedDate)>
                <cfif findNoCase(dayOfMonth, event.getDays_of_month())>
                    <cfset arrayAppend(events, event)>
                </cfif>
            </cfif>
        </cfif>
    </cfloop>

    <cfreturn events />
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

