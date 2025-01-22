<!--- Event Component --->
<component persistent="yes" table="tbl_events" entityname="Event">
  <property name="int_event_id" fieldtype="id" generator="native">
  <property name="str_event_title" fieldtype="string">
  <property name="str_description" fieldtype="string">
  <property name="str_reminder_email" fieldtype="string">
  <property name="str_priority" fieldtype="string">
  <property name="str_time_constraint" fieldtype="string">
  <property name="dt_start_time" fieldtype="dateTime">
  <property name="dt_end_time" fieldtype="dateTime">
  <property name="bit_mail_sent" fieldtype="boolean">
  <property name="dt_event_date" column="dt_event_date" type="date">
  <property name="days_of_week" fieldtype="string">
  <property name="days_of_month" fieldtype="string">
  <property name="str_recurrence_type" fieldtype="string">
  <property name="int_recurring_duration" fieldtype="numeric">
  <property name="str_recurring" fieldtype="string">


<cffunction name="getDayOfWeekInteger" access="public" returntype="numeric">
    <cfargument name="day" type="string" required="true">
    
    <cfset var dayOfWeekMap = {
        "Sunday": 1,
        "Monday": 2,
        "Tuesday": 3,
        "Wednesday": 4,
        "Thursday": 5,
        "Friday": 6,
        "Saturday": 7
    }>
    
    <cfif structKeyExists(dayOfWeekMap, arguments.day)>
        <cfreturn dayOfWeekMap[arguments.day]>
    <cfelse>
        <cfreturn 0> <!--- Return 0 if the day is not valid --->
    </cfif>
</cffunction>
</component>