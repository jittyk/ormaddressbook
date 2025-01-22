
<cfif not structKeyExists(session, "int_user_id") or session.int_user_id EQ "" or session.int_user_id IS 0>
    <cflocation url="login.cfm">
</cfif>


<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Index Page</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
      <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
      <link rel="stylesheet" href="styles\user.css">
   </head>
   <body class="column min-vh-100">
      <cfinclude template="../header.cfm">
      

      <div class="container-xxl my-5">
         <div class="row">
            <div class="col-12">
               <h2 class="text-center"><b>What we provide...</b></h2>
               <p>Connections and Contacts is a personalized and comprehensive collection of important people in my life. This address book includes close friends and family members, professional colleagues and collaborators, acquaintances and neighbors, social connections and community members, business associates and clients, and mentors and role models. It serves as a quick reference guide for keeping track of contact information, important dates, personal notes and reminders, social media profiles, and relationships between contacts. By maintaining this address book, I aim to stay organized, nurture my relationships, and foster meaningful connections with the people who matter most in my life. It's a valuable tool for staying in touch, building stronger relationships, and celebrating important milestones and occasions.</p>
            </div>
            <cfinclude template="userAction.cfm">
            <div class="col-12  text-center">
               <h3>Events Today</h3>
               <ul class="list-group">
               
                   <!-- Check if Events are Available -->
                   <cfif todayEvents.recordCount GT 0>
                       <cfoutput query="todayEvents">
                           <li class="list-group-item d-flex flex-column align-items-start">
                               <h5 class="mb-1">
                                   #str_event_title#
                                   <span class="badge bg-<cfif str_priority EQ 'high'>danger<cfelseif str_priority EQ 'medium'>warning<cfelse>success</cfif>">
                                       
                                   </span>
                               </h5>
                               <p class="mb-1 text-muted">#str_description#</p>
                               
                           </li>
                       </cfoutput>
                   <cfelse>
                       <li class="list-group-item text-muted">No events scheduled for today.</li>
                   </cfif>
               </ul>
           </div>
           
            <div class="col-12 col-md-7 text-center">
               <a href="addContact.cfm"><img src="../images\addcontact.jpg" alt="Add Contact" class="img-fluid"
                  title="Add Contact - Click to add a new contact"></a>
               <p>Add Contact</p>
               <p>Tap the Add Contact icon to add a new contact to your address book. This feature allows you to store essential information about people you know, including their full name, phone numbers (mobile, home, or work), email addresses (personal or professional), home or work addresses, birthdays, and any additional notes.</p>
            </div>
            <div class="col-12 col-md-5 text-center">
               <a href="contact.cfm"><img src="../images\contacts.jpg" alt="Contact" class="img-fluid rounded-circle"
                  title="Contact - Click to view contacts" style="width: 80px; height: 80px;"></a>
               <p>Contact</p>
               <p>Tap the Contact icon to view your list of contacts in your address book. This section provides an overview of the people you have stored, allowing you to easily access their information, update details, or remove contacts as needed. It helps you manage and organize your contacts efficiently.</p>
            </div>
         </div>
      </div>

      <cfinclude template="../footer.cfm">
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
   </body>
</html>
