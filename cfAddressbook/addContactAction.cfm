<cffunction name="initializeForm" access="public" returntype="void">
    <cfset variables.datasource = "dsn_address_book">
     <!--- Set default values for adding a new contact --->
     <cfset variables.int_contact_id = 0> 
     <cfset variables.int_contact_id = "">
     <cfset variables.str_first_name = "">
     <cfset variables.str_last_name = "">
     <cfset variables.str_contact = "">
     <cfset variables.str_email = "">
     <cfset variables.int_qualification = "">
     <cfset variables.int_country = "">
     <cfset variables.str_city = "">
     <cfset variables.str_state = "">
     <cfset variables.str_address = "">
     <cfset variables.str_pincode = "">
     <cfset variables.str_gender = "">
     <cfset variables.str_languages = "">
     <cfset variables.responseMessage ="">
    <cfset variables.strErrorMsg = "">
    <cfset variables.strSuccessMsg = "">
    <cfset getQualifications()>
     <cfset getCountryNames()>
</cffunction>
<cffunction name="getQualifications" access="public" returntype="void">
    <!--- Fetch qualifications for dropdowns --->
    <cfquery name="variables.qryGetQualifications" datasource="#datasource#">
        SELECT int_qualification_id, str_qualification_name 
        FROM qualifications
        ORDER BY str_qualification_name ASC;
    </cfquery>
</cffunction>

<cffunction name="getCountryNames" access="public" returntype="void">
    <!--- Fetch country names for dropdowns --->
    <cfquery name="variables.qryGetCountries" datasource="#datasource#">
        SELECT int_country_id, str_country_name
        FROM countries
        ORDER BY str_country_name ASC;
    </cfquery>
</cffunction>

<cffunction name="getContactDetails" access="public" returntype="void">
        <!--- Fetch contact details for editing --->
        <cfquery name="contact" datasource="#datasource#">
            SELECT c.int_contact_id, c.str_first_name, c.str_last_name, c.str_contact, c.str_email, 
                   c.int_qualification, 
                   q.int_qualification_id, q.str_qualification_name, co.int_country_id, co.str_country_name, 
                   c.str_city, c.str_state, c.str_address, c.str_pincode, c.str_gender, c.str_languages,
                   c.int_country
            FROM contacts c
            LEFT JOIN qualifications q ON c.int_qualification = q.int_qualification_id
            LEFT JOIN countries co ON c.int_country = co.int_country_id
            WHERE c.int_contact_id = <cfqueryparam value="#url.int_contact_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        

        <!--- Check if a valid record is found --->
        <cfif contact.recordCount EQ 0>
            <cfset throw("No contact found with the provided ID.")>
        </cfif>

        <!--- Populate variables with existing contact data --->
        <cfset variables.int_contact_id = contact.int_contact_id>
        <cfset variables.str_first_name = contact.str_first_name>
        <cfset variables.str_last_name = contact.str_last_name>
        <cfset variables.str_contact = contact.str_contact>
        <cfset variables.str_email = contact.str_email>
        <cfset variables.int_qualification = contact.int_qualification>
        <cfset variables.int_country = contact.int_country>
        <cfset variables.str_city = contact.str_city>
        <cfset variables.str_state = contact.str_state>
        <cfset variables.str_address = contact.str_address>
        <cfset variables.str_pincode = contact.str_pincode>
        <cfset variables.str_gender = contact.str_gender>
        <cfset variables.str_languages = contact.str_languages>
    
       
    
</cffunction>


