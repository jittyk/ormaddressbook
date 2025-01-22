

<!-- Function Definitions -->
<cffunction name="checkUserExists" access="public" returntype="numeric">
    <cfargument name="email" type="string" required="true">
    <cfargument name="datasource" type="string" required="true">
    <cfset var userId = "">
    
    <cfquery name="userCheck" datasource="#arguments.datasource#">
        SELECT int_user_id FROM tbl_users WHERE str_email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
    </cfquery>
    
    <cfif userCheck.recordCount eq 1>
        <cfset userId = userCheck.int_user_id>
    </cfif>
    
    <cfreturn userId>
</cffunction>

<cffunction name="generateResetToken" access="public" returntype="string">
    <cfreturn createUUID()>
</cffunction>

<cffunction name="getTokenExpiry" access="public" returntype="string">
    <cfset var tokenExpiry = DateAdd("h", 1, Now())>
    <cfreturn DateFormat(tokenExpiry, "yyyy-mm-dd") & " " & TimeFormat(tokenExpiry, "HH:mm:ss")>
</cffunction>

<cffunction name="updateUserToken" access="public" returntype="void">
    <cfargument name="email" type="string" required="true">
    <cfargument name="resetToken" type="string" required="true">
    <cfargument name="tokenExpiry" type="string" required="true">
    <cfargument name="datasource" type="string" required="true">
    
    <cfquery datasource="#arguments.datasource#">
        UPDATE tbl_users
        SET reset_token = <cfqueryparam value="#arguments.resetToken#" cfsqltype="cf_sql_varchar">,
            token_expiry = <cfqueryparam value="#arguments.tokenExpiry#" cfsqltype="cf_sql_timestamp">
        WHERE str_email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
    </cfquery>
</cffunction>

<cffunction name="insertEmailQueue" access="public" returntype="void">
    <cfargument name="email" type="string" required="true">
    <cfargument name="resetToken" type="string" required="true">
    <cfargument name="datasource" type="string" required="true">
    
    <cfquery datasource="#arguments.datasource#">
        INSERT INTO email_queue (recipient_email, subject, body, status, created_date)
        VALUES (
            <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="Password Reset Request" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="Click the link to reset your password: <a href='resetPassword.cfm?token=#arguments.resetToken#'>Reset Password</a>" cfsqltype="cf_sql_longvarchar">,
            <cfqueryparam value="pending" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
        )
    </cfquery>
</cffunction>

 <!-- Initialize err_msg at the start -->
 <cfset err_msg = "">
<cfif structKeyExists(form, "submit")>
    <cfset str_email = trim(form.str_email)>
   
    <cfset datasource="dsn_address_book">

    <cfset userId = checkUserExists(str_email, datasource)>
    <cfif userId neq "">
        <cfset resetToken = generateResetToken()>
        <cfset tokenExpiryFormatted = getTokenExpiry()>
        
        <cfset updateUserToken(str_email, resetToken, tokenExpiryFormatted, datasource)>
        <cfset insertEmailQueue(str_email, resetToken, datasource)>
        
        <cfset err_msg = "A password reset link has been sent to your email address.">
    <cfelse>
        <cfset err_msg = "The email address you entered does not exist in our system.">
    </cfif>
</cfif>