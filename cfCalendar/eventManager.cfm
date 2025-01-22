<cfinclude template="eventManagerAction.cfm">
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <cfinclude template="../header.cfm">

            <cfoutput>
                <main class="container mt-5">
                    <h1>Events on #dateFormat(selectedDate, "dd MMM yyyy")#</h1>
                    <cfif structKeyExists(variables, "message")>
                        <p>#variables.message#</p>
                    </cfif>
                    <cfif qryEvents.recordCount GT 0>
                        <ul class="list-group">
                            <cfloop query="qryEvents">
                                <li class="list-group-item">
                                    <h5>#str_event_title#</h5>
                                    <p><strong>Description:</strong> #str_description#</p>
                                    <p><strong>Priority:</strong> 
                                        <span class="badge 
                                            <cfif str_priority EQ "low">bg-success
                                            <cfelseif str_priority EQ "medium">bg-warning
                                            <cfelse>bg-danger</cfif>">
                                            #str_priority#
                                        </span>
                                    </p>
                                    <p><strong>Recurring:</strong> #str_recurrence_type#</p>
                                    <p><strong>Start Time:</strong> #timeFormat(qryEvents.dt_start_time, "HH:mm:ss")#</p>
                                    <p><strong>End Time:</strong> #timeFormat(qryEvents.dt_end_time, "HH:mm:ss")#</p>
                                    
                                    <!-- Display Recurring Dates for Daily, Weekly, or Monthly -->
                                    <cfif str_recurrence_type EQ "daily">
                                        <p><strong>Next Occurrence:</strong> 
                                            #dateFormat(dateAdd("d", int_recurring_duration, dt_event_date), "dd MMM yyyy")#
                                        </p>
                                    <cfelseif str_recurrence_type EQ "weekly">
                                        <p><strong>Next Occurrence:</strong> 
                                            #dateFormat(dateAdd("d", 7, dt_event_date), "dd MMM yyyy")# 
                                        </p>
                                    <cfelseif str_recurrence_type EQ "monthly">
                                        <p><strong>Next Occurrence:</strong> 
                                            #dateFormat(dateAdd("m", int_recurring_duration, dt_event_date), "dd MMM yyyy")#
                                        </p>
                                    </cfif>
            
                                    <!-- Edit Event Form -->
                                    <form action="addEvent.cfm" method="post">
                                        <input type="hidden" name="eventId" value="#id#">
                                        <input type="hidden" name="selectedDate" value="#dateFormat(selectedDate, 'yyyy-mm-dd')#">
                                        <button type="submit" class="btn btn-warning">Edit</button>
                                    </form>
            
                                    <!-- Delete Event Form -->
                                    <form action="deleteEvent.cfm" method="post">
                                        <input type="hidden" name="eventId" value="#id#">
                                        <button type="submit" class="btn btn-danger">Delete</button>
                                    </form>
                                </li>
                            </cfloop>
                        </ul>
                    <cfelse>
                        <p class="text-muted">No events found for this date.</p>
                    </cfif>
                    <form action="addEvent.cfm" method="post">
                        <input type="hidden" name="date" value="#dateFormat(selectedDate, 'yyyy-mm-dd')#">
                        <button type="submit" class="btn btn-primary mt-3">Add New Event</button>
                    </form>
                </main>
            </cfoutput>
         
    <cfinclude template="../footer.cfm">
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
