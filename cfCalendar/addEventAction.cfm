<cfset variables.datasource = "dsn_address_book">
<cfset variables.str_event_title = "">
<cfset variables.str_description = "">
<cfset variables.dt_event_date = "">
<cfset variables.str_reminder_email = "">
<cfset variables.str_recurrence_type = "none"> 
<cfset variables.int_recurring_duration = 1> 
<cfset variables.strErrorMsg = "">
<cfset variables.strSuccessMsg = "">
<cfset variables.dateString = "">
<cfset variables.dt_start_time = "00:00:00">
<cfset variables.dt_end_time = "11:59:59">
<cfset variables.days_of_week = structKeyExists(form, "days_of_week") ? form.days_of_week : "">
<cfset variables.days_of_month = structKeyExists(form, "days_of_month") ? form.days_of_month : "">
<cfset variables.qryGetEvents = "">
<cfset variables.str_time_constraint  = "">
<!--- Get eventId from form if exists --->
<cfset eventId = structKeyExists(form, "eventId") ? form.eventId : "" >
<cfset variables.int_event_id = structKeyExists(form, "eventId") ? form.eventId : 0> 
 
<cffunction name="setFormData" access="public" returntype="void">
<cfif variables.int_event_id NEQ 0>
    <cfset event = entityLoad("Event", variables.int_event_id)>
    <cfif arrayLen(event) GT 0>
        <cfset event = event[1]> <!-- Get the first entity -->
        <!--- Set event data to variables --->
        <cfset variables.str_event_title = event.str_event_title>
        <cfset variables.str_description = event.str_description>
        <cfset variables.dt_event_date = event.dt_event_date>
        <cfset variables.dateString = ListFirst(variables.dt_event_date, "T")>
        <cfset variables.str_priority = event.str_priority>   
        <cfset variables.str_time_constraint = event.str_time_constraint>   
        <cfset variables.str_reminder_email = event.str_reminder_email>
        <cfset variables.str_recurrence_type = event.str_recurrence_type>
        <cfset variables.int_recurring_duration = event.int_recurring_duration>
        <cfset variables.dt_start_time = event.dt_start_time>
        <cfif structKeyExists(event, "dt_end_time")>
            <cfset variables.dt_end_time = event.dt_end_time>
        </cfif>
        <cfset variables.days_of_week = event.days_of_week>
        <cfset variables.days_of_month = event.days_of_month>
    </cfif>
</cfif>
</cffunction>
 
<cffunction name="getFormValues" access="public" returntype="void">
    <cfset variables.str_event_title = structKeyExists(form, "str_event_title") ? trim(form.str_event_title) : "">
    <cfset variables.str_description = structKeyExists(form, "str_description") ? trim(form.str_description) : "">
    <cfset variables.str_reminder_email = structKeyExists(form, "str_reminder_email") ? trim(form.str_reminder_email) : "">
    <cfset variables.str_priority = structKeyExists(form, "str_priority") ? form.str_priority : "low">
    <cfset variables.str_time_constraint = structKeyExists(form, "str_time_constraint") ? form.str_time_constraint : "full_day">
    <cfset variables.dt_start_time = structKeyExists(form, "start_time") ? form.start_time : "00:00:00">
    <cfset variables.dt_end_time = structKeyExists(form, "end_time") ? form.end_time : "11:59:59">
    <cfset variables.dt_event_date = structKeyExists(form, "dt_event_date") ? form.dt_event_date : "">
    <cfset variables.days_of_week = structKeyExists(form, "days_of_week") ? form.days_of_week : "">
    <cfset variables.days_of_month = structKeyExists(form, "days_of_month") ? form.days_of_month : "">
    <cfset variables.str_recurrence_type = structKeyExists(form, "str_recurrence_type") ? form.str_recurrence_type : "none">
    <cfset variables.int_recurring_duration = structKeyExists(form, "int_recurring_duration") AND isNumeric(form.int_recurring_duration) ? form.int_recurring_duration : 1>
    <cfset variables.str_recurring = structKeyExists(form, "str_recurring") ? form.str_recurring : "">
</cffunction>

<cfif structKeyExists(variables, "dt_start_time") AND variables.dt_start_time NEQ "">
<cfset startTimeParam = variables.dt_start_time>

</cfif>

<cfif structKeyExists(variables, "dt_end_time") AND variables.dt_end_time NEQ "">
<cfset endTimeParam = variables.dt_end_time>

</cfif>


<cffunction name="validateFormValues" access="public" returntype="string">
<cfset var variables.strErrorMsg = "">

<!--- Validate Event Title --->
<cfif NOT len(variables.str_event_title)>
    <cfset variables.strErrorMsg &= 'Event Title is required.<br>'>
</cfif>

<!--- Validate Description --->
<cfif NOT len(variables.str_description)>
    <cfset variables.strErrorMsg &= 'Description is required.<br>'>
</cfif>

<!--- Validate Event Date --->
<cfif NOT structKeyExists(form, "dt_event_date") OR NOT len(trim(form.dt_event_date))>
    <cfset variables.strErrorMsg &= 'Valid Event Date is required.<br>'>
</cfif>

<!--- Validate Reminder Email ---> 
<cfif NOT REFindNoCase("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$", variables.str_reminder_email)>
    <cfset variables.strErrorMsg &= 'Reminder Email is not valid.<br>'>
