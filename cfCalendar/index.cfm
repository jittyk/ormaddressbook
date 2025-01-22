<cfinclude template="indexAction.cfm">
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
        <main class="container-fluid">
            <div class="calendar">
                <div class="calendar-header d-flex flex-wrap">
                    <form method="post" class="d-flex flex-wrap w-100">
                        <div><label for="month" class="me-2">Month:</label>
                            <select id="month" name="month" onchange="this.form.submit()">
                                <cfloop index="i" from="1" to="12">
                                    <option value="#i#" <cfif i eq selectedMonth>selected</cfif>>#monthAsString(i)#</option>
                                </cfloop>
                            </select>
                        </div>
                        <div class="mt-1">
                            <label for="year" class="ms-3 me-2">Year:</label>
                            <select id="year" name="year" onchange="this.form.submit()">
                                <cfloop index="year" from="#variables.selectedYear - 5#" to="#variables.selectedYear + 5#">
                                    <option value="#year#" <cfif year EQ variables.selectedYear>selected</cfif>>#year#</option>
                                </cfloop>
                            </select>
                        </div>
                        <div>
                            <a href="holidays.cfm" class="btn btn-primary ms-3">Holidays</a>
                        </div>
                    </form>
                </div>

                <div class="days mt-1">
                    <div>Su</div><div>Mo</div><div>Tu</div><div>We</div><div>Th</div><div>Fr</div><div>Sa</div>

                    <!-- Empty leading spaces -->
                    <cfloop index="i" from="1" to="#dayOfWeek - 1#">
                        <div class="date-cell"></div>
                    </cfloop>

                    <cfloop array="#datesData#" index="date">
                        <form action="eventManager.cfm" method="post" class="w-100">
                            <input type="hidden" name="date" value="#dateFormat(date.selectedDate, 'yyyy-mm-dd')#">
                            <button type="submit" 
                                    class="date-cell 
                                        <cfif date.isToday> text-primary</cfif>
                                        <cfif date.isHoliday> text-danger</cfif>
                                        <cfif date.hasEvent> bg-warning </cfif> 
                                    ">
                                #date.day# 
                            </button>
                        </form>
                    </cfloop>

                    <cfloop index="j" from="1" to="#emptyCells#">
                        <div class="date-cell"></div>
                    </cfloop>
                </div>
            </div>
        </main>
    </cfoutput>

    <cfinclude template="../footer.cfm">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>