component {
    this.name = "AddressBook";
    this.applicationTimeout = createTimeSpan(0, 2, 0, 0);
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0, 0, 30, 0);
    this.datasource = "dsn_address_book";
    
    // ORM Settings
    this.ormEnabled = true;
    this.ormSettings = {
        cfclocation = "models",
        dbcreate = "update", 
        logSQL = true,
        flushAtRequestEnd = false,
        autoManageSession = false
    };

    // Application startup
    function onApplicationStart() {
        application.started = now();
        return true;
    }

    // Session startup
    function onSessionStart() {
        session.str_user_name = "";
        session.int_user_id = "";
        return true;
    }
    
    
}
