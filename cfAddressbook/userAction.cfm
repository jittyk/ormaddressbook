    <!-- ColdFusion Query to Fetch Events -->
    <cfquery name="todayEvents" datasource="dsn_address_book">
        SELECT str_event_title, str_description, dt_event_date, str_priority 
        FROM tbl_events
        WHERE CAST(dt_event_date AS DATE) = <cfqueryparam value="#dateFormat(Now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
        ORDER BY dt_event_date ASC, str_priority ASC
    </cfquery>
