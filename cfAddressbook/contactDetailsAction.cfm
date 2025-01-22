<!-- Function to check user session -->
<cffunction name="checkSession" returnType="void">
    <cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
        <cflocation url="login.cfm">
    </cfif>
</cffunction>

<!-- Function to check user permissions -->
<cffunction name="checkPermissions" returnType="void">
    <cfif not listFind(session.permissionList, 1)>
        <cflocation url="contact.cfm">
    </cfif>
</cffunction>

<!-- Function to fetch contact details -->
<cffunction name="getContactDetails" returnType="query">
    <cfargument name="contactId" type="numeric" required="true" default="0">
    <cfquery name="contactDetails" datasource="dsn_address_book">
        SELECT 
            int_contact_id, 
            str_first_name, 
            str_last_name, 
            str_contact, 
            str_email, 
            int_qualification, 
            int_country, 
            str_city, 
            str_state, 
            str_address, 
            str_pincode, 
            str_gender, 
            str_languages
        FROM contacts
        WHERE int_contact_id = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn contactDetails>
</cffunction>



<!--main logic-->
<cfset checkSession()>

<cfset checkPermissions()>

<cfparam name="int_contact_id" default="0">

<cfset variables.contactDetails = getContactDetails(contactId=int_contact_id)>
