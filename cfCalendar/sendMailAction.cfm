<cfset datasource="dsn_address_book">
<cfset currentDate = Now()>

<!--- Function to retrieve events --->
<cffunction name="getUpcomingEvents" returntype="query">
    <cfquery name="getEvents" datasource="#datasource#">
        SELECT 
            int_event_id, 
            str_event_title, 
            str_description, 
            dt_event_date, 
            str_reminder_email, 
            str_priority, 
            dt_start_time, 
            dt_end_time, 
            bit_mail_sent 
        FROM tbl_events
        WHERE dt_event_date = DATE_ADD(CURDATE(), INTERVAL 1 DAY)
        AND bit_mail_sent = 0
        ORDER BY dt_event_date
    </cfquery>
    <cfreturn getEvents>
</cffunction>

<!--- Function to send email --->
<cffunction name="sendReminderEmail" returntype="boolean">
    <cfargument name="event" type="query">
    <cftry>
        <cfset var formattedStartTime = timeFormat(arguments.event.dt_start_time, "HH:mm:ss")>
        <cfset var formattedEndTime = timeFormat(arguments.event.dt_end_time, "HH:mm:ss")>
 
        <cfmail from="jitty.abraham@techversantinfotech.com" 
                to="#arguments.event.str_reminder_email#" 
                subject="Reminder: Upcoming Event - #arguments.event.str_event_title#">
                    This is a reminder for your upcoming event titled "#arguments.event.str_event_title#".<br><br>
                    Description: #arguments.event.str_description#<br>
                    Priority: #arguments.event.str_priority#<br>
                    Start Time: #formattedStartTime#<br>
                    End Time: #formattedEndTime#<br>    
        </cfmail>
        <cfset logEmailStatus(event=arguments.event, status="sent")>
        <cfreturn true>
    <cfcatch type="any">
        <cfset logEmailFailure(event=arguments.event)>
        <cfreturn false>
    </cfcatch>
    </cftry>
</cffunction>

<!--- Function to update mail sent flag --->
<cffunction name="updateMailSentStatus" returntype="void">
    <cfargument name="eventId" type="numeric">
    <cfquery datasource="#datasource#">
        UPDATE tbl_events 
        SET bit_mail_sent = 1 
        WHERE int_event_id = <cfqueryparam value="#arguments.eventId#" cfsqltype="cf_sql_integer">
    </cfquery>
</cffunction>

<!--- Function to log email failure --->
<cffunction name="logEmailFailure" returntype="void">
    <cfargument name="event" type="query">
    <cfquery datasource="#datasource#">
        INSERT INTO tbl_email_log (int_event_id, str_recipient_email, str_subject, str_status, dt_sent)
        VALUES (
            <cfqueryparam value="#arguments.event.int_event_id#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#arguments.event.str_reminder_email#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="Reminder: Upcoming Event - #arguments.event.str_event_title#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="failed" cfsqltype="cf_sql_varchar">,
            NOW()
        )
    </cfquery>
</cffunction>

<!--- Function to log email status --->
<cffunction name="logEmailStatus" returntype="void">
    <cfargument name="event" type="query">
    <cfargument name="status" type="string">
    <cfquery datasource="#datasource#">
        INSERT INTO tbl_email_log (int_event_id, str_recipient_email, str_subject, str_status, dt_sent)
        VALUES (
            <cfqueryparam value="#arguments.event.int_event_id#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#arguments.event.str_reminder_email#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="Reminder: Upcoming Event - #arguments.event.str_event_title#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,
            NOW()
        )
    </cfquery>
</cffunction>

<!--- Main logic --->
<cfset events = getUpcomingEvents()>

<cfloop query="events">
    <cfif sendReminderEmail(event=events)>
        <cfset updateMailSentStatus(eventId=events.int_event_id)>
    <cfelse>
        <cfset logEmailFailure(event=events)>
    </cfif>
</cfloop>
