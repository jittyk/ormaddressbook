<cfif structKeyExists(form, "firstname")>
    
    <cfset datasourceName = "dsn_address_book">  

    <!--- Prepare variables for insertion --->
    <cfset languagesArray = []>

    <!--- Check if languages were selected --->
    <cfif structKeyExists(form, "languages")>
        <cfset languagesArray = form.languages>
    </cfif>

    <!--- Check if gender is selected --->
    <cfif NOT structKeyExists(form, "gender")>
        <div class="alert alert-danger">Please select a gender.</div>
        <cfabort>
    </cfif>

    <!--- Check if any language is selected --->
    <cfif arrayLen(languagesArray) EQ 0>
        <div class="alert alert-danger">Please select at least one language.</div>
        <cfabort>
    </cfif>

    <!--- Convert array to comma-separated string for the database --->
    <cfset languagesString = arrayToList(languagesArray, ", ")>

    <!--- SQL Query to insert data into the contacts table --->
    <cfquery datasource="#datasourceName#">
        INSERT INTO contacts (
            firstname, lastname, contact, email, 
            qualification, country, city, state, 
            address, pincode, gender, languages
        ) VALUES (
            <cfqueryparam value="#form.firstname#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.lastname#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.contact#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.qualification#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.country#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.city#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.state#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.address#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.pincode#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.gender#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#languagesString#" cfsqltype="cf_sql_varchar">
        );
    </cfquery>
    
    <!--- Success message after the query runs successfully --->
    <div class="alert alert-success">Contact added successfully!</div>
</cfif>
