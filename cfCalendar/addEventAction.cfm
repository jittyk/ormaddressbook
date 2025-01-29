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
<cfset variables.str_priority = "low">
<cfset variables.days_of_week = structKeyExists(form, "days_of_week") ? form.days_of_week : "">
<cfset variables.days_of_month = structKeyExists(form, "days_of_month") ? form.days_of_month : "">
<cfset variables.str_time_constraint = "">

<!-- Get eventId from form if exists -->
<cfset eventId = structKeyExists(form, "eventId") ? form.eventId : "" >
<cfset variables.int_event_id = structKeyExists(form, "eventId") ? form.eventId : 0>

<cffunction name="setFormData" access="public" returntype="void">
    <cfif variables.int_event_id NEQ 0>
        <cfset event = entityLoadByPK("Event", variables.int_event_id)>
        <cfif isDefined("event")>
            <!-- Set event data to variables -->
            <cfset variables.str_event_title = event.getStr_event_title()>
            <cfset variables.str_description = event.getStr_description()>
            <cfset variables.dt_event_date = event.getDt_event_date()>
            <cfset variables.str_reminder_email = event.getStr_reminder_email()>
            <cfset variables.str_recurrence_type = event.getStr_recurrence_type()>
            <cfset variables.int_recurring_duration = event.getInt_recurring_duration()>
            <cfset variables.dt_start_time = event.getDt_start_time()>
            <cfset variables.dt_end_time = event.getDt_end_time()>
            <cfset variables.days_of_week = event.getDays_of_week()>
            <cfset variables.days_of_month = event.getDays_of_month()>
            <cfset variables.str_time_constraint = event.getStr_time_constraint()>
        </cfif>
    </cfif>
</cffunction>

<cffunction name="getFormValues" access="public" returntype="void">
    <cfset variables.str_event_title = structKeyExists(form, "str_event_title") ? trim(form.str_event_title) : "">
    <cfset variables.str_description = structKeyExists(form, "str_description") ? trim(form.str_description) : "">
    <cfset variables.str_reminder_email = structKeyExists(form, "str_reminder_email") ? trim(form.str_reminder_email) : "">
    <cfset variables.str_recurrence_type = structKeyExists(form, "str_recurrence_type") ? form.str_recurrence_type : "none">
    <cfset variables.int_recurring_duration = structKeyExists(form, "int_recurring_duration") AND isNumeric(form.int_recurring_duration) ? form.int_recurring_duration : 1>
    <cfset variables.dt_start_time = structKeyExists(form, "start_time") ? form.start_time : "00:00:00">
    <cfset variables.dt_end_time = structKeyExists(form, "end_time") ? form.end_time : "11:59:59">
    <cfset variables.dt_event_date = structKeyExists(form, "dt_event_date") ? form.dt_event_date : "">
    <cfset variables.days_of_week = structKeyExists(form, "days_of_week") ? form.days_of_week : "">
    <cfset variables.days_of_month = structKeyExists(form, "days_of_month") ? form.days_of_month : "">
    <cfset variables.str_time_constraint = structKeyExists(form, "str_time_constraint") ? form.str_time_constraint : "full_day">
</cffunction>

<cffunction name="validateFormValues" access="public" returntype="string">
    <cfset var strErrorMsg = "">

    <!-- Validate Event Title -->
    <cfif NOT len(variables.str_event_title)>
        <cfset strErrorMsg &= 'Event Title is required.<br>'>
    </cfif>

    <!-- Validate Description -->
    <cfif NOT len(variables.str_description)>
        <cfset strErrorMsg &= 'Description is required.<br>'>
    </cfif>

    <!-- Validate Event Date -->
    <cfif NOT structKeyExists(form, "dt_event_date") OR NOT len(trim(form.dt_event_date))>
        <cfset strErrorMsg &= 'Valid Event Date is required.<br>'>
    </cfif>

    <!-- Validate Reminder Email -->
    <cfif NOT REFindNoCase("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$", variables.str_reminder_email)>
        <cfset strErrorMsg &= 'Reminder Email is not valid.<br>'>
    </cfif>

    <!-- Validate Recurrence Duration -->
    <cfif NOT (isNumeric(variables.int_recurring_duration) AND variables.int_recurring_duration GTE 1)>
        <cfset strErrorMsg &= 'Recurrence Duration must be a number greater than or equal to 1.<br>'>
    </cfif>

    <!-- Validate Start Time only if "custom" is selected -->
    <cfif variables.str_time_constraint EQ "custom">
        <cfif NOT len(variables.dt_start_time)>
            <cfset strErrorMsg &= 'Start Time is required when custom time is selected.<br>'>
        </cfif>
    </cfif>

    <!-- Validate Days of Week -->
    <cfif variables.str_recurrence_type EQ "weekly" AND NOT len(variables.days_of_week)>
        <cfset strErrorMsg &= 'Days of Week are required when weekly recurrence is selected.<br>'>
    </cfif>

    <!-- Validate Days of Month -->
    <cfif variables.str_recurrence_type EQ "monthly" AND NOT len(variables.days_of_month)>
        <cfset strErrorMsg &= 'Days of Month are required when monthly recurrence is selected.<br>'>
    </cfif>

    <!-- Validate End Time only if "custom" is selected -->
    <cfif variables.str_time_constraint EQ "custom">
        <cfif NOT len(variables.dt_end_time)>
            <cfset strErrorMsg &= 'End Time is required when custom time is selected.<br>'>
        </cfif>
    </cfif>

    <!-- Return the accumulated error messages -->
    <cfreturn strErrorMsg>
