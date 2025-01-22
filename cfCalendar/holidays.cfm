<cfinclude template="holidaysAction.cfm">
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Calendar</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="styles/index.css">
    </head>
    
    <body>
        <cfinclude template="../header.cfm">
        <cfoutput>
        <main class="container">
            
        <h2>All Holidays</h2>
        <cfif arrayLen(holidays) GT 0>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Holiday Date</th>
                        <th>Holiday Title</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop index="i" from="1" to="#arrayLen(holidays)#">
                        <tr>
                            <!-- Display the holiday date in the desired format -->
                            <td>#DateFormat(holidays[i], "mm/dd/yyyy")#</td>
                            <!-- Display the holiday title -->
                            <td>#qryholidays.str_holiday_title[i]#</td>  <!-- Correct the query column -->
                        </tr>
                    </cfloop>
                </tbody>
            </table>
        <cfelse>
            <p>No holidays found.</p>
        </cfif>
        <a href="addHolidays.cfm" class="btn btn-primary ms-3">Add New Holiday</a>
        </main>
        </cfoutput>
            

        <cfinclude template="../footer.cfm">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
