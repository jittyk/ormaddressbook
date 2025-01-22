

<cffunction name="signUpUser" access="public" returntype="void">
    <cfargument name="form" type="struct" required="true">

    <!--- Check if email already exists ---> 
    <cfquery name="checkEmail" datasource="dsn_address_book">
        SELECT COUNT(*) AS emailCount
        FROM tbl_users
        WHERE str_email = <cfqueryparam value="#arguments.form.email#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif checkEmail.emailCount GT 0>
        <!--- Email already exists ---> 
        <div class="message danger">This email is already registered. Please try another one.</div>
    <cfelse>
        <!--- Insert new user with role_id = 2 (user) and status = 'P' (pending) ---> 
        <cfquery name="insertUser" datasource="dsn_address_book">
            INSERT INTO tbl_users (str_first_name, str_phone, str_user_name, str_email, str_password, int_user_role_id, cbr_status)
            VALUES (
                <cfqueryparam value="#arguments.form.name#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.form.phone#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.form.username#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.form.email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.form.password#" cfsqltype="cf_sql_varchar">,
                2,
                'P' 
            )
        </cfquery>

        <!--- Show success message ---> 
        <div class="message success">Your account has been created successfully. Please wait for approval.</div>
    </cfif>
</cffunction>

<cfif structKeyExists(form, "submit")>
    <cfset signUpUser(form)>
</cfif>