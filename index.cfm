<cfexecute name="speedtest-cli --json --server 8862" variable="sdata" timeout="5000" />
<cfset sdata = DeserializeJSON(sdata) />

<cfdump var="#sdata#" />