<cfcomponent displayname="speedtest" hint="Manages Collection and Dissimenation of Speed Test Data Collected" output="false">
	
	<!---
		Author: Terry Bankert		
		Copyright 2009 Terry Bankert All Rights Reserved (Framework)
		Speed Test Code Copyright 2018 RT Communications Inc.
	--->
	<cfset this.ajaxData = createObject("component","com.common.ajaxreturn")>
    <cfset manageTables()>
	<cffunction name="init" output="false">
		<!---
		<cfquery name="page" datasource="#application.db.source#" username="#application.db.user#" password="#application.db.pass#">
		</cfquery>
		--->

	</cffunction>


	<!--- Get Device ID By Mac --->    
	<cffunction name="getDeviceByMac" returntype="any" access="remote" output="no" hint="Gets All Speed Tests For A Given Mac Address">
		<cfargument name="output" required="false" default="query">
		<cfargument name="mac" required="false" default="">

        <cfquery name="device" datasource="#application.db.source#" username="#application.db.user#" password="#application.db.pass#">
		SELECT * FROM devices WHERE mac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mac#">
		</cfquery>

		<cfswitch expression="#arguments.output#">
			<cfcase value="query">
			<cfreturn tests />
			</cfcase>
			<cfcase value="xml">
			<cfset this.ajaxdata.init(tests)>
			<cfcontent type="text/xml">
			<cfreturn this.ajaxdata.returnXML() />
			</cfcase>
			<cfcase value="json">
			<cfset this.ajaxdata.init(tests)>
			<cfcontent type="text/html">
			<cfreturn this.ajaxdata.returnJSON() />				
			</cfcase>
		</cfswitch>	
	</cffunction>  


	<!--- Saves Speed Test From Specific Unit --->	
 	<cffunction name="saveTest" access="remote" output="no" returntype="any" hint="Saves Speed Test Data">
		<cfargument name="output" required="false" default="xml">
		<cfargument name="mac" required="false" default="">
        <cfargument name="upstream" required="false" default="">
		<cfargument name="downstream" required="false" default="">        
		<cfargument name="latency" required="false" default="">
        <cfargument name="taken" required="false" default="">
        <cfargument name="test_server" required="false" default="">

		<cfset sdevice = getDeviceByMac("query",arguments.mac) />
		<cfif sdevice.recordcount GT 0>
			<cfset data = structnew()>
            <cfset data.device_id = sdevice.device_id>
            <cfset data.upstream = arguments.upstream>
            <cfset data.downstream = arguments.downstream>
            <cfset data.latency = arguments.latency>
            <cfset data.test_server = arguments.test_server>
            <cfset data.taken = arguments.taken>
            <cfset data.posted = now()>


        	<cfset data.test_id = application.DataMgr.insertRecord("speedtests",data)> 
       
	
			<cfswitch expression="#arguments.output#">
				<cfcase value="xml">
				<cfcontent type="text/xml">
				<cfreturn this.ajaxdata.returnSuccessXML(data.test_id) />	
				</cfcase>
				<cfcase value="json">
				<cfcontent type="text/html">
				<cfreturn this.ajaxdata.returnSuccessJSON(data.test_id) />				
				</cfcase>		
			</cfswitch>
            <cfelse>
            
            
            </cfif>

	</cffunction>
    
	<!--- Get All Speed Tests For a Given Mac Address --->    
	<cffunction name="getSpeedTestByMac" returntype="any" access="remote" output="no" hint="Gets All Speed Tests For A Given Mac Address">
		<cfargument name="output" required="false" default="query">
		<cfargument name="mac" required="false" default="">

        <cfquery name="device" datasource="#application.db.source#" username="#application.db.user#" password="#application.db.pass#">
		SELECT * FROM devices WHERE mac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mac#">
		</cfquery>

		
        <cfquery name="tests" datasource="#application.db.source#" username="#application.db.user#" password="#application.db.pass#">
		SELECT * FROM speedtests WHERE device_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#device.device_id#">
		ORDER posted DESC;
		</cfquery>
		<cfswitch expression="#arguments.output#">
			<cfcase value="query">
			<cfreturn tests />
			</cfcase>
			<cfcase value="xml">
			<cfset this.ajaxdata.init(tests)>
			<cfcontent type="text/xml">
			<cfreturn this.ajaxdata.returnXML() />
			</cfcase>
			<cfcase value="json">
			<cfset this.ajaxdata.init(tests)>
			<cfcontent type="text/html">
			<cfreturn this.ajaxdata.returnJSON() />				
			</cfcase>
		</cfswitch>	
	</cffunction>    
 

    <cffunction name="manageTables" access="private" returntype="any">
    	<cfsavecontent variable="tbls">
        	<tables>
				<table name="speedtests">
					<field ColumnName="test_id" CF_DataType="CF_SQL_INTEGER" PrimaryKey="true" Increment="true" AllowNulls="true" />
					<field ColumnName="device_id" CF_DataType="CF_SQL_INTEGER" Default="0" AllowNulls="true" />
					<field ColumnName="upstream" CF_DataType="CF_SQL_DECIMAL" AllowNulls="true" Precision="10" Scale="4" />
					<field ColumnName="downstream" CF_DataType="CF_SQL_DECIMAL" AllowNulls="true" Precision="10" Scale="4" />
					<field ColumnName="latency" CF_DataType="CF_SQL_INTEGER" Default="0" AllowNulls="true" />
                    <field ColumnName="taken" CF_DataType="CF_SQL_Date" AllowNulls="true" />
                    <field ColumnName="test_server" CF_DataType="CF_SQL_VARCHAR" Length="200" AllowNulls="true" />
                    <field ColumnName="posted" CF_DataType="CF_SQL_TIMESTAMP" AllowNulls="true" />
				</table>  
                
 				<table name="devices">
					<field ColumnName="device_id" CF_DataType="CF_SQL_INTEGER" PrimaryKey="true" Increment="true" AllowNulls="true" />
					<field ColumnName="mac" CF_DataType="CF_SQL_VARCHAR" Length="200" AllowNulls="true" />
				</table>                
                                                                        
            </tables>
        </cfsavecontent>
  		 <cfset application.DataMgr.loadXML(tbls,true,true)>
         <cfreturn "Tables Updated" />
    	
    </cffunction>     
   
</cfcomponent>