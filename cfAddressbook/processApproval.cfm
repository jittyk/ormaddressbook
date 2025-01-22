<cfif structKeyExists(form, "userId")>
    <!-- Log the received permissions to check if they are correctly passed -->
    <cfset permissionList = form.permissions>
    <cflog file="approval_process" text="Permissions received: #permissionList#">
    
    <!-- Get the user ID from the form -->
    <cfset userId = form.userId>

    <!-- Start a transaction to ensure atomicity of the updates -->
    <cftransaction>

        <!-- Update User Status to Approved -->
        <cfquery datasource="dsn_address_book">
            UPDATE tbl_users
            SET cbr_status = 'A'  <!-- 'A' stands for Approved -->
            WHERE intUserId = <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!-- Remove existing permissions for the user -->
        <cfquery datasource="dsn_address_book">
            DELETE FROM tbl_user_permissions
            WHERE user_id = <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!-- Combine all selected permissions into a comma-separated list -->
        <cfset permissionsList = arrayToList(form.permissions, ",")>

        <!-- Insert the combined permissions for the user -->
        <cfquery datasource="dsn_address_book">
            INSERT INTO tbl_user_permissions (user_id, permissions)
            VALUES (
                <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#permissionsList#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>

    </cftransaction> <!-- Commit all queries within the transaction -->

    <!-- Redirect to the Admin Page -->
    <cflocation url="admin.cfm">
</cfif>
