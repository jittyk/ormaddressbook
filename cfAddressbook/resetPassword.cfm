<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f8f9fa;
        }
        .container {
            width: 100%;
            max-width: 500px;
            margin-top: 50px;
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
    </style>
</head>
<body>

<cfset token = url.token>

<cfif structKeyExists(form, "submit")>
    <cfset newPassword = trim(form.newPassword)>
    <cfset confirmPassword = trim(form.confirmPassword)>

    <cfif newPassword neq confirmPassword>
        <div class="alert alert-danger" role="alert">
            Passwords do not match. Please try again.
        </div>
    <cfelse>
        <!-- Verify the token -->
        <cfquery name="checkToken" datasource="dsn_address_book">
            SELECT email FROM password_resets WHERE token = <cfqueryparam value="#token#" cfsqltype="cf_sql_varchar"> AND requested_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)
        </cfquery>

        <cfif checkToken.recordCount eq 0>
            <div class="alert alert-danger" role="alert">
                Invalid or expired reset link.
            </div>
        <cfelse>
            <!-- Update password in the users table -->
            <cfquery datasource="dsn_address_book">
                UPDATE users SET password = <cfqueryparam value="#newPassword#" cfsqltype="cf_sql_varchar">
                WHERE email = <cfqueryparam value="#checkToken.email#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <!-- Optionally, remove the token from the password_resets table -->
            <cfquery datasource="dsn_address_book">
                DELETE FROM password_resets WHERE token = <cfqueryparam value="#token#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <div class="alert alert-success" role="alert">
                Your password has been successfully reset. You can now <a href="login.cfm">login</a>.
            </div>
        </cfif>
    </cfif>
</cfif>

<div class="container">
    <h2>Reset Password</h2>
    <form action="reset-password.cfm?token=#token#" method="post">
        <input type="password" name="newPassword" class="form-control" placeholder="New Password" required>
        <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm Password" required>
        <button type="submit" name="submit" class="btn-submit">Submit</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
