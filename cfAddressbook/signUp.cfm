<cfinclude template="signUpAction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="styles\signUp.css" rel="stylesheet"></linkink>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.html"><b>Address Book</b></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav#" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link" href="">Family</a></li>
                <li class="nav-item"><a class="nav-link" href="">Friends</a></li>
                <li class="nav-item"><a class="nav-link" href="">Colleagues</a></li>
                <li class="nav-item">
                    <form class="d-inline-block">
                        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                    </form>
                </li>
                <li class="nav-item">
                    <a class="nav-link p-0" href="jitty.html">
                        <img src="photo.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; margin-left: 6px;">
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="log-container">
    <div class="signup-container">
        <h2>Sign Up</h2>
        <form action="signup.cfm" method="post">
            <input type="text" name="name" class="form-control" placeholder="Name" required>
            <input type="text" name="phone" class="form-control" placeholder="Phone" required pattern="\d{10}" title="Please enter a valid 10-digit phone number">
            <input type="text" name="username" class="form-control" placeholder="Username" required>
            <input type="email" name="email" class="form-control" placeholder="Email" required>
            <input type="password" name="password" class="form-control" placeholder="Password" required>
            <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm Password" required>
            <button type="submit" name="submit" class="btn-submit">Sign Up</button>
        </form>
    </div>
</div>

<footer class="mt-auto bg-dark text-white py-3">
    <div class="container">
        <div class="row">
            <div class="col-12 text-center">
                <a class="navbar-brand" href="index.html"><b>Address Book</b></a>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
