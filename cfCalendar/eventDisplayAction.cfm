<!--- Check user session ---> 
<cfif NOT structKeyExists(session, "int_user_id") OR session.int_user_id EQ "" OR session.int_user_id IS 0> 
    <cflocation url="../cfAddressbook/login.cfm"> 
</cfif>

<!--- Set default form parameters ---> 
<cfparam name="form.view" default="month"> 
<cfparam name="form.action" default=""> 
<cfparam name="form.eventId" default="0"> 
<cfparam name="variables.successMessage" default="">
<cfparam name="variables.errorMessage" default="">

<!--- Initialize variables ---> 
<cfset variables.currentDate = DateFormat(now(), "yyyy-mm-dd")> 
<cfset variables.currentYear = year(variables.currentDate)> 
<cfset variables.currentMonth = month(variables.currentDate)> 
<cfset variables.currentDay = day(variables.currentDate)> 
<cfset variables.datasource = "dsn_address_book">

<!--- Set dynamic start and end dates ---> 
<cfset variables.startDate = createDate(variables.currentYear, variables.currentMonth, 1)> 
<cfset variables.startDate= DateFormat(variables.startDate,"yyyy-mm-dd")>
<cfset variables.endDate = dateAdd("d", -1, createDate(variables.currentYear, variables.currentMonth + 1, 1))>
<cfset variables.endDate= DateFormat(variables.endDate,"yyyy-mm-dd")>

<!--- Handle delete action ---> 
<cfif structKeyExists(form, "action") AND form.action EQ "delete" AND structKeyExists(form, "eventId")> 
    <cftry> 
        <cfset criteria = {int_event_id = form.eventId}> 
        <cfset event = entityLoad("Event", criteria)> 

        <cfif arrayLen(event) GT 0> 
            <cfset entityDelete(event[1])> 
            <cfset variables.successMessage = "Event deleted successfully."> 
        </cfif> 
        
        <cfcatch> 
            <cfset variables.errorMessage = "Error deleting event: " & cfcatch.message> 
        </cfcatch> 
    </cftry> 
</cfif>  
<cffunction name="getRecurringEvents" access="public" returntype="array"> 
    <!--- Initialize variables --->
    <cfset var recurringEventDates = []>
    
    <!--- Fetch all events with a recurrence type within the specified date range --->
    <cfset var hql = "FROM Event WHERE str_recurrence_type != 'none'">
    <cfset var events = ormExecuteQuery(hql)>
    
    <!--- Loop through each event to generate recurring dates --->
    <cfloop array="#events#" index="event">
        <cfset var eventStartDate = event.getDt_event_date()>
        <cfset var recurrenceType = event.getStr_recurrence_type()> <!--- Get the recurrence type --->
        <cfset var recurringDuration = event.getInt_recurring_duration()> <!--- Get the recurring duration --->
        <cfset var eventEndDate = eventStartDate> <!--- Initialize eventEndDate to eventStartDate --->

        <!--- Calculate the end date based on the recurrence type and duration --->
        <cfif recurrenceType EQ 'daily'>
            <cfset eventEndDate = dateAdd('d', recurringDuration, eventStartDate)>
        <cfelseif recurrenceType EQ 'weekly'>
            <cfset eventEndDate = dateAdd('ww', recurringDuration, eventStartDate)> <!--- End date is start date + duration in weeks --->
        <cfelse>
            <cfset eventEndDate = dateAdd('m', recurringDuration, eventStartDate)> <!--- End date is start date + duration in months --->
        </cfif>
        
        <!--- Now you can use eventEndDate in your logic --->
        <cfset var currentDate = eventStartDate> <!--- Initialize current date to start date --->

        <!--- Generate recurring dates based on the recurrence type until the end date --->
        <cfloop condition="currentDate LTE eventEndDate">
            <cfif recurrenceType EQ 'daily'>
                <cfset arrayAppend(recurringEventDates, {date=currentDate, recurrenceType=recurrenceType, eventId=event.getInt_event_id()})>
                <cfset currentDate = dateAdd('d', 1, currentDate)>
            <cfelseif recurrenceType EQ 'weekly'>
                <cfset daysOfWeek = event.getDays_of_week().split(",")> <!--- Split the days of the week into an array --->
                <cfset dayIntegers = []> <!--- Initialize an array to hold integer values of days --->
                <cfloop array="#daysOfWeek#" index="day">
                    <cfset arrayAppend(dayIntegers, event.getDayOfWeekInteger(trim(day)))> <!--- Use the method to get the integer value --->
                </cfloop>
                <cfloop array="#dayIntegers#" index="dayInt">
                    <cfset var nextOccurrence = currentDate>
                    <cfset nextOccurrence = dateAdd('d', (dayInt - dayOfWeek(currentDate)), nextOccurrence)> <!--- Calculate the next occurrence for the specific day --->
                    <cfif nextOccurrence LTE eventEndDate>
                        <cfset arrayAppend(recurringEventDates, {date=nextOccurrence, recurrenceType=recurrenceType, eventId=event.getInt_event_id()})>
                    </cfif>
                </cfloop>
                <cfset currentDate = dateAdd('ww', 1, currentDate)> <!--- Move to the next week --->
            <cfelseif recurrenceType EQ 'monthly'>
                <cfset daysOfMonth = event.getDays_of_month().split(",")> <!--- Split the days of the month into an array --->
                <cfloop array="#daysOfMonth#" index="day">
                    <cfset var nextOccurrence = dateAdd('m', 1, currentDate)> <!--- Move to the next month --->
                    <cfset nextOccurrence = createDate(year(nextOccurrence), month(nextOccurrence), day)> <!--- Set the day of the month using createDate --->
                    <cfif nextOccurrence LTE eventEndDate>
                        <cfset arrayAppend(recurringEventDates, {date=nextOccurrence, recurrenceType=recurrenceType, eventId=event.getInt_event_id()})>
                    </cfif>
                </cfloop>
                <cfset currentDate = dateAdd('m', 1, currentDate)> <!--- Move to the next month --->
            <cfelseif recurrenceType EQ 'yearly'>
                <cfset currentDate = dateAdd('yyyy', 1, currentDate)>
            </cfif>
        </cfloop>
    </cfloop>
    
    <!--- Return the array of recurring event dates with additional information --->
    <cfreturn recurringEventDates> 
