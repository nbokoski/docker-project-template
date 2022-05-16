component name="Error" output=false {

	/********************** Constructors **********************/
	
	public error function init() {
		this.sensitiveKeys = "";

		return this;
	}

	/********************** Public functions **********************/

	public void function email(required any exception) {
		local.diagnostics = arguments.exception.message & " " & arguments.exception.detail;
		local.subject = "Error - " & application.serverName & " - " & left(diagnostics, 100);

		savecontent variable="body" {
			cfmodule(
				template	= "/templates/emails/error.cfm",
				exception	= arguments.exception,
				diagnostics	= local.diagnostics,
				stats		= _serverStats()
			);
		};

		local.mailerService = new mail(to=application.email.errors, from=application.email.noreply, subject=subject);
		mailerService.addPart(type="text", charset="utf-8", body=body);
		mailerService.addPart(type="html", charset="utf-8", body=body);
		mailerService.send();
	}

	public string function emailOutputConfiguration(required any scope, required any key) {
		local.output = arguments.scope[arguments.key];

		if (!isSimpleValue(arguments.scope[arguments.key]))
			output = "[ complex value ]";
		if (this.sensitiveKeys.findNoCase(arguments.key))
			output = "[ redacted ]";

		return output;
	}

	/********************** Private functions **********************/

	private struct function _serverStats() {
		return {
			coldfusion = _coldfusionServerData()
			// database = _databasePoolStats(),
			// load = _getMetricData('simple_load'),
			// perf = _getMetricData('perf_monitor'),
			// avgRequestTime = _getMetricData('avg_req_time'),
			// prevRequestTime = _getMetricData('prev_req_time')
		};
	}

	private struct function _coldfusionServerData() {
		local.servlet = CreateObject('java', 'coldfusion.CfmServlet').getCfmServlet();
		local.res = {
			running = servlet.getRequestsRunning(),
			queued = servlet.getRequestsQueued(),
			timedout = servlet.getRequestsTimedout(),
			limit = servlet.getRequestLimit()
		};

		return res;
	};

	private struct function _databasePool(required string datasource) {
		local.pool = CreateObject('java', 'coldfusion.server.j2ee.sql.pool.JDBCManager').getInstance().getPool(arguments.datasource);
		local.res = {
			count = pool.getPoolCount(),
			checkedOut = pool.getCheckedOutCount()
		};

		return res;
	}

	private struct function _getMetricData(required string metric) {
		return GetMetricData(arguments.metric);
	}
}
