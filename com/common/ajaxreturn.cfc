<cfcomponent output="false" displayname="ajaxreturn" hint="This CFC Handles Data Formatting For Return To The Processing Page It Either Returns XML OR JSON In My Desired Format">
	<!---
		A Data Utility Class That Returns Data In XML AND JSON Format For Client Side
		Consumption.  All XML And JSON Data Will Be Returned In The Same Format Throughout
		The Application.
		
		Author: Terry Bankert
		Copyright 2009 Terry Bankert All Rights Reserved
	--->
	<cffunction name="init" output="false">
	<cfargument name="cfquery" required="true" type="query">
		<cfset this.cfquery = arguments.cfquery>
        <cfreturn this>
	</cffunction>

	<!--- Return A Query In XML Format --->
	<cffunction name="returnXML" access="public" output="false" returntype="xml">
    	<!--- Generate XML --->
		<cfset MyDoc = xmlNew()>
		<cfset MyDoc.xmlRoot =  XmlElemNew(MyDoc,"dataset")>
		<cfset MyDoc.dataset.xmlChildren[1] =  XmlElemNew(MyDoc,"results")>
		<cfset MyDoc.dataset.XmlChildren[1].XmlText = "#this.cfquery.recordcount#">

		<!--- If the recordcount is greater than 0 continue --->
		<cfif this.cfquery.recordcount GT 0>
		<cfset i = 2>
    		<cfloop query="this.cfquery">		
			<cfset MyDoc.dataset.XmlChildren[i] = XmlElemNew(MyDoc,"row")>
			<cfset columni = 1>
				<cfloop list="#this.cfquery.columnlist#" index="column_name" delimiters=",">
				<cfset MyDoc.dataset.XmlChildren[i].xmlChildren[columni] = XmlElemNew(MyDoc,"#lcase(column_name)#")>
                <cfif isdate(evaluate("this.cfquery.#column_name#"))>
                	<cfif right(column_name,4) EQ "time">
                    	<cfset MyDoc.dataset.XmlChildren[i].xmlChildren[columni].XmlText = xmlformat("#timeformat(evaluate('this.cfquery.#column_name#'),'h:mm:ss tt')#")>
                    <cfelse>
                		<cfset MyDoc.dataset.XmlChildren[i].xmlChildren[columni].XmlText = xmlformat("#dateformat(evaluate('this.cfquery.#column_name#'),'YYYY-MM-DD')# #timeformat(evaluate('this.cfquery.#column_name#'),'HH:MM:SS')#")>
                    </cfif>
                <cfelse>
				<cfset MyDoc.dataset.XmlChildren[i].xmlChildren[columni].XmlText = xmlformat(evaluate("this.cfquery.#column_name#"))>
                </cfif>
				<cfset columni = columni+1>
			</cfloop>
    	<cfset i = i+1>
		</cfloop>  
    	</cfif>   
        <cfsetting enablecfoutputonly="true">
		<cfreturn trim(MyDoc) /> 
	</cffunction>

	<!--- Return A Query In JSON Format For Jquery DT--->
	<cffunction name="returnJSONDT" access="public" output="false" returntype="string">
		<cfsavecontent variable="jsondata">
		<cfprocessingdirective suppresswhitespace="yes">
		<cfoutput>{
				"dataset" : {
					"row" : [
						<cfif this.cfquery.recordcount GT 0><cfloop query="this.cfquery">[<cfloop list="#this.cfquery.columnlist#" delimiters="," index="column_name"><cfif isDate(evaluate("this.cfquery.#column_name#"))>#SerializeJSON(DateFormat(evaluate("this.cfquery.#column_name#"),'mm/dd/yyyy'))#<cfelse>#SerializeJSON(evaluate("this.cfquery.#column_name#"))#</cfif><cfif listlast(this.cfquery.columnlist,",") NEQ column_name>, </cfif></cfloop>]<cfif this.cfquery.currentrow NEQ this.cfquery.recordcount>,</cfif></cfloop></cfif> 
					],
					"results" : #this.cfquery.recordcount#
				}
			}</cfoutput></cfprocessingdirective>
		</cfsavecontent>
		<cfreturn trim(jsondata) />
	</cffunction>
    
	<!--- Return A Query In JSON Format --->
	<cffunction name="returnJSON" access="public" output="false" returntype="string">
		<cfsavecontent variable="jsondata">

		<cfoutput>{
				"dataset" : {
					"row" : [
						<cfif this.cfquery.recordcount GT 0><cfloop query="this.cfquery">{<cfloop list="#this.cfquery.columnlist#" delimiters="," index="column_name">"#lcase(column_name)#": <cfif isDate(evaluate("this.cfquery.#column_name#"))>#SerializeJSON(DateFormat(evaluate("this.cfquery.#column_name#"),'mm/dd/yyyy'))#<cfelse>#SerializeJSON(evaluate("this.cfquery.#column_name#"))#</cfif><cfif listlast(this.cfquery.columnlist,",") NEQ column_name>, </cfif></cfloop>}<cfif this.cfquery.currentrow NEQ this.cfquery.recordcount>,</cfif></cfloop></cfif> 
					],
					"results" : #this.cfquery.recordcount#
				}
			}</cfoutput>
		</cfsavecontent>
		<cfreturn trim(jsondata) />
	</cffunction>
    
	<cffunction name="returnErrorXML" access="public" output="false" returntype="xml">

	</cffunction>

	<cffunction name="returnErrorJSON" access="public" output="false" returntype="string">
		<cfsavecontent variable="jsondata">
		<cfoutput>{
				"message" : {
					"errors" : [
					<cfloop query="this.cfquery">{"id" : #SerializeJSON(this.cfquery.id)#, "msg" : #SerializeJSON(this.cfquery.msg)#}<cfif this.cfquery.currentrow NEQ this.cfquery.recordcount>,</cfif></cfloop> 
					],
					"success" : "false"
				}
			}</cfoutput>
		</cfsavecontent>
		<cfreturn trim(jsondata) />
	</cffunction>
	<cffunction name="returnSuccessXML" access="public" output="false" returntype="xml">
		<cfargument name="id" required="false" default="0">
		<cfset MyDoc = xmlNew()>
		<cfset MyDoc.xmlRoot =  XmlElemNew(MyDoc,"message")>
		<cfset MyDoc.message.XmlAttributes =  XmlElemNew(MyDoc,"success")>
	    <cfset MyDoc.message.XmlAttributes['success'] =  'true'>      
		<cfset MyDoc.message.xmlChildren[1] =  XmlElemNew(MyDoc,"errors")> 
        <cfset MyDoc.message.xmlChildren[2] =  XmlElemNew(MyDoc,"id")>
        <cfset MyDoc.message.xmlChildren[2].XmlText = arguments.id> 
        <cfsetting enablecfoutputonly="true">
		<cfreturn trim(MyDoc) />
	</cffunction>

	<cffunction name="returnSuccessJSON" access="public" output="false" returntype="string">
		<cfargument name="id" required="false" default="0">
		<cfsavecontent variable="jsondata">
		<cfoutput>{
				"message" : {
					"errors" : [ 
					],
					"success" : "true",
					"id" : #arguments.id#
				}
			}</cfoutput>
		</cfsavecontent>
		<cfreturn trim(jsondata) />
	</cffunction>
    
    <cffunction name="jsonFormat" access="private" returntype="any" hint="formats json so that it can be parsed by a client side json reader">
    <cfargument name="json_data" required="yes">
    <cfreturn (
	"""" &
	ToString( ARGUMENTS.json_data ).ReplaceAll(
		"(['""\\\/\n\r\t]{1})",
		"\\$1"
		) &
	""""
	) />
    </cffunction>

</cfcomponent>