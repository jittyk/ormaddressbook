<!-- Function to check if the user is logged in -->
<cffunction name="checkLogin" access="public" returntype="void">
    <cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
        <cflocation url="login.cfm">
    </cfif>
</cffunction>


<!-- Function to delete an event by ID -->
<cffunction name="deleteEvent" access="public" returntype="void">
    <cfif structKeyExists(form, "eventId")>
        <cfquery datasource="dsn_address_book">
            DELETE FROM tbl_events
            WHERE int_event_id = <cfqueryparam value="#form.eventId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset variables.message = "Event deleted successfully!">
    </cfif>
</cffunction>

<!-- Function to fetch the updated list of events -->
<cffunction name="getEvents" access="public" returntype="query">
    <cfquery name="getEvents" datasource="dsn_address_book">
        SELECT int_event_id, str_event_title, dt_event_date, str_priority
        FROM tbl_events
        ORDER BY dt_event_date ASC
    </cfquery>
    <cfreturn getEvents>
</cffunction>

<!-- Main Logic Execution -->

<cfset checkLogin()>
<cfset deleteEvent()>
<cflocation url="eventManager.cfm">
