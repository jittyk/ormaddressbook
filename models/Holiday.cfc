
<cfcomponent persistent="true" table="tbl_holidays" entityname="Holiday">
    <cfproperty name="int_holiday_id" fieldtype="id" generator="native">
    <cfproperty name="int_month" column="int_month" type="numeric">
    <cfproperty name="int_day" column="int_day" type="numeric">
    <cfproperty name="str_holiday_title" column="str_holiday_title" type="string">
</cfcomponent>