<cffunction name="getFormValues" access="public" returntype="void">
    
    <cfset variables.int_contact_id = structKeyExists(form, "int_contact_id") ? variables.int_contact_id : 0> 
    <cfset variables.str_first_name = trim(form.str_first_name)>
    <cfset variables.str_last_name = trim(form.str_last_name)>
    <cfset variables.str_contact = trim(form.str_contact)>
    <cfset variables.str_email = trim(form.str_email)>
    <cfset variables.int_qualification = structKeyExists(form, "int_qualification") ? form.int_qualification : "">
    <cfset variables.int_country = structKeyExists(form, "int_country") ? form.int_country : "">
    <cfset variables.str_city = trim(form.str_city)>
    <cfset variables.str_state = trim(form.str_state)>
    <cfset variables.str_address = trim(form.str_address)>
    <cfset variables.str_pincode = trim(form.str_pincode)>
    <cfset variables.str_gender = structKeyExists(form, "str_gender") ? form.str_gender : "">
    <cfset variables.str_languages = structKeyExists(form, "str_languages") ? form.str_languages : "">
    
</cffunction>

<cffunction name="validateForm" access="public" returntype="string">
    <cfset var strErrorMsg = "">
    <cfif not len(variables.str_first_name)>
        <cfset strErrorMsg &= 'Please enter your first name.<br>'>
    </cfif>
    <cfif not len(variables.str_last_name)>
        <cfset strErrorMsg &= 'Please enter your last name.<br>'>
    </cfif>
    <cfif not len(variables.str_contact)>
        <cfset strErrorMsg &= 'Please enter your contact number.<br>'> 
    </cfif>
    <cfif not len(variables.str_email)>
        <cfset strErrorMsg &= 'Please enter your email.<br>'>
    </cfif>
    <cfif not len(variables.int_qualification)>
        <cfset strErrorMsg &= 'Please select a qualification.<br>'>
    </cfif>
    <cfif not len(variables.int_country)>
        <cfset strErrorMsg &= 'Please select a country.<br>'>
    </cfif>
    <cfif not len(variables.str_city)>
        <cfset strErrorMsg &= 'Please enter your city.<br>'>
    </cfif>
    <cfif not len(variables.str_state)>
        <cfset strErrorMsg &= 'Please enter your state.<br>'>
    </cfif>
    <cfif not len(variables.str_address)>
        <cfset strErrorMsg &= 'Please enter your address.<br>'>
    </cfif>
    <cfif not len(variables.str_pincode)>
        <cfset strErrorMsg &= 'Please enter your pincode.<br>'>
    </cfif>
    <cfif not len(variables.str_gender)>
        <cfset strErrorMsg &= 'Please select a gender.<br>'>
    </cfif>
    <cfif not len(variables.str_languages)>
        <cfset strErrorMsg &= 'Please select at least one language.<br>'>
    </cfif>
    
    <cfreturn strErrorMsg>
</cffunction>

