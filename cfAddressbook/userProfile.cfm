<cfif NOT structKeyExists(session, "user")>
    <cflocation url="adminLogin.cfm">
</cfif>
            
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
    <cfinclude template="../header.cfm">
   <div class="container my-5">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white">
            <h1 class="text-center">Welcome, <cfoutput>#session.user.str_user_name#</cfoutput>!</h1>
        </div>
        <div class="card-body">
            <p class="fs-5"><strong>Name:</strong> <cfoutput>#session.user.str_first_name#</cfoutput></p>
            <p class="fs-5"><strong>Email:</strong> <cfoutput>#session.user.str_email#</cfoutput></p>
            <p class="fs-5"><strong>Phone:</strong> <cfoutput>#session.user.str_phone#</cfoutput></p>
        
        </div>
    </div>
</div>    
    <cfinclude template="../footer.cfm">
</body>
</html>
