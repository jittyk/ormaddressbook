<cfinclude template="adminLoginAction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Address Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="styles/adminlogin.css">
</head>
<body>
   
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
        <div class="container-fluid">
            <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="#">Family</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Friends</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Colleagues</a></li>
                    <li class="nav-item">
                        <form class="d-flex" method="get" action="user.cfm">
                            <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" name="searchTerm">
                        </form>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="userprofile.cfm">
                            <img src="images/contacts.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px;">
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white d-flex align-items-center" href="adminLogout.cfm">
                            <i class="bi bi-box-arrow-right"></i><span class="ms-2">Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Login Section -->
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card p-4 shadow">
                    <h1 class="text-center mb-4">Admin Login</h1>
                    <cfif structKeyExists(session, "str_login_error") AND len(trim(session.str_login_error)) GT 0>
                        <div class="alert alert-danger text-center">
                            <cfoutput>#session.str_login_error#</cfoutput>
                        </div>
                        <cfset session.str_login_error = "" />
                    </cfif>
                    <form action="" method="post">
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" id="email" name="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" id="password" name="password" class="form-control" required>
                        </div>
                        <button type="submit" name="submit" class="btn btn-primary w-100">Login</button>
                        <div class="text-center mt-3">
                            <a href="forgotPassword.cfm" class="text-decoration-none">Forgot Password?</a> |
                            <a href="signup.cfm" class="text-decoration-none">Sign Up</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- User Login Button -->
    <div class="text-center mt-4 mb-1">
        <a href="login.cfm">
            <button class="btn btn-secondary">Login as User</button>
        </a>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white py-3 mt-auto">
        <div class="container text-center">
            <ul class="list-inline mb-2">
                <li class="list-inline-item"><a href="#" class="text-white text-decoration-none">Family</a></li>
                <li class="list-inline-item"><a href="#" class="text-white text-decoration-none">Friends</a></li>
                <li class="list-inline-item"><a href="#" class="text-white text-decoration-none">Colleagues</a></li>
            </ul>
            <form method="get" action="index.cfm" class="mb-3">
                <input type="search" class="form-control w-50 mx-auto" placeholder="Search" name="searchTerm">
            </form>
            <p class="mb-0"><b>Address Book</b></p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
