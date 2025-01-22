<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f8f9fa;
        }
        .signup-container {
            text-align: center;
            display: inline-block;
            padding: 20px;
            margin: 60px;
            border: 1px solid #000000;
            border-radius: 8px;
            background: linear-gradient(to right, #0623a1, #53a9f5);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            color: white;
        }
        .log-container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
        }
        .signup-container h2 {
            margin-bottom: 20px;
            color: #333;
        }
        .form-control {
            margin-bottom: 15px;
        }
        .btn-submit {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-submit:hover {
            background-color: #45a049;
        }
        .message {
            margin-top: 15px;
        }
        .danger {
            color: red;
        }
        .success {
            color: rgb(255, 255, 255);
        }
    </style>
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
        
        <!-- Place messages here inside the container -->
        <cfif structKeyExists(form, "submit")>
            <!--- Check if email already exists ---> 
            <cfquery name="checkEmail" datasource="dsn_address_book">
                SELECT COUNT(*) AS emailCount
                FROM tbl_users
                WHERE str_email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfif checkEmail.emailCount GT 0>
                <!--- Email already exists ---> 
                <div class="message danger">This email is already registered. Please try another one.</div>
            <cfelse>
                <!--- Insert new user with role_id = 2 (user) and status = 'P' (pending) ---> 
                <cfquery name="insertUser" datasource="dsn_address_book">
                    INSERT INTO tbl_users (str_first_name, str_phone, str_user_name, str_email, str_password, int_user_role_id, cbr_status)
                    VALUES (
                        <cfqueryparam value="#name#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#phone#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">,
                        2,
                        'P' 
                    )
                </cfquery>

                <!--- Show success message --->
                <div class="message success">Your account has been created successfully. Please wait for approval.</div>
            </cfif>
        </cfif>
        
        <!-- Sign up form -->
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