<cffunction name="saveOrUpdateContact" access="public" returntype="string">
    <cfargument name="int_contact_id" type="any" required="false"> <!--- Contact ID for updates --->
    <cfargument name="str_first_name" type="string" required="true">
    <cfargument name="str_last_name" type="string" required="true">
    <cfargument name="str_contact" type="string" required="true">
    <cfargument name="str_email" type="string" required="true">
    <cfargument name="int_qualification" type="numeric" required="true">
    <cfargument name="int_country" type="numeric" required="true">
    <cfargument name="str_city" type="string" required="true">
    <cfargument name="str_state" type="string" required="true">
    <cfargument name="str_address" type="string" required="true">
    <cfargument name="str_pincode" type="string" required="true">
    <cfargument name="str_gender" type="string" required="true">
    <cfargument name="str_languages" type="string" required="true">
    
    <cfset var responseMessage = "">
    <cfset var isEdit = structKeyExists(arguments, "int_contact_id") 
    AND arguments.int_contact_id NEQ 0 
    AND arguments.int_contact_id NEQ "" 
    AND isNumeric(arguments.int_contact_id)> 
    <cfif NOT isEdit>
        <!--- Add: Check for duplicate contact number --->
        <cfquery name="checkDuplicate" datasource="#variables.datasource#">
            SELECT str_contact 
            FROM contacts
            WHERE str_contact = <cfqueryparam value="#arguments.str_contact#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif checkDuplicate.recordcount EQ 0>
            <!--- Proceed with insert if no duplicate --->
            <cfquery datasource="#variables.datasource#">
                INSERT INTO contacts (
                    str_first_name, str_last_name, str_contact, str_email, 
                    int_qualification, int_country, str_city, str_state, 
                    str_address, str_pincode, str_gender, str_languages
                ) VALUES (
                    <cfqueryparam value="#arguments.str_first_name#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.str_last_name#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.str_contact#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.str_email#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.int_qualification#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.int_country#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.str_city#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.str_state#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.str_address#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.str_pincode#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.str_gender#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.str_languages#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
            <cfset responseMessage = "Contact added successfully!">
        <cfelse>
            <cfset responseMessage = "Contact number already exists!">
        </cfif>
    <cfelse>
        <cfquery datasource="#variables.datasource#" >
            UPDATE contacts
            SET 
                str_first_name = <cfqueryparam value="#arguments.str_first_name#" cfsqltype="cf_sql_varchar" maxlength="50">,
                str_last_name = <cfqueryparam value="#arguments.str_last_name#" cfsqltype="cf_sql_varchar" maxlength="50">,
                str_contact = <cfqueryparam value="#arguments.str_contact#" cfsqltype="cf_sql_varchar" maxlength="15">,
                str_email = <cfqueryparam value="#arguments.str_email#" cfsqltype="cf_sql_varchar" maxlength="100">,
                int_qualification = <cfqueryparam value="#arguments.int_qualification#" cfsqltype="cf_sql_integer">,
                int_country = <cfqueryparam value="#arguments.int_country#" cfsqltype="cf_sql_integer">,
                str_city = <cfqueryparam value="#arguments.str_city#" cfsqltype="cf_sql_varchar" maxlength="100">,
                str_state = <cfqueryparam value="#arguments.str_state#" cfsqltype="cf_sql_varchar" maxlength="100">,
                str_address = <cfqueryparam value="#arguments.str_address#" cfsqltype="cf_sql_varchar" maxlength="255">,
                str_pincode = <cfqueryparam value="#arguments.str_pincode#" cfsqltype="cf_sql_varchar" maxlength="10">,
                str_gender = <cfqueryparam value="#arguments.str_gender#" cfsqltype="cf_sql_varchar" maxlength="10">,
                str_languages = <cfqueryparam value="#arguments.str_languages#" cfsqltype="cf_sql_varchar" maxlength="255">
            WHERE int_contact_id = <cfqueryparam value="#arguments.int_contact_id#" cfsqltype="cf_sql_integer"> <!--- Ensure this is valid ---> 
        </cfquery>
        <cfset responseMessage = "Contact updated successfully!">
    </cfif>

    <cfreturn responseMessage>
</cffunction>


<!--- Main processing logic --->
<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="login.cfm">
</cfif>

<!--- Initialize the form when the page loads --->
<cfset initializeForm()>

<cfif structKeyExists(url, "int_contact_id")>
    <cfset getContactDetails()>
</cfif>
<cfif structKeyExists(form, "btn-submit")>
    <!--- Get form values when the submit button is pressed --->
    <cfset getFormValues()>
    
    <!--- Validate the form values --->
    <cfset variables.strErrorMsg = validateForm()>
    
    <cfif NOT len(variables.strErrorMsg)>
        <!--- Save or update the contact based on the form submission --->
        <cfset variables.strSuccessMsg = saveOrUpdateContact(
            variables.int_contact_id,
            variables.str_first_name,
            variables.str_last_name,
            variables.str_contact,
            variables.str_email,
            variables.int_qualification,
            variables.int_country,
            variables.str_city,
            variables.str_state,
            variables.str_address,
            variables.str_pincode,
            variables.str_gender,
            variables.str_languages
        )>
        
        <!--- After saving, re-fetch the contact details to ensure the form is populated correctly --->
        <cfif variables.int_contact_id NEQ 0>
            <cfset getContactDetails()>
        </cfif>
    </cfif>
</cfif>