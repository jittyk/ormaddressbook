
<!--- Function to validate admin login --->
<cffunction name="validateAdminLogin" access="public" returntype="struct">
    <cfargument name="email" type="string" required="true">
    <cfargument name="password" type="string" required="true">
    <cfargument name="datasource" type="string" required="true">
    
    <cfset var result = structNew()>
    <cfset var qryAdmin = "">
    
    <!--- Query to authenticate admin login --->
    <cfquery name="qryAdmin" datasource="#arguments.datasource#">
        SELECT 
            u.int_user_id AS str_user_id, 
            u.str_user_name AS str_user_name,
            u.str_email, 
            u.str_password
        FROM tbl_users u
        JOIN tbl_user_roles r 
            ON u.int_user_role_id = r.int_id
        WHERE 
            u.str_email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
            AND u.str_password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">
            AND u.cbr_status = 'A'
            AND r.str_user_role = 'admin'
    </cfquery>
    
    <cfif qryAdmin.recordCount>
        <cfset result.isValid = true>
        <cfset result.userId = qryAdmin.str_user_id>
        <cfset result.userName = qryAdmin.str_user_name>
    <cfelse>
        <cfset result.isValid = false>
        <cfset result.errorMessage = "Invalid login credentials or you do not have admin access.">
    </cfif>
    
    <cfreturn result>
</cffunction>

<!--- Function to handle redirection --->
<cffunction name="redirectTo" access="public" returntype="void">
    <cfargument name="url" type="string" required="true">
    <cflocation url="#arguments.url#">
</cffunction>


<!-- Admin Login Validation -->
<cfif structKeyExists(form, "submit")>
    <cfset datasource="dsn_address_book">
    <cfset loginResult = validateAdminLogin(form.email, form.password, datasource)>
    
    <cfif loginResult.isValid>
        <!--- Assign session variables --->
        <cfset session.int_admin_id = loginResult.userId>
        <cfset session.str_admin_user_name = loginResult.userName>
        
        <!--- Redirect to admin page if login is successful --->
        <cfset redirectTo("admin.cfm")>
    <cfelse>
        <!--- Set an error message in session and redirect back to login page if login fails --->
        <cfset session.str_login_error = loginResult.errorMessage>
        <cfset redirectTo("adminLogin.cfm")>
    </cfif>
</cfif>
