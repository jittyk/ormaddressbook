<cfapplication  
    name="AddressBookApp" 
    sessionManagement="true" 
    setClientCookies="true" 
    sessionTimeout="#CreateTimeSpan(0, 0, 30, 0)#">

<cfparam name="session.isLoggedIn" default="false">
<cfparam name="session.permissionList" default=""> 
<cfparam name="session.str_user_name" default="">
<cfset this.ormEnabled = true>
    <cfset this.datasource = "dsn_address_book">
    <cfcomponent>
        <cfset this.ormEnabled = true>
        <cfset this.ormSettings = { ... }>
    </cfcomponent>