<cfinclude template="addContactAction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Contact Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    
</head>
<body>
    <cfinclude template="../header.cfm">
    
        <cfoutput>
        <div class="headdiv text-center">
            <h1>ADD CONTACT </h1>
        </div>
        <div class="text-center">
            <cfif len(strErrorMsg)>
                <div style="color: red;">#strErrorMsg#</div>  
            <cfelse>
                <div style="color: green;">#strSuccessMsg#</div>  
            </cfif>
        </div>

        <form action="" method="POST" class="container">
            
            <cfif variables.int_contact_id NEQ 0>
                <input type="hidden" name="int_contact_id" value="#variables.int_contact_id#">
                
            <cfelse>
                <input type="hidden" name="int_contact_id" value="0">
            </cfif>
            <div class="mb-3 row">
                <label for="fname" class="col-sm-2 col-form-label">First Name</label>
                <div class="col-sm-10">
                    <input type="text" id="fname" name="str_first_name" class="form-control" placeholder="Your name.." value="#str_first_name#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="lname" class="col-sm-2 col-form-label">Last Name</label>
                <div class="col-sm-10">
                    <input type="text" id="lname" name="str_last_name" class="form-control" placeholder="Your last name.." value="#str_last_name#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_contact" class="col-sm-2 col-form-label">Contact no</label>
                <div class="col-sm-10">
                    <input type="text" id="str_contact" name="str_contact" class="form-control" placeholder="Contact number.." value="#str_contact#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_email" class="col-sm-2 col-form-label">Email</label>
                <div class="col-sm-10">
                    <input type="text" id="str_email" name="str_email" class="form-control" placeholder="Your Email.." value="#str_email#">
                </div>
            </div>
            <!-- Qualification Dropdown -->
            <div class="mb-3 row">
                <label for="int_qualification" class="col-sm-2 col-form-label">Qualification</label>
                <div class="col-sm-10">
                    <select name="int_qualification" id="int_qualification" class="form-control">
                        <!-- Default option -->
                        <option value="" disabled
                            <cfif NOT structKeyExists(variables, "contact") OR NOT contact.recordCount OR NOT len(contact.int_qualification)>
                                selected="selected"
                            </cfif>
                        >
                            Select Qualification
                        </option>
                        
                        <!-- Populate qualifications from qryGetQualifications -->
                        <cfif qryGetQualifications.recordCount GT 0>
                            <cfloop query="qryGetQualifications">
                                <option value="#qryGetQualifications.int_qualification_id#"
                                    <cfif structKeyExists(variables, "contact") AND contact.recordCount AND contact.int_qualification EQ qryGetQualifications.int_qualification_id>
                                        selected="selected"
                                    </cfif>
                                >
                                    #qryGetQualifications.str_qualification_name#
                                </option>
                            </cfloop>
                        <cfelse>
                            <!-- If no qualifications are available -->
                            <option value="" disabled>No qualifications available</option>
                        </cfif>
                    </select>
                </div>
            </div>
            
            
            
            <div class="mb-3 row">
                <label for="int_country_id" class="col-sm-2 col-form-label ">Country</label>
                <div class="col-sm-10">
                    <select name="int_country" id="int_country" class="form-control">
                        <!-- Default option -->
                        <option value="" disabled
                            <cfif NOT structKeyExists(variables, "contact") OR NOT contact.recordCount OR NOT len(contact.int_country)>
                                selected="selected"
                            </cfif>
                        >
                            Select Country
                        </option>
                    
                        <!-- Populate countries from qryGetCountries -->
                        <cfif qryGetCountries.recordCount GT 0>
                            <cfloop query="qryGetCountries">
                                <option value="#qryGetCountries.int_country_id#"
                                    <cfif structKeyExists(variables, "contact") AND contact.recordCount AND contact.int_country EQ qryGetCountries.int_country_id>
                                        selected="selected"
                                    </cfif>
                                >
                                    #qryGetCountries.str_country_name#
                                </option>
                            </cfloop>
                        <cfelse>
                            <!-- If no countries are available -->
                            <option value="" disabled>No countries available</option>
                        </cfif>
                    </select>
                    
                </div>
            </div>
            
            
            <div class="mb-3 row">
                <label for="str_city" class="col-sm-2 col-form-label">City</label>
                <div class="col-sm-10">
                    <input type="text" id="str_city" name="str_city" class="form-control" placeholder="Your City.." value="#str_city#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_state" class="col-sm-2 col-form-label">State</label>
                <div class="col-sm-10">
                    <input type="text" id="str_state" name="str_state" class="form-control" placeholder="Your State.." value="#str_state#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_address" class="col-sm-2 col-form-label">Address</label>
                <div class="col-sm-10">
                    <input type="text" id="str_address" name="str_address" class="form-control" placeholder="Your Address.." value="#str_address#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_pincode" class="col-sm-2 col-form-label">Pincode</label>
                <div class="col-sm-10">
                    <input type="text" id="str_pincode" name="str_pincode" class="form-control" placeholder="Your Pincode.." value="#str_contact#">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_gender" class="col-sm-2 col-form-label">Gender</label>
                <div class="col-sm-10">
                    <div>
                        <input type="radio" id="male" name="str_gender" value="Male"
                            <cfif str_gender EQ "Male">checked="checked"</cfif>> 
                        <label for="male">Male</label>
                    </div>
                    <div>
                        <input type="radio" id="female" name="str_gender" value="Female"
                            <cfif str_gender EQ "Female">checked="checked"</cfif>> 
                        <label for="female">Female</label>
                    </div>
                    <div>
                        <input type="radio" id="other" name="str_gender" value="Other"
                            <cfif str_gender EQ "Other">checked="checked"</cfif>> 
                        <label for="other">Other</label>
                    </div>
                </div>
            </div>
            <div class="mb-3 row">
                <label for="str_languages" class="col-sm-2 col-form-label">Languages</label>
                <div class="col-sm-10">
                    <div>
                        <input type="checkbox" id="malayalam" name="str_languages" value="Malayalam" 
                            <cfif listFind(str_languages, "Malayalam")>checked="checked"</cfif>>
                        <label for="malayalam">Malayalam</label>
                    </div>
                    <div>
                        <input type="checkbox" id="english" name="str_languages" value="English"
                            <cfif listFind(str_languages, "English")>checked="checked"</cfif>>
                        <label for="english">English</label>
                    </div>
                    <div>
                        <input type="checkbox" id="hindi" name="str_languages" value="Hindi"
                            <cfif listFind(str_languages, "Hindi")>checked="checked"</cfif>>
                        <label for="hindi">Hindi</label>
                    </div>
                </div>
            </div>
            <div class="mb-3 row">
        <div class="col-sm-10 offset-sm-2 d-flex justify-content-end">
            <button type="reset" class="btn btn-secondary me-2">Reset</button>
            <button type="submit" id="btnSubmit" name="btn-submit" class="btn btn-success"
                <cfif len(strSuccessMsg)>
                    disabled="disabled"
                </cfif>>
                Submit
            </button>
        </div>
    </div>
        </form>
        
    </cfoutput>
        <cfinclude template="../footer.cfm">
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
