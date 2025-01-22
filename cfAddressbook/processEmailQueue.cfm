<cffunction name="getPendingEmails" returntype="query">
    <cfquery name="getPendingEmails" datasource="dsn_address_book">
        SELECT id, recipient_email, subject, body
        FROM email_queue
        WHERE is_sent = 0
        ORDER BY created_at ASC
        LIMIT 10
    </cfquery>
    <cfreturn getPendingEmails>
</cffunction>

<cffunction name="sendEmail" returntype="void">
    <cfargument name="recipient" type="string" required="true">
    <cfargument name="subject" type="string" required="true">
    <cfargument name="body" type="string" required="true">
    
    <cfmail to="#arguments.recipient#" from="noreply@yourdomain.com" subject="#arguments.subject#" server="your.smtp.server.com">
        #arguments.body#
    </cfmail>
</cffunction>

<cffunction name="updateEmailStatus" returntype="void">
    <cfargument name="emailId" type="numeric" required="true">
    
    <cfquery datasource="dsn_address_book">
        UPDATE email_queue
        SET is_sent = 1, sent_at = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
        WHERE id = <cfqueryparam value="#arguments.emailId#" cfsqltype="cf_sql_integer">
    </cfquery>
</cffunction>
<!---main logic--->
<cfset pendingEmails = getPendingEmails()>

<cfloop query="pendingEmails">
    <cftry>
        sendEmail(pendingEmails.recipient_email, pendingEmails.subject, pendingEmails.body);
        
        <!-- Mark email as sent after successful delivery -->
        updateEmailStatus(pendingEmails.id);
    <cfcatch>
        <!-- Log the error, and leave the email in the queue to retry later -->
        <cflog file="email_errors" text="Failed to send email to #pendingEmails.recipient_email#: #cfcatch.message#">
    </cfcatch>
    </cftry>
</cfloop>
