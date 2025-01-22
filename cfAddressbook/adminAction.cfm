<cfset datasource="dsn_address_book">

<!--- Utility Functions --->
<cffunction name="validateSession" access="public" returnType="void">
    <cfif not structKeyExists(session, "int_admin_id") or session.int_admin_id EQ "" or session.int_admin_id IS 0>
        <cflocation url="adminLogin.cfm">
    </cfif>
</cffunction>

<!--- Permissions Functions --->
<cffunction name="getAllPermissions" access="public" returnType="query">
    <cfquery name="qryAllPermissions" datasource="#datasource#">
        SELECT int_permission_id, str_permission_name
        FROM tbl_permissions
    </cfquery>
    <cfreturn qryAllPermissions>
</cffunction>

<cffunction name="getUserPermissions" access="public" returnType="query">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfquery name="qryUserPermissions" datasource="#datasource#">
        SELECT int_permission_id
        FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn qryUserPermissions>
</cffunction>

<!--- User Status Functions --->
<cffunction name="updateUserStatus" access="public" returnType="void">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfargument name="status" type="string" required="true">
    <cfquery datasource="#datasource#">
        UPDATE tbl_users
        SET cbr_status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
    </cfquery>
</cffunction>

<cffunction name="getCurrentPermissions" access="public" returnType="query">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfquery name="qryCurrentPermissions" datasource="#datasource#">
        SELECT int_permission_id
        FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn qryCurrentPermissions>
</cffunction>

<cffunction name="deletePermission" access="public" returnType="void">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfargument name="int_permission_id" type="numeric" required="true">
    <cfquery datasource="#datasource#">
        DELETE FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
        AND int_permission_id = <cfqueryparam value="#arguments.int_permission_id#" cfsqltype="cf_sql_integer">
    </cfquery>
</cffunction>

<cffunction name="addPermission" access="public" returnType="void">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfargument name="int_permission_id" type="numeric" required="true">
    <cfquery datasource="#datasource#">
        INSERT INTO tbl_user_permissions (int_user_id, int_permission_id)
        VALUES (
            <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#arguments.int_permission_id#" cfsqltype="cf_sql_integer">
        )
    </cfquery>
</cffunction>

<cffunction name="checkPermissionExistence" access="public" returnType="numeric">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfargument name="int_permission_id" type="numeric" required="true">
    <cfquery name="qryCheckExistence" datasource="#datasource#">
        SELECT COUNT(int_user_id) AS Count
        FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
        AND int_permission_id = <cfqueryparam value="#arguments.int_permission_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn qryCheckExistence.Count>
</cffunction>

<!--- User Count Function --->
<cffunction name="getTotalUsersCount" access="public" returnType="numeric">
    <cfargument name="searchKey" type="string" required="false" default="">
    <cfquery name="qryCount" datasource="#datasource#">
        SELECT COUNT(int_user_id) AS totalUsers
        FROM tbl_users
        WHERE int_user_role_id != 1
        <cfif len(trim(arguments.searchKey)) GT 0>
            AND (
                str_email LIKE <cfqueryparam value="%#trim(arguments.searchKey)#%" cfsqltype="cf_sql_varchar"> OR
                str_user_name LIKE <cfqueryparam value="%#trim(arguments.searchKey)#%" cfsqltype="cf_sql_varchar"> OR
                str_phone LIKE <cfqueryparam value="%#trim(arguments.searchKey)#%" cfsqltype="cf_sql_varchar"> OR
                str_first_name LIKE <cfqueryparam value="%#trim(arguments.searchKey)#%" cfsqltype="cf_sql_varchar">
            )
        </cfif>
    </cfquery>
    <cfreturn qryCount.totalUsers>
</cffunction>

<!--- Data Fetching Functions --->
<cffunction name="fetchUsers" access="public" returnType="query">
    <cfargument name="searchKey" type="string" required="false" default="">
    <cfargument name="recordsPerPage" type="numeric" required="true">
    <cfargument name="startRecord" type="numeric" required="true">
    <cfquery name="qryUsers" datasource="#datasource#">
        SELECT int_user_id, str_email, str_user_name, str_phone, str_first_name, cbr_status
        FROM tbl_users
        WHERE int_user_role_id != 1
        <cfif len(trim(arguments.searchKey)) GT 0>
            AND (
                str_email LIKE <cfqueryparam value="%#trim(arguments.searchKey)#%" cfsqltype="cf_sql_varchar"> OR
                str_user_name LIKE <cfqueryparam value="%#trim(arguments.searchKey)#%" cfsqltype="cf_sql_varchar"> OR
                str_phone LIKE <cfqueryparam value="%#trim(arguments.searchKey)#%" cfsqltype="cf_sql_varchar"> OR
                str_first_name LIKE <cfqueryparam value="%#trim(arguments.searchKey)#%" cfsqltype="cf_sql_varchar">
            )
        </cfif>
        ORDER BY int_user_id
        LIMIT <cfqueryparam value="#arguments.recordsPerPage#" cfsqltype="cf_sql_integer">
        OFFSET <cfqueryparam value="#arguments.startRecord#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn qryUsers>
</cffunction>

<!--- Main Logic --->
<cfset validateSession()>
<cfset qrygetAllPermissions = getAllPermissions()>

<cfif structKeyExists(form, "action")>
    <cfswitch expression="#form.action#">
        <cfcase value="updateStatus">
            <cfif structKeyExists(form, "int_user_id") AND structKeyExists(form, "status") AND (form.status EQ "A" OR form.status EQ "I")>
                <cfset updateUserStatus(form.int_user_id, form.status)>
                <cflocation url="admin.cfm">
            </cfif>
        </cfcase>

        <cfcase value="updatePermissions">
            <cfif structKeyExists(form, "permissions") AND structKeyExists(form, "int_user_id")>
                <cfset qryCurrentPermissions = getCurrentPermissions(form.int_user_id)>
                <cfset updatedPermissionsList = isArray(form.permissions) ? arrayToList(form.permissions, ",") : form.permissions>
                <!-- Remove and add permissions -->
                <cfloop query="qryCurrentPermissions">
                    <cfif NOT listFind(updatedPermissionsList, qryCurrentPermissions.int_permission_id)>
                        <cfset deletePermission(form.int_user_id, qryCurrentPermissions.int_permission_id)>
                    </cfif>
                </cfloop>
                <cfloop list="#updatedPermissionsList#" index="int_permission_id">
                    <cfif checkPermissionExistence(form.int_user_id, int_permission_id) EQ 0>
                        <cfset addPermission(form.int_user_id, int_permission_id)>
                    </cfif>
                </cfloop>
                <cflocation url="admin.cfm">
            </cfif>
        </cfcase>
    </cfswitch>
</cfif>

<!--- Fetch and display users for the current page --->
<cfset recordsPerPage = 5>
<cfset currentPage = structKeyExists(url, "page") ? url.page : 1>
<cfset startRecord = (currentPage - 1) * recordsPerPage>

<cfif structKeyExists(form, "searchKey")>
    <cfset totalUsers = getTotalUsersCount(form.searchKey)>
    <cfset qryUsers = fetchUsers(form.searchKey, recordsPerPage, startRecord)>
<cfelse>
    <cfset totalUsers = getTotalUsersCount("")>
    <cfset qryUsers = fetchUsers("", recordsPerPage, startRecord)>
</cfif>