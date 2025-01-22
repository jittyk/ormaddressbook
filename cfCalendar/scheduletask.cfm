<cfset datasource="dsn_address_book">

<cffunction name="schedulejobs" access="public" returntype="void">
    <cfargument name="dt_run_date" type="date">
    
    <cfquery datasource="#datasource#">
        INSERT INTO tbl_events_schedule(dt_run_date)
        VALUES (
            <cfqueryparam value="#dt_run_date#" cfsqltype="cf_sql_date">
        )
    </cfquery>
</cffunction>

<cfset schedulejobs(dt_run_date = now())>