</cfif>

<!--- Validate Recurrence Duration --->
<cfif NOT (isNumeric(variables.int_recurring_duration) AND variables.int_recurring_duration GTE 1)>
    <cfset variables.strErrorMsg &= 'Recurrence Duration must be a number greater than or equal to 1.<br>'>
</cfif>

<!--- Validate Start Time only if "custom" is selected --->
<cfif variables.str_time_constraint EQ "custom">
    <cfif NOT len(variables.dt_start_time)>
        <cfset variables.strErrorMsg &= 'Start Time is required when custom time is selected.<br>'>
    </cfif>
</cfif>
<!--- Validate Days of Week --->
<cfif variables.str_recurrence_type EQ "weekly" AND NOT len(variables.days_of_week)>
    <cfset variables.strErrorMsg &= 'Days of Week are required when weekly recurrence is selected.<br>'>
</cfif>

<!--- Validate Days of Month --->
<cfif variables.str_recurrence_type EQ "monthly" AND NOT len(variables.days_of_month)>
    <cfset variables.strErrorMsg &= 'Days of Month are required when monthly recurrence is selected.<br>'>
</cfif>

<!--- Validate End Time only if "custom" is selected --->
<cfif variables.str_time_constraint EQ "custom">
    <cfif NOT len(variables.dt_end_time)>
        <cfset variables.strErrorMsg &= 'End Time is required when custom time is selected.<br>'>
    </cfif>
</cfif>

<!-- Return the accumulated error messages -->
<cfreturn variables.strErrorMsg>
</cffunction>
<cfif structKeyExists(variables, "dt_start_time") AND variables.dt_start_time NEQ "">
<cfset startTimeParam = variables.dt_start_time>

</cfif>

<cfif structKeyExists(variables, "dt_end_time") AND variables.dt_end_time NEQ "">
<cfset endTimeParam = variables.dt_end_time>

</cfif>
<cffunction name="saveOrUpdateEvent" access="public" returntype="string">
    <cfset var strSuccessMsg = "">
    
   
    <cftry>
        <cfif variables.int_event_id NEQ 0>
            <!--- Load the existing event using ORM --->
            <cfset event = entityLoad("Event", variables.int_event_id)>
            <cfif arrayLen(event) GT 0>
                <cfset event = event[1]> <!-- Get the first entity -->
                <!--- Update the event properties --->
                <cfset event.str_event_title = variables.str_event_title>
                <cfset event.str_description = variables.str_description>
                <cfset event.dt_event_date = variables.dt_event_date>
                <cfset event.str_reminder_email = variables.str_reminder_email>
                <cfset event.str_priority = variables.str_priority>
                <cfset event.str_time_constraint = variables.str_time_constraint>
                <cfset event.dt_start_time = variables.dt_start_time>
                <cfset event.dt_end_time = variables.dt_end_time>
                <cfset event.days_of_week = variables.days_of_week>
                <cfset event.days_of_month = variables.days_of_month>
                <cfset event.str_recurrence_type = variables.str_recurrence_type>
                <cfset event.int_recurring_duration = variables.int_recurring_duration>
                <cfset event.str_recurring = variables.str_recurring>
                <!--- Save the updated event --->
                <cfset entitySave(event)>
                <cfset strSuccessMsg = "Event updated successfully.">
            </cfif>
        <cfelse>
            <!--- Create a new event using ORM --->
            <cfset event = createObject("component", "cfCalendar.models.Event")>
            <cfset event.str_event_title = variables.str_event_title>
            <cfset event.str_description = variables.str_description>
            <cfset event.dt_event_date = variables.dt_event_date>
            <cfset event.str_reminder_email = variables.str_reminder_email>
            <cfset event.str_priority = variables.str_priority>
            <cfset event.str_time_constraint = variables.str_time_constraint>
            <cfset event.dt_start_time = variables.dt_start_time>
            <cfset event.dt_end_time = variables.dt_end_time>
            <cfset event.days_of_week = variables.days_of_week>
            <cfset event.days_of_month = variables.days_of_month>
            <cfset event.str_recurrence_type = variables.str_recurrence_type>
            <cfset event.int_recurring_duration = variables.int_recurring_duration>
            <cfset event.str_recurring = variables.str_recurring>
            <!--- Save the new event --->
            <cfset entitySave(event)>
            <cfset strSuccessMsg = "Event created successfully.">
        </cfif>
        <cfcatch type="any">

            <cfset strSuccessMsg = "Error: " & cfcatch.message>
        </cfcatch>
    </cftry>

    <cfreturn strSuccessMsg>
</cffunction>

<!--- Main processing logic --->

<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="../cfAddressbook/login.cfm">
</cfif>


<cfset setFormData()>

<cfif structKeyExists(form, "int_event_id")>
    

    <cfset getFormValues()>
    
    <!--- Validate the form values ---> 
    <cfset variables.strErrorMsg = validateFormValues()>
    
    <cfif NOT len(variables.strErrorMsg)>
        
        <cfset variables.strSuccessMsg = saveOrUpdateEvent()>
        
        <!--- Re-fetch the event details to ensure updated values are displayed ---> 
        <cfif len(variables.int_event_id)>
            <cfset setFormData()>
        </cfif>   
    </cfif>
    
</cfif>