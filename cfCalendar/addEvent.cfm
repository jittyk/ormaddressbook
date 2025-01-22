<cfinclude template="addEventAction.cfm">
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Event</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
         
    </head>
    <body>
        <cfinclude template="../header.cfm">
         <cfoutput>
        <main class="container">
        <h2>Add New Event</h2>
      <div class="text-center">
            <cfif len(variables.strSuccessMsg)>
                <div style="color: green;">#variables.strSuccessMsg#</div>  
            <cfelse>
                <div style="color: red;">#variables.strErrorMsg#</div>  
            </cfif>
        </div>
    
        <form action="" method="POST" class="container">
            
            <cfif variables.int_event_id NEQ 0>
                <input type="hidden" name="int_event_id" value="#variables.int_event_id#">
                
            <cfelse>
                <input type="hidden" name="int_event_id" value="0">
            </cfif>
        
                <div class="mb-3 row">
                    <label for="str_event_title" class="col-sm-2 col-form-label">Event Title</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" name="str_event_title" id="str_event_title" 
                            placeholder="Event name.." value="#variables.str_event_title#" required>
                    </div>
                </div>

               
                
            </div>
            <div class="mb-3 row">
                <label for="str_description" class="col-sm-2 col-form-label">Event Description</label>
                <div class="col-sm-10"> 
                    <input type="text" class="form-control" name="str_description" id="str_description" 
                    placeholder="Event description.." value="#variables.str_description#" required>
                </div>
                
            </div>
            <div class="mb-3 row">
                <label for="dt_event_date" class="col-sm-2 col-form-label">Event Date</label>
                <div class="col-sm-10">
                    <input type="date" class="form-control" name="dt_event_date" id="dt_event_date" 
                    value="#variables.dt_event_date#" required>
                </div>
            </div>
        
            <div class="mb-3 row">
                <label for="str_reminder_email" class="col-sm-2 col-form-label">Reminder Email </label>
                <div class="col-sm-10">
                    <input type="email" class="form-control" name="str_reminder_email" id="str_reminder_email" placeholder="Email.." value="#variables.str_reminder_email#">
                </div>
            </div>
        
            
        
            <div class="mb-3 row">
                <label for="str_priority" class="col-sm-2 col-form-label">Priority</label>
                <cfif structKeyExists(variables, "str_priority")>
                    <cfset selectedPriority = variables.str_priority>
                <cfelse>
                    <cfset selectedPriority = "low"> 
                </cfif>
                
                <div class="col-sm-10">
                    <select name="str_priority" id="str_priority"  class="form-control">
                        <option value="" disabled
                        <cfif NOT structKeyExists(variables, "str_priority") OR NOT len(variables.str_priority)>
                            selected="selected"
                        </cfif>
                        >
                            Select Priority
                        </option>
                        <option value="low" 
                            <cfif structKeyExists(variables, "str_priority") AND variables.str_priority EQ "low">
                                selected="selected"
                            </cfif>
                        >Low</option>
                    
                        <option value="medium" 
                            <cfif structKeyExists(variables, "str_priority") AND variables.str_priority EQ "medium">
                                selected="selected"
                            </cfif>
                        >Medium</option>
                    
                        <option value="high" 
                            <cfif structKeyExists(variables, "str_priority") AND variables.str_priority EQ "high">
                                selected="selected"
                            </cfif>
                        >High</option>
                    </select>
                    
                </div>
                
            </div>
        
            <div class="mb-3 row ">
                <label for="str_recurrence_type" class="col-sm-2 col-form-label">Recurring Event</label>
                <div class="col-sm-10 ">
                    <select name="str_recurrence_type" id="str_recurrence_type" class="form-control">
                        <option value="none" <cfif variables.str_recurrence_type EQ "none">selected</cfif>>None</option>
                        <option value="daily" <cfif variables.str_recurrence_type EQ "daily">selected</cfif>>Daily</option>
                        <option value="weekly" <cfif variables.str_recurrence_type EQ "weekly">selected</cfif>>Weekly</option>
                        <option value="monthly" <cfif variables.str_recurrence_type EQ "monthly">selected</cfif>>Monthly</option>
                    </select>
                    
                </div>
            </div>
            <div id="weeklyDays" style="display:none;">
                <div class="mb-3 row">
                    <label for="days_of_week" class="col-sm-2 col-form-label">Days of the Week</label>
                    <div class="col-sm-10">
                        <select name="days_of_week" id="days_of_week" class="form-control" multiple>
                            <option value="monday">Monday</option>
                            <option value="tuesday">Tuesday</option>
                            <option value="wednesday">Wednesday</option>
                            <option value="thursday">Thursday</option>
                            <option value="friday">Friday</option>
                            <option value="saturday">Saturday</option>
                            <option value="sunday">Sunday</option>
                        </select>
                    </div>
                </div>
            </div>
            
            <div id="monthlyDays" style="display:none;">
                <div class="mb-3 row">
                    <label for="days_of_month" class="col-sm-2 col-form-label">Days of the Month</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" name="days_of_month" id="days_of_month" placeholder="e.g. 1,15,30">
                    </div>
                </div>
            </div>
            <div class="mb-3 row">
                <label for="int_recurring_duration" class="col-sm-2 col-form-label">Duration (Months)</label>
                <div class="col-sm-10">
                    <input type="number" class="form-control" name="int_recurring_duration" id="int_recurring_duration" placeholder="Enter duration in months" min="1" value="#variables.int_recurring_duration#">
                </div>
            </div>
        
            <div class="mb-3 row">
                <label for="variables.str_time_constraint" class="col-sm-2 col-form-label">Event Time</label>
                <div class="col-sm-10">
                    <select name="variables.str_time_constraint" id="variables.str_time_constraint" class="form-control">
                        <option value="" disabled <cfif NOT structKeyExists(variables, "str_time_constraint") OR NOT len(variables.str_time_constraint)>selected</cfif>>Select Time Option</option>
                        <option value="full_day" <cfif variables.str_time_constraint EQ "full_day">selected</cfif>>Full Day</option>
                        <option value="half_day" <cfif variables.str_time_constraint EQ "half_day">selected</cfif>>Half Day</option>
                        <option value="custom" <cfif variables.str_time_constraint EQ "custom">selected</cfif>>Custom</option>
                    </select>
                    
                </div>
            </div>

            <div id="customTimeFields" style="display:none;">
                <div class="mb-3 row">
                    <label for="start_time" class="col-sm-2 col-form-label">Start Time</label>
                    <div class="col-sm-10">
                        <input type="time" class="form-control" name="start_time" id="start_time" value="#variables.dt_start_time#">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="end_time" class="col-sm-2 col-form-label">End Time</label>
                    <div class="col-sm-10">
                        <input type="time" class="form-control" name="end_time" id="end_time" value="#variables.dt_end_time#">
                    </div>
                </div>
            </div>
        
            <div class="mb-3 row">
                <div class="col-sm-10 offset-sm-2 d-flex justify-content-end">
                    <input type="hidden" name="eventId" value="#int_event_id#">
                    <button type="reset" class="btn btn-secondary me-2">Reset</button>
                    <button type="submit" class="btn btn-primary">Save Event</button>
                </div>
            </div>
        </form>
        
        </main>
        
    </cfoutput>
        <cfinclude template="../footer.cfm">
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const recurrenceSelect = document.getElementById("str_recurrence_type");
                const weeklyDiv = document.getElementById("weeklyDays");
                const monthlyDiv = document.getElementById("monthlyDays");

                function toggleRecurrenceFields() {
                    const selectedValue = recurrenceSelect.value;
                    weeklyDiv.style.display = selectedValue === "weekly" ? "block" : "none";
                    monthlyDiv.style.display = selectedValue === "monthly" ? "block" : "none";
                }

                // Initial call to set visibility based on the current selection
                toggleRecurrenceFields();

                // Add event listener to toggle fields on change
                recurrenceSelect.addEventListener("change", toggleRecurrenceFields);
            });

            document.addEventListener("DOMContentLoaded", function() {
                const timeConstraintSelect = document.getElementById("variables.str_time_constraint");
                const customTimeFields = document.getElementById("customTimeFields");

                function toggleCustomTimeFields() {
                    const selectedValue = timeConstraintSelect.value;
                    customTimeFields.style.display = selectedValue === "custom" ? "block" : "none";
                }

                // Initial call to set visibility based on the current selection
                toggleCustomTimeFields();

                // Add event listener to toggle fields on change
                timeConstraintSelect.addEventListener("change", toggleCustomTimeFields);
            });
        </script>
    </body>
    </html>
    