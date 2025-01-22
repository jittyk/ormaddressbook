<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Address Book</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
       
    </head>
    <body>
        <!-- Header: Navbar -->
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
                            <a class="nav-link p-0" href="jitty.cfm">
                            <img src="images/contacts.jpg" alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; margin-left: 6px;">
                            </a>
                        </li>
                        <!-- Logout button with icon -->
                        <li class="nav-item">
                            <a class="nav-link text-white d-flex align-items-center" href="logout.cfm">
                            <i class="bi bi-box-arrow-right icon-white"></i> 
                            <span class="ms-2">Logout</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <!-- Main content goes here -->
        <div class="container">
            <div class="login-wrapper">
                <!-- Flip container -->
                <div class="flip-container" id="flipContainer">
                    <!-- Admin Login Form (Front Side) -->
                    <div class="login-container admin-login">
                        <h1>Admin Login</h1>
                        <!-- Display error message if login failed -->
                        <div class="danger" id="adminError">Invalid login credentials or you do not have admin access.</div>
                        <form action="adminLogin.cfm" method="post">
                            <label for="adminEmail">Email:</label>
                            <input type="email" id="adminEmail" name="email" required>
                            <br>
                            <label for="adminPassword">Password:</label>
                            <input type="password" id="adminPassword" name="password" required>
                            <br>
                            <button type="submit" name="submit">Login as Admin</button>
                        </form>
                    </div>
                    <!-- User Login Form (Back Side) -->
                    <div class="login-container user-login">
                        <h1>User Login</h1>
                        <!-- Display error message if login failed -->
                        <div class="danger" id="userError">Invalid login credentials or you do not have user access.</div>
                        <form action="login.cfm" method="post">
                            <label for="userEmail">Email:</label>
                            <input type="email" id="userEmail" name="email" required>
                            <br>
                            <label for="userPassword">Password:</label>
                            <input type="password" id="userPassword" name="password" required>
                            <br>
                            <button type="submit" name="submit">Login as User</button>
                        </form>
                    </div>
                </div>
                <!-- Toggle Buttons outside of the flip container -->
                <div class="toggle-container col-12">
                    <button id="adminButton" class="active" onclick="showAdminLogin()">Admin Login</button>
                    <button id="userButton" onclick="showUserLogin()">User Login</button>
                </div>
            </div>
        </div>
        <!-- Footer -->
        <footer class="mt-auto bg-dark text-white py-3">
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
        </footer>
        <script>
            // JavaScript to toggle between Admin and User login by flipping and show only one button
            function showAdminLogin() {
                document.getElementById('flipContainer').classList.remove('flipped');
                document.getElementById('adminButton').classList.remove('active');
                document.getElementById('userButton').classList.add('active');
            }
            
            function showUserLogin() {
                document.getElementById('flipContainer').classList.add('flipped');
                document.getElementById('adminButton').classList.add('active');
                document.getElementById('userButton').classList.remove('active');
               
                
            }
            
            // Initially, hide the User Login button
            document.getElementById('adminButton').classList.remove('active');
            document.getElementById('userButton').classList.add('active');
        </script>
        <!-- Bootstrap JS and dependencies -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>







<cffunction name="calculateRecurringEventDates" access="public" returntype="array"> 
    <cfargument name="startDate" type="date" required="true"> 
    <cfargument name="endDate" type="date" required="true"> 
    <cfset var recurringDates = []>
    <cfset var eventList = getRecurringEvents(startDate, endDate)> 
    <cfloop array="#eventList#" index="event"> 
        <cfset var eventStartDate = event.getDt_event_date()> 
        <cfset var recurrenceType = event.getStr_recurrence_type()> 
        <cfset var recurringDuration = event.getInt_recurring_duration()> 
        <cfset var currentDate = eventStartDate> 
        <cfset var currentDate = DateFormat(currentDate,"yyyy-mm-dd")>
        <cfif recurrenceType EQ "daily"> 
            <cfloop from="#eventStartDate#" to="#dateAdd('d', recurringDuration - 1, eventStartDate)#" index="eventStartDate" step="1"> 
                <cfif currentDate GTE arguments.startDate AND currentDate LTE arguments.endDate>
                    <cfset arrayAppend(recurringDates, currentDate)> 
                </cfif> 
            </cfloop> 
        <cfelseif recurrenceType EQ "weekly"> 
            <cfloop condition="currentDate GTE dateAdd('m', recurringDuration, eventStartDate)"> 
                <cfif currentDate GTE arguments.startDate AND currentDate LTE arguments.endDate> 
                    <cfset arrayAppend(recurringDates, currentDate)> 
                </cfif> 
                <cfset currentDate = dateAdd("d", 7, currentDate)> 
            </cfloop> 
        <cfelseif recurrenceType EQ "monthly"> 
            <cfloop condition="currentDate LTE dateAdd('m', recurringDuration, eventStartDate)"> 
                <cfif currentDate GTE arguments.startDate AND currentDate LTE arguments.endDate> 
                    <cfset arrayAppend(recurringDates, currentDate)> 
                </cfif> 
                <cfset currentDate = dateAdd("m", 1, currentDate)> 
            </cfloop> 
        </cfif> 
    </cfloop>
    <cfreturn recurringDates> 
</cffunction>
