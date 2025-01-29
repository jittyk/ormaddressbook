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
<cfset allEvents = []> 
<cffunction name="getRecurringEvents" access="public" returntype="array"> 
    <!--- Initialize variables --->
    <cfset var recurringEventDates = []>
    
    <!--- Fetch all events with a recurrence type within the specified date range --->
    <cfset var hql = "FROM Event WHERE str_recurrence_type != 'none'">
    <cfset var events = ormExecuteQuery(hql)>
    
    <cfloop array="#events#" index="event">
        <cfset var eventStartDate = event.getDt_event_date()> 
        <cfset var recurrenceType = event.getStr_recurrence_type()> 
        <cfset var recurringDuration = event.getInt_recurring_duration()> 
        <cfset var eventId = event.getInt_event_id()>  
        <cfset var name = event.getStr_event_title()>  
        <cfset var description = event.getStr_description()>  
        <cfset var reminderEmail = event.getStr_reminder_email()>  
        <cfset var priority = event.getStr_priority()>  
        <cfset var timeConstraint = event.getStr_time_constraint()>  
        <cfset var startTime = event.getDt_start_time()> 
        <cfset var endTime = event.getDt_end_time() >
        <cfset var eventEndDate = eventStartDate> 
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
                <cfset arrayAppend(recurringEventDates, {
                    date=currentDate, 
                    recurrenceType=recurrenceType, 
                    eventId=eventId, 
                    name=name, 
                    description=description, 
                    reminderEmail=reminderEmail, 
                    priority=priority, 
                    timeConstraint=timeConstraint, 
                     
                    startTime=startTime, 
                    endTime=endTime 
                                       
                })>
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
                        <cfset arrayAppend(recurringEventDates, {
                            date=nextOccurrence, 
                            recurrenceType=recurrenceType, 
                            eventId=eventId, 
                            name=name, 
                            description=description, 
                            reminderEmail=reminderEmail, 
                            priority=priority, 
                            timeConstraint=timeConstraint, 
                            startTime=startTime, 
                            endTime=endTime 
                        })>
                    </cfif>
                </cfloop>
                <cfset currentDate = dateAdd('ww', 1, currentDate)> <!--- Move to the next week --->
            <cfelseif recurrenceType EQ 'monthly'>
                <cfset daysOfMonth = event.getDays_of_month().split(",")> <!--- Split the days of the month into an array --->
                <cfloop array="#daysOfMonth#" index="day">
                    <cfset var nextOccurrence = dateAdd('m', 1, currentDate)> <!--- Move to the next month --->
                    <cfset nextOccurrence = createDate(year(nextOccurrence), month(nextOccurrence), day)> <!--- Set the day of the month using createDate --->
                    <cfif nextOccurrence LTE eventEndDate>
                        <cfset arrayAppend(recurringEventDates, {
                            date=nextOccurrence, 
                            recurrenceType=recurrenceType, 
                            eventId=eventId, 
                            name=name, 
                            description=description, 
                            reminderEmail=reminderEmail, 
                            priority=priority, 
                            timeConstraint=timeConstraint, 
                            startTime=startTime, 
                            endTime=endTime 
                            })>
                    </cfif>
                </cfloop>
                <cfset currentDate = dateAdd('m', 1, currentDate)> <!--- Move to the next month --->
            </cfif>
        </cfloop>
    </cfloop>
    <cfreturn recurringEventDates> 
</cffunction>
<cfif structKeyExists(form, "view")> 
    <cfswitch expression="#form.view#"> 
        <cfcase value="month"> 
            <cfset startOfMonth = variables.startDate> 
            <cfset endOfMonth = variables.endDate> 
            <cfset eventArray = []> 
            <cfset recurringEvents = getRecurringEvents()> 
            <cfloop array="#recurringEvents#" index="event"> 
                <cfif event.DATE GTE currentDate AND event.DATE LTE endOfMonth>
                    <cfloop from="#currentDate#" to="#endOfMonth#" index="currentDateLoop">
                        <cfif currentDateLoop EQ event.DATE >
                            <cfset arrayAppend(eventArray, event)>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfloop>
        </cfcase>
        <cfcase value="week"> 
            <cfset startOfWeek = dateAdd("d", -dayOfWeek(variables.currentDate) + 1, variables.currentDate)> 
            <cfset endOfWeek = dateAdd("d", 7 - dayOfWeek(variables.currentDate), variables.currentDate)> 
            <cfset eventArray = []>
            <cfset recurringEvents = getRecurringEvents()> 
            <cfloop array="#recurringEvents#" index="event"> 
                <cfif event.DATE GTE currentDate AND event.DATE LTE endOfWeek>
                    <cfloop from="#currentDate#" to="#endOfWeek#" index="currentDateLoop">
                        <cfif currentDateLoop EQ event.DATE >
                            <cfset arrayAppend(eventArray, event)>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfloop>
        </cfcase>
        <cfcase value="day"> 
            <cfset startOfDay = createDateTime(variables.currentYear, variables.currentMonth, variables.currentDay, 0, 0, 0)> 
            <cfset endOfDay = createDateTime(variables.currentYear, variables.currentMonth, variables.currentDay, 23, 59, 59)>
            <cfset eventArray = []>
            <cfset recurringEvents = getRecurringEvents()>
            <cfloop array="#recurringEvents#" index="event"> 
                <cfif currentDate EQ event.DATE >
                    <cfset arrayAppend(eventArray, event)>
                </cfif>
            </cfloop>
        </cfcase>
        <cfdefaultcase> 
            <cfset arrayAppend(eventArray, "")>
        </cfdefaultcase>
    </cfswitch> 
</cfif>

<cfset nonRecurringEvents = []> 


<cfset nonRecurringEvents = getNonRecurringEvents()>

<cffunction name="getNonRecurringEvents" access="private" returntype="array">
    <cfset var nonRecurringEvents = []>
    <cfset var event = {}>
    
    <!--- Load non-recurring events from the database --->
    <cfset nonRecurringEvents = entityLoad("Event", {str_recurrence_type='none'})>
    <cfset nonRecurringEventsArray = []>
    <cfloop array="#nonRecurringEvents#" index="event">
        <cfset arrayAppend(nonRecurringEventsArray, {
            eventId = event.getInt_event_id(),
            title = event.getStr_event_title(),
            description = event.getStr_description(),
            reminderEmail = event.getStr_reminder_email(),
            priority = event.getStr_priority(),
            timeConstraint = event.getStr_time_constraint(),
            startTime = event.getDt_start_time(),
            endTime = event.getDt_end_time(),
            mailSent = event.getBit_mail_sent(),
            eventDate = event.getDt_event_date(),
            daysOfWeek = event.getDays_of_week(),
            daysOfMonth = event.getDays_of_month(),
            recurrenceType = event.getStr_recurrence_type(),
            recurringDuration = event.getInt_recurring_duration(),
            recurring = event.getStr_recurring()
        })>
    </cfloop>
    <cfset nonRecurringEvents = nonRecurringEventsArray>
    <cfreturn nonRecurringEvents>
</cffunction>
<cfset currentDate = dateFormat(now(),"yyyy-mm-dd")>
<cfloop array="#nonRecurringEvents#" index="event">
    <cfif event.eventDate EQ currentDate >
        <cfset arrayAppend(eventArray, event)>
    </cfif>
</cfloop>

