

<!-- Function to handle user login -->
<cffunction name="loginUser" access="public" returntype="void">
    <cfargument name="form" type="struct" required="true">
    <cfset datasource = "dsn_address_book">
    
    <!-- User login query with role validation -->
    <cfquery name="qryUser" datasource="#datasource#">
        SELECT 
            u.str_first_name, u.str_user_name, u.str_email, u.int_user_id, r.str_user_role, u.str_phone, u.cbr_status
        FROM 
            tbl_users u
        JOIN 
            tbl_user_roles r 
        ON 
            u.int_user_role_id = r.int_id
        WHERE 
            u.str_email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">
            AND u.str_password = <cfqueryparam value="#form.password#" cfsqltype="cf_sql_varchar">
            AND u.cbr_status = 'A'
            AND u.int_user_role_id = 2;
    </cfquery>
    
    <cfif qryUser.recordCount>
        <cfset session.user = {
            str_user_name = qryUser.str_user_name,
            str_first_name = qryUser.str_first_name,
            int_user_id = qryUser.int_user_id,
            str_email = qryUser.str_email,
            str_user_role = qryUser.str_user_role,
            str_phone = qryUser.str_phone,
            cbr_status = qryUser.cbr_status
        }>
        <cfset session.int_user_id = qryUser.int_user_id>
        <cfset session.str_user_name = qryUser.str_user_name> 
        <cfset redirectUser("user.cfm")> <!-- Redirect to user dashboard -->
    <cfelse>
        <cfset session.loginError = "Invalid login credentials or you do not have user access.">
        <cfset redirectUser("login.cfm")> <!-- Redirect back to login page -->
    </cfif>
</cffunction>

<!-- Function to handle redirection -->
<cffunction name="redirectUser" access="public" returntype="void">
    <cfargument name="url" type="string" required="true">
    <cflocation url="#arguments.url#">
</cffunction>

<cfif structKeyExists(form, "submit")>
    <cfset datasource="dsn_address_book">
    
    <!-- Call the login function -->
    <cfset loginUser(form)>
</cfif>