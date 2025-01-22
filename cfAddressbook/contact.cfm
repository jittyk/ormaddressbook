<cfinclude template="contactAction.cfm">
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Contacts with Pagination</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="styles\contact.css"
    </head>
    <body>
        <cfinclude template="../header.cfm">
        <main class="container">
        <div class="container mt-4">
            <h2 class="mb-4">Contact List</h2>
            <cfparam name="url.toggleId" default="0">
            <cfset toggleId = url.toggleId>
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="getContacts">
                        <tr>
                            <td>
                               
                                <cfif listFind(session.permissionList, 1)>
                                    <a href="contactDetails.cfm?int_contact_id=#int_contact_id#" class="contact-name" style="text-decoration: none;">
                                        #str_first_name# #str_last_name#
                                    </a>
                                  
                                <cfelse>  #str_first_name# #str_last_name#
                                </cfif>
                                
                            </td>
                            <td>
                                <!-- Edit Button -->
                                <cfif listFind(session.permissionList, 2)>
                                    <form action="addContact.cfm" method="GET" style="display:inline;">
                                        <input type="hidden" name="int_contact_id" value="#int_contact_id#">
                                        <button type="submit" class="btn btn-warning btn-sm">Edit</button>
                                    </form>
                                </cfif>
                                
                                <!-- Delete Button -->
                                <cfif listFind(session.permissionList, 3)>
                                    <form action="deleteContact.cfm" method="POST" style="display:inline;">
                                        <input type="hidden" name="int_contact_id" value="#int_contact_id#">
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this contact?')">Delete</button>
                                    </form>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
            <!-- Pagination -->
            
                <ul class="pagination justify-content-center">
                    <cfif page gt 1>
                        <li class="page-item">
                            <cfoutput><a class="page-link" href="contact.cfm?page=#page - 1#">Previous</a></cfoutput>
                        </li>
                    </cfif>
                    <cfloop from="1" to="#totalPages#" index="i">
                        <li class="page-item <cfif i eq page>active</cfif>">
                            <cfoutput><a class="page-link" href="contact.cfm?page=#i#">#i#</a></cfoutput>
                        </li>
                    </cfloop>
                    <cfif page lt totalPages>
                        <li class="page-item">
                            <cfoutput><a class="page-link" href="contact.cfm?page=#page + 1#">Next</a></cfoutput>
                        </li>
                    </cfif>
                </ul>
           
        </div>
    </main>
      <cfinclude template="../footer.cfm">
    </body>
</html>
