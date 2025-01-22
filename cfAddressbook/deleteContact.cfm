<!-- Function to check if the user is logged in -->
<cffunction name="checkLogin" access="public" returntype="void">
    <cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
        <cflocation url="login.cfm">
    </cfif>
</cffunction>

<!-- Function to check if the user has permission to delete -->
<cffunction name="checkPermission" access="public" returntype="void">
    <cfif not listFind(session.permissionList, 3)>
        <cflocation url="contact.cfm">
    </cfif>
</cffunction>

<!-- Function to delete a contact by ID -->
<cffunction name="deleteContact" access="public" returntype="void">
    <cfif structKeyExists(url, "int_contact_id")>
        <cfquery datasource="dsn_address_book">
            DELETE FROM contacts
            WHERE int_contact_id = <cfqueryparam value="#url.int_contact_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset message = "Contact deleted successfully!">
    </cfif>
</cffunction>

<!-- Function to fetch the updated list of contacts -->
<cffunction name="getContacts" access="public" returntype="query">
    <cfquery name="getContacts" datasource="dsn_address_book">
        SELECT int_contact_id, str_first_name, str_last_name, str_email, int_contact
        FROM contacts
        ORDER BY str_first_name ASC
    </cfquery>
    <cfreturn getContacts>
</cffunction>

<!-- Main Logic Execution -->

<!-- Call the checkLogin function -->
<cfset checkLogin()>

<!-- Call the checkPermission function -->
<cfset checkPermission()>

<!-- Call the deleteContact function -->
<cfset deleteContact()>

<!-- Fetch the updated contact list -->
<cfset contactList = getContacts()>

<!-- Redirect to the contact page -->
<cflocation url="contact.cfm">
