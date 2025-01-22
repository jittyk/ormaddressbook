<cfcomponent persistent="true" table="tbl_events">
    <cfproperty name="int_event_id" fieldtype="id" generator="native">
    <cfproperty name="str_event_title" >
    <cfproperty name="str_description" >
    <cfproperty name="str_reminder_email" >
    <cfproperty name="str_priority" >
    <cfproperty name="str_time_constraint" >
    <cfproperty name="dt_start_time" >
    <cfproperty name="dt_end_time" >
    <cfproperty name="bit_mail_sent" >
    <cfproperty name="dt_event_date" >
    <cfproperty name="days_of_week" >
    <cfproperty name="days_of_month" >
    <cfproperty name="str_recurrence_type" >
    <cfproperty name="int_recurring_duration" >
    <cfproperty name="str_recurring" >

    <!--- Method to convert day name to integer --->
    <cffunction name="getDayOfWeekInteger" access="public" returntype="numeric">
        <cfargument name="dayName" type="string" required="true">
        
        <cfset var dayMapping = {
            "Sunday": 1,
            "Monday": 2,
            "Tuesday": 3,
            "Wednesday": 4,
            "Thursday": 5,
            "Friday": 6,
            "Saturday": 7
        }>
        
        <cfreturn dayMapping[trim(arguments.dayName)]>
    </cffunction>

    <!---<cffunction name="test" returntype="any" access="remote">
        <cfdump var="hei " abort>
    </cffunction>

    <!--- Getter for formatted event date --->
    <cffunction name="getFormattedEventDate" access="public" returntype="string">
        <cfreturn DateFormat(dt_event_date, 'yyyy-mm-dd')>
    </cffunction>--->
</cfcomponent> 