</cffunction>

<cffunction name="saveOrUpdateEvent" access="public" returntype="string">
    <cfset var strSuccessMsg = "">
    <cftry>
        <cfif variables.int_event_id NEQ 0>
            <!-- Load the existing event using ORM -->
            <cfset event = entityLoadByPK("Event", variables.int_event_id)>
            <cfif isDefined("event")>
                <!-- Update the event properties -->
                <cfset event.setStr_event_title(variables.str_event_title)>
                <cfset event.setStr_description(variables.str_description)>
                <cfset event.setDt_event_date(variables.dt_event_date)>
                <cfset event.setStr_reminder_email(variables.str_reminder_email)>
                <cfset event.setStr_priority(variables.str_priority)>
                <cfset event.setStr_time_constraint(variables.str_time_constraint)>
                <cfset event.setDt_start_time(variables.dt_start_time)>
                <cfset event.setDt_end_time(variables.dt_end_time)>
                <cfset event.setDays_of_week(variables.days_of_week)>
                <cfset event.setDays_of_month(variables.days_of_month)>
                <cfset event.setStr_recurrence_type(variables.str_recurrence_type)>
                <cfset event.setInt_recurring_duration(variables.int_recurring_duration)>
                <!-- Save the updated event -->
                <cfset entitySave(event)>
                <cfset strSuccessMsg = "Event updated successfully.">
            </cfif>
        <cfelse>
            <!-- Create a new event using ORM -->
            <cfset event = entityNew("Event")>
            <cfset event.setStr_event_title(variables.str_event_title)>
            <cfset event.setStr_description(variables.str_description)>
            <cfset event.setDt_event_date(variables.dt_event_date)>
            <cfset event.setStr_reminder_email(variables.str_reminder_email)>
            <cfset event.setStr_priority(variables.str_priority)>
            <cfset event.setStr_time_constraint(variables.str_time_constraint)>
            <cfset event.setDt_start_time(variables.dt_start_time)>
            <cfset event.setDt_end_time(variables.dt_end_time)>
            <cfset event.setDays_of_week(variables.days_of_week)>
            <cfset event.setDays_of_month(variables.days_of_month)>
            <cfset event.setStr_recurrence_type(variables.str_recurrence_type)>
            <cfset event.setInt_recurring_duration(variables.int_recurring_duration)>
            <!-- Save the new event -->
            <cfset entitySave(event)>
            <cfset strSuccessMsg = "Event created successfully.">
        </cfif>
        <cfcatch type="any">
            <cfset strSuccessMsg = "Error: " & cfcatch.message>
        </cfcatch>
    </cftry>
    <cfreturn strSuccessMsg>
</cffunction>

<!-- Main processing logic -->
<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="../cfAddressbook/login.cfm">
</cfif>

<cfset setFormData()>

<cfif structKeyExists(form, "int_event_id")>
    <cfset getFormValues()>
    <!-- Validate the form values -->
    <cfset variables.strErrorMsg = validateFormValues()>
    <cfif NOT len(variables.strErrorMsg)>
        <cfset variables.strSuccessMsg = saveOrUpdateEvent()>
        <!-- Re-fetch the event details to ensure updated values are displayed -->
        <cfif len(variables.int_event_id)>
            <cfset setFormData()>
        </cfif>
    </cfif>
</cfif>