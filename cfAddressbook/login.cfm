<cfinclude template="loginAction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Login - Address Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../styles/login.css">
   
</head>
<body>
    <cfinclude template="../header.cfm">

    
        <cfif structKeyExists(session, "loginError") AND len(trim(session.loginError)) GT 0>
            <cfoutput><div class="danger text-center">#session.loginError#</div></cfoutput>
            <cfset session.loginError = "" /> <!-- Clear error message after displaying -->
        </cfif>
        <div class="log-container">
            <div class="login-container">
                <h1>User Login</h1>

                <form action="login.cfm" method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email:</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                        <div class="invalid-feedback">Please provide a valid email.</div>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password:</label>
                        <input type="password" id="password" name="password" class="form-control" required>
                        <div class="invalid-feedback">Please provide a password.</div>
                    </div>
                    <button type="submit" name="submit" class="btn btn-primary">Login</button>

                    <div class="links">
                        <a href="forgotPassword.cfm">Forgot Password?</a> &nbsp
                        <a href="signup.cfm">Sign Up</a>
                    </div>
                </form>
            </div>
        </div>
        <div class="log-container d-flex justify-content-center align-items-center ">
            <a href="adminLogin.cfm"><button style="margin-bottom:5px;">Login as Admin</button></a>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
