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
    <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
        <div class="container-fluid">
           <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
           <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
           </button>
           <div class="collapse navbar-collapse" id="navbarNav">
              <ul class="navbar-nav ms-auto align-items-center">
                 <li class="nav-item"><a class="nav-link" href="#">Family</a></li>
                 <li class="nav-item"><a class="nav-link" href="#">Friends</a></li>
                 <li class="nav-item"><a class="nav-link" href="#">Colleagues</a></li>
                 <li class="nav-item">
                    <form class="d-inline-block" method="get" action="user.cfm">
                       <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" name="searchTerm">
                    </form>
                 </li>
                 <li class="nav-item">
                    <a class="nav-link p-0" href="userprofile.cfm">
                       <img src="images\contacts.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; margin-left: 6px;">
                    </a>
                 </li>
                 <!-- Logout button with icon -->
                 <li class="nav-item">
                    <a class="nav-link text-white d-flex align-items-center" href="userlogout.cfm">
                       <i class="bi bi-box-arrow-right icon-white"></i> 
                       <span class="ms-2">Logout</span>
                    </a>
                 </li>
              </ul>
           </div>
        </div>
     </nav>
   <!-- Main Content -->
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
    <footer class="mt-auto bg-dark text-white py-3">
        <div class="container">
           <div class="row">
              <div class="col-12 mb-3">
                 <ul class="list-unstyled d-flex flex-column flex-md-row justify-content-center mb-0">
                    <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Family</a></li>
                    <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Friends</a></li>
                    <li><a href="#" class="text-white text-decoration-none">Colleagues</a></li>
                 </ul>
              </div>
              <div class="col-12 mb-3 d-flex justify-content-center">
                 <div class="col-10 col-md-6 col-lg-4">
                    <form method="get" action="index.cfm">
                       <input type="search" class="form-control" placeholder="Search" name="searchTerm">
                    </form>
                 </div>
              </div>
              <div class="col-12 text-center text-md-end">
                 <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
              </div>
           </div>
        </div>
     </footer>
</body>
</html>