</cffunction>

    
<cfif structKeyExists(form, "view")> 
    <cfswitch expression="#form.view#"> 
        <cfcase value="month"> 
            <!--- Initialize variables ---> 
            <cfset startOfMonth = variables.startDate> 
            <cfset endOfMonth = variables.endDate> 
            <cfset dateArray = []> 
            
            <!--- Get recurring events ---> 
            <cfset recurringEvents = getRecurringEvents()> 
            
            <!--- Iterate through recurring events ---> 
            <cfloop array="#recurringEvents#" index="event">
                <cfdump var="#DateFormat(event.DATE,"yyyy-mm-dd")#" >
                <cfloop condition="currentDate LTE endOfMonth">
                    <cfdump var="#DateFormat(currentDate,"yyyy-mm-dd")#" >
                
                    
                    <!--- Check if the event date matches the currentDate in the loop ---> 
                    <cfif DateFormat(event.DATE,"yyyy-mm-dd") EQ DateFormat(currentDate, "yyyy-mm-dd")>
                       
                        <!--- Check if the event is monthly and add to dateArray if matched ---> 
                        <cfif event.RECURRENCETYPE EQ "monthly">
                            <cfset arrayAppend(dateArray, currentDateFormatted)>
                        </cfif>
                    </cfif>
                    
                    <!--- Increment currentDate by 1 day ---> 
                    <cfset currentDate = DateAdd("d", 1, currentDate)>
                </cfloop>
            </cfloop>
            <cfdump var="#dateArray#" abort>
            <!--- Create criteria for future use ---> 
            <cfset criteria = {
                dt_event_date = dateArray
            }>
        </cfcase>
        
        
        <cfcase value="week"> 
            <cfset startOfWeek = dateAdd("d", -dayOfWeek(variables.currentDate) + 1, variables.currentDate)> 
            <cfset endOfWeek = dateAdd("d", 7 - dayOfWeek(variables.currentDate), variables.currentDate)> 
            
            <!--- Create an array of dates between startOfWeek and endOfWeek ---> 
            <cfset dateArray = []>
        
            <cfloop from="#startOfWeek#" to="#endOfWeek#" index="currentDate" step="1">
                <!--- Format the date to desired format and append to array ---> 
                <cfset arrayAppend(dateArray, DateFormat(currentDate, "yyyy-mm-dd"))>
            </cfloop>
        
            <!--- Set the criteria struct with the date array ---> 
            <cfset criteria = {
                dt_event_date = dateArray
            }> 
        
            <cfset recurringEventDates = getRecurringEvents(startOfWeek, endOfWeek)> 
        </cfcase> 
        
        <cfcase value="day"> 
            <cfset startOfDay = createDateTime(variables.currentYear, variables.currentMonth, variables.currentDay, 0, 0, 0)> 
            <cfset endOfDay = createDateTime(variables.currentYear, variables.currentMonth, variables.currentDay, 23, 59, 59)> 
            
            <!--- Create an array of a single date for the day ---> 
            <cfset dateArray = [DateFormat(startOfDay, "yyyy-mm-dd")]>
        
            <!--- Set the criteria struct with the date array ---> 
            <cfset criteria = {
                dt_event_date = dateArray
            }> 
        
            <cfset recurringEventDates = getRecurringEvents(startOfDay, endOfDay)> 
        </cfcase> 
        
        
        <cfdefaultcase> 
            <cfset criteria = {}> 
        </cfdefaultcase> 
       
    </cfswitch> 
</cfif>

<!--- Initialize events ---> 
<cfset events = []>

<cftry>
    <!--- Construct the dynamic criteria to select int_event_id based on dt_event_date using HQL --->
    <cfset queryCriteria = "FROM Event WHERE int_event_id IN (SELECT int_event_id FROM Event WHERE dt_event_date IN (:dateList))"> 
    <cfset params = {dateList: criteria.dt_event_date}>
    
    <cfset events = ormExecuteQuery(queryCriteria, params)> <!--- Load events based on the criteria using HQL --->
    
<cfcatch>
    <cfset variables.errorMessage = "Error loading events: " & cfcatch.message>
</cfcatch> 
</cftry>
