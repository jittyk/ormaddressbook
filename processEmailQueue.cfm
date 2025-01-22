<cfquery name="getPendingEmails" datasource="dsn_address_book">
    SELECT id, recipient_email, subject, body
    FROM email_queue
    WHERE is_sent = 0
    ORDER BY created_at ASC
    LIMIT 10
</cfquery>

<cfloop query="getPendingEmails">
    <cftry>
        <cfmail to="#getPendingEmails.recipient_email#" from="noreply@yourdomain.com" subject="#getPendingEmails.subject#" server="your.smtp.server.com">
            #getPendingEmails.body#
        </cfmail>

        <!-- Mark email as sent after successful delivery -->
        <cfquery datasource="dsn_address_book">
            UPDATE email_queue
            SET is_sent = 1, sent_at = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
            WHERE id = <cfqueryparam value="#getPendingEmails.id#" cfsqltype="cf_sql_integer">
        </cfquery>
    <cfcatch>
        <!-- Log the error, and leave the email in the queue to retry later -->
        <cflog file="email_errors" text="Failed to send email to #getPendingEmails.recipient_email#: #cfcatch.message#">
    </cfcatch>
    </cftry>
</cfloop>
