<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Holiday</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <cfinclude template="../header.cfm">
        <cfoutput>
        <main class="container">
        <div class="container mt-5">
            <h2>Add New Holiday</h2>

            <form method="POST" action="addHolidayAction.cfm">
                <div class="mb-3">
                    <label for="holidayTitle" class="form-label">Holiday Title</label>
                    <input type="text" class="form-control" id="holidayTitle" name="holidayTitle" required>
                </div>

                <div class="mb-3">
                    <label for="holidayMonth" class="form-label">Month</label>
                    <select class="form-select" id="holidayMonth" name="holidayMonth" required>
                        <cfloop from="1" to="12" index="i">
                            <option value="#i#">#monthAsString(i)#</option>
                        </cfloop>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="holidayDay" class="form-label">Day</label>
                    <input type="number" class="form-control" id="holidayDay" name="holidayDay" min="1" max="31" required>
                </div>

                <button type="submit" class="btn btn-primary">Add Holiday</button>
            </form>
        </div>
    </main>
    </cfoutput>
        <cfinclude template="../footer.cfm">
    </body>
</html>
