<cfcomponent
	displayname="Application"
	output="false"
	hint="Handle the application.">
 
 
	<!--- Set up the application. --->
	<cfset THIS.Name = "raspeed" />
	<cfset THIS.SessionManagement = true />
	<cfset THIS.SetClientCookies = true />
    <cfset THIS.scriptProtect = "none" />
    <cfset THIS.LoginStorage = "session" />
    <cfset THIS.SessionTimeOut = CreateTimeSpan(0, 2, 0, 0)>
     

    
  
 
	<!--- Define the page request properties. --->
	<cfsetting
		requesttimeout="20"
		showdebugoutput="false"
		enablecfoutputonly="false"
		/>
 
 	
	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires when the application is first created.">
        <cfset application.db = structnew()>
        <cfset application.db.source ="speedtest">
        <cfset application.db.user = "raspeed">
        <cfset application.db.pass = "Tp=pX7tK*b">

        <cfset application.DataMgr = CreateObject("component", "com.datamgr.DataMgr").init(application.db.source, "MYSQL", application.db.user, application.db.pass)>
			<cfreturn true />
	</cffunction>
 
 
 
 
	<cffunction
		name="OnRequestStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires at first part of page processing.">
 
		<!--- Define arguments. --->
		<cfargument
			name="TargetPage"
			type="string"
			required="true"
			/>

            
					

		<cfreturn true />
	</cffunction>
 
<!--- 
	<cffunction
		name="OnRequest"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after pre page processing is complete.">
 
		<!--- Define arguments. --->
		<cfargument
			name="TargetPage"
			type="string"
			required="true"
			/>
 
		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 --->
	<cffunction
		name="OnRequestEnd"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after the page processing is complete.">
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	 
	<cffunction
		name="OnApplicationEnd"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the application is terminated.">
 
		<!--- Define arguments. --->
		<cfargument
			name="ApplicationScope"
			type="struct"
			required="false"
			default="#StructNew()#"
			/>
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
<cffunction name="onSessionStart" returnType="void" output="false">

</cffunction> 

<cffunction name="onSessionEnd" returnType="void" output="false">
    <cfargument name="sessionScope" type="struct" required="true">
    <cfargument name="appScope" type="struct" required="false">
    

</cffunction>
 
</cfcomponent>







