<cfinclude template="adminAction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="styles\admin.css">
</head>
<body class="d-flex flex-column min-vh-100">
<nav class="navbar navbar-expand-lg navbar-dark bg-secondary flex-column p-3" style="width: 250px; position: fixed; height: 100%; left: 0; top: 0;">
    <div class="container-fluid flex-column">
        <a class="navbar-brand mb-4" href="admin.cfm"><b>Address Book</b></a>
        <ul class="navbar-nav flex-column w-100">
            <li class="nav-item">
                <a class="nav-link" href="#">Family</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#">Friends</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#">Colleagues</a>
            </li>
            
            <li class="nav-item">
                <a class="nav-link text-white d-flex align-items-center" href="adminLogout.cfm">
                    <i class="bi bi-box-arrow-right icon-white"></i> 
                    <span class="ms-2">Logout</span>
                </a>
            </li>
        </ul>
    </div>
</nav>
<main class="container mt-4 ms-15 ps-5 flex-grow-1" style="margin-left: 250px;">
        <cfoutput>
            <h2>User Management</h2>
            <div>
                <form method="post" action="admin.cfm">
                    <div class="input-group mb-3">
                        <input 
                            class="form-control me-2" 
                            type="search" 
                            placeholder="Search by Name, Email, or Phone" 
                            aria-label="Search" 
                            name="searchKey" 
                            value="<cfif structKeyExists(form, 'searchKey')>#form.searchKey#</cfif>">
                        <button class="btn btn-outline-success" type="submit">Search</button>
                    </div>
                </form>
            </div>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Status</th>
                        <th>Permissions</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="qryUsers">
                        <tr>
                            <td>#int_user_id-3#</td>
                            <td>#str_first_name#</td>
                            <td>#str_email#</td>
                            <td>
                                <cfif cbr_status EQ "P">Pending
                                <cfelseif cbr_status EQ "A">Approved
                                <cfelse>Rejected</cfif>
                            </td>
                            <td>
                                <cfif cbr_status NEQ "I">
                                    <form method="post" action="admin.cfm">
                                        <input type="hidden" name="int_user_id" value="#int_user_id#">
                                        <input type="hidden" name="action" value="updatePermissions">
                                        <cfset qryUserPermissions = getCurrentPermissions(int_user_id = int_user_id)>
                                        <cfset qrygetAllPermissions = getAllPermissions()>
                                        <cfloop query="qrygetAllPermissions">
                                            <div>
                                                <input 
                                                    type="checkbox" 
                                                    name="permissions" 
                                                    value="#int_permission_id#" 
                                                    <cfif qryUserPermissions.recordCount GT 0 AND listFind(valueList(qryUserPermissions.int_permission_id), qrygetAllPermissions.int_permission_id)>checked="checked"</cfif>
                                                />
                                                #str_permission_name#
                                            </div>
                                        </cfloop>
                                        <button type="submit" class="btn btn-primary">Update</button>
                                    </form>
                                <cfelse>
                                    <p>No Action required.</p>
                                </cfif>
                            </td>

                            <td>
                                <cfif cbr_status EQ "P">
                                    <!-- Approve and Reject buttons are shown only when the status is Pending -->
                                    <form method="post">
                                        <input type="hidden" name="int_user_id" value="#int_user_id#">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <button type="submit" name="status" value="A" class="btn btn-success">Approve</button>
                                        <button type="submit" name="status" value="I" class="btn btn-danger">Reject</button>
                                    </form>
                                <cfelse>
                                    <p>No Action required.</p>
                                </cfif>
                            </td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>

            <div class="d-flex justify-content-center">
                    <ul class="pagination">
                    <cfset totalPages = Ceiling(qryCount.totalUsers / recordsPerPage)>
                    <cfset startPage = (currentPage - 2) GT 1 ? (currentPage - 2) : 1>
                    <cfset endPage = (currentPage + 2) LT totalPages ? (currentPage + 2) : totalPages>
                    <ul class="pagination">
                        <!-- Previous Button -->
                        <cfif currentPage GT 1>
                            <li class="page-item">
                                <a class="page-link" href="admin.cfm?page=#currentPage - 1#">Previous</a>
                            </li>
                        </cfif>
                        <!-- Loop to create page numbers dynamically -->
                        <cfloop index="i" from="#startPage#" to="#endPage#">
                            <li class="page-item <cfif currentPage EQ i>active</cfif>">
                                <a class="page-link" href="admin.cfm?page=#i#">#i#</a>
                            </li>
                        </cfloop>
                        <!-- Next Button -->
                        <cfif currentPage LT totalPages>
                            <li class="page-item">
                                <a class="page-link" href="admin.cfm?page=#currentPage + 1#">Next</a>
                            </li>
                        </cfif>
                    </ul>
                </div>
            </cfoutput>
        </main>
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
 
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>
