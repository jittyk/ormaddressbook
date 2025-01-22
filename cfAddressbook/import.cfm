<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Import Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="column min-vh-100">

<!--- Control Block --->  
<cfset uploadDir = expandPath("./uploads/")>
<cfset statusMessage = "">
<cfset datasourceName = "dsn_address_book">

<!--- Required columns and their data types ---> 
<cfset requiredColumns = {
    "firstname": "string",
    "lastname": "string",
    "contact": "string",
    "email": "string",   
    "qualification": "string",
    "country": "string",
    "city": "string",
    "state": "string",
    "address": "string",
    "pincode": "string",
    "gender": "string",
    "languages": "string"
}>

<!--- Function Block ---> 
<cffunction name="saveContact" access="public" returntype="string">
    <cfargument name="firstname" type="string">
    <cfargument name="lastname" type="string">
    <cfargument name="contact" type="string">
    <cfargument name="email" type="string">
    <cfargument name="qualification" type="string">
    <cfargument name="country" type="string">
    <cfargument name="city" type="string">
    <cfargument name="state" type="string">
    <cfargument name="address" type="string">
    <cfargument name="pincode" type="string">
    <cfargument name="gender" type="string">
    <cfargument name="languages" type="string">

    <cfset var result = "">

    <cftry>
        <!--- Insert into the database ---> 
        <cfquery name="qryInsert" datasource="#datasourceName#">
            INSERT INTO contacts (
                strFirstName, strLastName, strContact, strEmail,
                strQualification, strCountry, strCity, strState,
                strAddress, strPincode, strGender, strLanguages
            ) VALUES (
                <cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.contact#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.qualification#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.country#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.pincode#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.languages#" cfsqltype="cf_sql_varchar">
            );
        </cfquery>

        <!-- Log the successful insert -->
        <cflog file="importContacts" text="Inserted record: #arguments.firstname# #arguments.lastname#">
        <cfreturn "Contact saved successfully!">

        <cfcatch>
            <cflog file="importContacts" text="Error executing database query: #cfcatch.message#">
            <cfreturn "Error executing database query: #cfcatch.message#">
        </cfcatch>
    </cftry>
</cffunction>

<!--- Function to validate each record ---> 
<cffunction name="validateRecord" access="public" returntype="string">
    <cfargument name="record" type="struct">
    <cfset var validationMessage = "">
    
    <!--- Loop through each required column --->
    <cfloop collection="#requiredColumns#" item="column">
        <cfif not structKeyExists(arguments.record, column)>
            <cfset validationMessage = validationMessage & "Missing column: #column#. ">
        <cfelseif trim(arguments.record[column]) EQ "">
            <cfset validationMessage = validationMessage & "Column #column# cannot be empty. ">
        <cfelseif column EQ "email" AND not reFind("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$", arguments.record[column])>
            <cfset validationMessage = validationMessage & "Invalid email format in column #column#. ">
        <cfelseif column EQ "contact" AND not reFind("^\d{10}$", arguments.record[column])>
            <cfset validationMessage = validationMessage & "Contact number in column #column# must be a valid 10-digit number. ">
        <cfelseif column EQ "pincode" AND not reFind("^\d{6}$", arguments.record[column])>
            <cfset validationMessage = validationMessage & "Pincode in column #column# must be a valid 6-digit number. ">
        <cfelseif column EQ "gender" AND trim(arguments.record[column]) EQ "">
            <cfset validationMessage = validationMessage & "Gender in column #column# cannot be empty. ">
        <cfelseif column EQ "languages" AND trim(arguments.record[column]) EQ "">
            <cfset validationMessage = validationMessage & "Languages in column #column# cannot be empty. ">
        <!-- Add more validations as needed -->
        </cfif>
    </cfloop>

    <cfreturn validationMessage>
</cffunction>


