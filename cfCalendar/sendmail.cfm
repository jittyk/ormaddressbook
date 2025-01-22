<cfinclude template="sendMailAction.cfm">
<cfoutput>
    <cftry>
        <cfif getEvents.recordCount GT 0>
            <cfloop query="getEvents">
                <cfif  bit_mail_sent EQ 0>
                    <p>Error sending email to #getEvents.str_reminder_email#: #cfcatch.message#</p>
                </cfif> 
            </cfloop>
            <p>Reminder emails processed successfully!</p>
        <cfelse>
            <p>No upcoming events to send reminders for.</p>
        </cfif>

        <cfcatch type="any">
            <p>Error processing events: #cfcatch.message#</p>
            <p>Error detail: #cfcatch.detail#</p>
            <p>Error type: #cfcatch.type#</p>
        </cfcatch>
    </cftry>
</cfoutput>
