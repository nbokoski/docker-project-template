<cfparam name="attributes.exception">
<cfparam name="attributes.diagnostics">
<cfparam name="attributes.stats">

<cfoutput encodefor="html">

<h3>Error Details:</h3>
<ul>
	<li><strong>Server</strong>: #application.serverName#</li>
	<li><strong>Client Location:</strong> #CGI.REMOTE_ADDR#</li>
	<li><strong>Client Browser:</strong> #CGI.HTTP_USER_AGENT#</li>
	<li><strong>Date and Time the Error Occurred:</strong> #Now()#</li>
	<li><strong>Page Client Came From:</strong> #CGI.HTTP_REFERER#</li>
	<li><strong>Error In Template:</strong> #CGI.SCRIPT_NAME#</li>
</ul>

<table border="1" width="85%" cellpadding="6">
	<tr><td>#attributes.diagnostics#</td></tr>
	<tr><td><pre>#attributes.exception#</pre></td></tr>
	<tr><td>
	<cfloop from="1" to="#ArrayLen(attributes.exception.TagContext)#" index="i">
		#attributes.exception.TagContext[i].Template# : #attributes.exception.TagContext[i].Line# <br>
	</cfloop>
	</td></tr>
</table>

<table border="1" width="85%" cellpadding="6">
	<tr>
		<td>
			<ul>
				<cfloop collection="#session#" item="key">
					<li>session.#key# = #application.singleton.error.emailOutputConfiguration(scope=session, key=key)#</li>
				</cfloop>
				<cfloop collection="#request#" item="key">
					<li>request.#key# = #application.singleton.error.emailOutputConfiguration(scope=request, key=key)#</li>
				</cfloop>
			</ul>
		</td>
	</tr>
	<tr>
		<td>
			<ul>
				<cfloop collection="#attributes.stats#" item="topkey">
					<cfif isSimpleValue(attributes.stats[topkey])>
						<li>#topkey# = #attributes.stats[topkey]#</li>
					<cfelse>
						<cfloop collection="#attributes.stats[topkey]#" item="midkey">
							<li>#topkey#.#midkey# = #attributes.stats[topkey][midkey]#</li>
						</cfloop>
					</cfif>
				</cfloop>
			</ul>
		</td>
	</tr>

	<cfif attributes.exception.keyExists("StackTrace")>
		<tr><td><pre>#attributes.exception.StackTrace#</pre></td></tr>
	</cfif>
</table>

</cfoutput>
