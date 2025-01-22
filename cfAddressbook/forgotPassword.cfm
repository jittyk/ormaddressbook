<cfinclude template="forgotPasswordAction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
</head>
<body class="d-flex flex-column min-vh-100">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
    <div class="container-fluid">
        <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse d-flex justify-content-end" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="#">Family</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Friends</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Colleagues</a></li>
                <li class="nav-item">
                    <form class="form-inline" method="get" action="user.cfm">
                        <input class="form-control" type="search" placeholder="Search" name="searchTerm">
                    </form>
                </li>
                <li class="nav-item">
                    <a class="nav-link p-0" href="userprofile.cfm">
                        <img src="images/contacts.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; margin-left: 6px;">
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Display the message below the navbar -->
<cfif len(err_msg) >
    <div class="alert-container">
        <div class="alert <cfif userCheck.recordCount eq 1> alert-success <cfelse> alert-danger </cfif>" role="alert">
          <cfoutput>#err_msg#</cfoutput>  
        </div>
    </div>
</cfif>

<!-- Main Content -->
<div class="container d-flex justify-content-center align-items-center flex-grow-2 mt-5 mb-5">
    <div class="card shadow-lg p-4" style="max-width: 400px; width: 100%;">
        <h3 class="text-center mb-4">Recover Password</h3>
        <form action="forgotPassword.cfm" method="post">
            <div class="mb-3">
                <label for="str_email" class="form-label">Enter Your Email</label>
                <input type="email" name="str_email" class="form-control" id="str_email" placeholder="Enter your email" required>
            </div>
            <button type="submit" name="submit" class="btn btn-primary w-100">Request Password Reset</button>
        </form>
    </div>
</div>

<!-- Footer -->
<footer class="bg-dark text-white py-3 mt-auto">
    <div class="container">
        <div class="row">
            <div class="col-12 text-center mb-2">
                <ul class="list-unstyled d-flex justify-content-center mb-0">
                    <li class="me-3"><a href="#" class="text-white text-decoration-none">Family</a></li>
                    <li class="me-3"><a href="#" class="text-white text-decoration-none">Friends</a></li>
                    <li><a href="#" class="text-white text-decoration-none">Colleagues</a></li>
                </ul>
            </div>
            <div class="col-12 mb-2">
                <form method="get" action="index.cfm" class="d-flex justify-content-center">
                    <input type="search" class="form-control w-50" placeholder="Search" name="searchTerm">
                </form>
            </div>
            <div class="col-12 text-center">
                <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>