<!--- Main Processing Logic ---> 
<cfif structKeyExists(form, "contactFile")>
    <cffile action="upload" 
             filefield="contactFile" 
             destination="#uploadDir#" 
             nameconflict="overwrite" 
             result="uploadResult">

    <cfif structKeyExists(uploadResult, "serverFile") AND uploadResult.serverFile NEQ "">
        <cfset filePath = expandPath("./uploads/#uploadResult.serverFile#")>

        <cfif right(filePath, 5) EQ ".xlsx">
            <cfif fileExists(filePath)>
                <cftry>
                    <cfspreadsheet action="read" 
                                   src="#filePath#" 
                                   query="qryContacts" 
                                   sheet="1" 
                                   headerrow="1" 
                                   excludeHeaderRow="true">

                    <cfif qryContacts.recordCount GT 0>
                        <cflog file="importContacts" text="Total records found: #qryContacts.recordCount#">
                        <cfset successCount = 0>
                        <cfset failureCount = 0>
                        <cfset errorMessages = "">

                        <cfloop query="qryContacts">
                            <!--- Convert query row to struct for validation --->
                            <cfset recordStruct = queryGetRow(qryContacts, qryContacts.currentRow)>

                            <!--- Validate the current record --->
                            <cfset validationMessage = validateRecord(recordStruct)>
                            
                            <cfif validationMessage NEQ "">
                                <!--- Increment failure count and store the error message --->
                                <cfset failureCount = failureCount + 1>
                                <cfset errorMessages = errorMessages & "Row #qryContacts.currentRow#: #validationMessage# <br>">
                            <cfelse>
                                <!--- Only proceed if validation passes --->
                                <cfset resultMessage = saveContact(
                                    firstname=qryContacts.firstname,
                                    lastname=qryContacts.lastname,
                                    contact=qryContacts.contact,
                                    email=qryContacts.email,
                                    qualification=qryContacts.qualification,
                                    country=qryContacts.country,
                                    city=qryContacts.city,
                                    state=qryContacts.state,
                                    address=qryContacts.address,
                                    pincode=qryContacts.pincode,
                                    gender=qryContacts.gender,
                                    languages=qryContacts.languages
                                )>
                                
                                <cflog file="importContacts" text="#resultMessage#">
                                <cfif resultMessage CONTAINS "successfully">
                                    <cfset successCount = successCount + 1>
                                <cfelse>
                                    <!--- If the database insert fails, increment failure count as well --->
                                    <cfset failureCount = failureCount + 1>
                                </cfif>
                            </cfif>
                        </cfloop>

                        <!--- Final status message --->
                        <cfset statusMessage = "Successfully inserted #successCount# records. Failed to insert #failureCount# records.">
                        <cfif errorMessages NEQ "">
                            <cfset statusMessage = statusMessage & "<br>Errors:<br>#errorMessages#">
                        </cfif>
                    <cfelse>
                        <cfset statusMessage = "No records found in the file.">
                    </cfif>
                    <cfcatch>
                        <cfset statusMessage = "Error reading the spreadsheet: #cfcatch.message#">
                    </cfcatch>
                </cftry>
            <cfelse>
                <cfset statusMessage = "Uploaded file is not an Excel file.">
            </cfif>
        </cfif>
    <cfelse>
        <cfset statusMessage = "No file uploaded.">
    </cfif>
</cfif>




    <!--- Display Block ---> 
    <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.cfm"><b>Address Book</b></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link" href="#">Family</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Friends</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Colleagues</a></li>
                    <li class="nav-item">
                        <form class="d-inline-block">
                            <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                        </form>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link p-0" href="profile.cfm">
                            <img src="images/contacts.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; margin-left: 6px;">
                        </a>
                    </li>
                    <form action="logout.cfm" method="post" class="d-inline">
                    <button type="submit" class="btn btn-danger">Logout</button>
                </form>
                </ul>
            </div>
        </div>
    </nav>
    
    <div class="carder d-flex flex-column justify-content-center align-items-center min-vh-100">
        <div class="container text-center align-items-center">
            <div class="import-box d-flex flex-column justify-content-center align-items-center vh-100">
                <h1 class="text-center mb-4">Import Contacts</h1>
                <form action="import.cfm" method="post" enctype="multipart/form-data">
                    <input type="file" name="contactFile" accept=".xls,.xlsx" class="mb-3 mx-auto d-block" style="margin-right: 0rem !important; margin-left: 6rem !important;">
                    <button type="submit" class="btn btn-success mb-3">Upload</button>
                </form>
                <cfoutput><p id="statusMessage">#statusMessage#</p></cfoutput>
            </div>
        </div>
    </div>
    <footer class="mt-auto bg-dark text-white py-3">
        <div class="container">
            <div class="row">
                <div class="col-12 mb-3">
                    <ul class="list-unstyled d-flex flex-column flex-md-row justify-content-center mb-0">
                        <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Family</a></li>
                        <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Friends</a></li>
                        <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Colleagues</a></li>
                    </ul>
                </div>
                <div class="col-12 text-center">
                    <p class="mb-0">© 2024 Address Book, All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
