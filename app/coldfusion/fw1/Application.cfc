component {
	this.name = "TestApp";
	this.timeout = 60;
	this.clientManagement = false;
	this.sessionManagement = true;
	this.applicationTimeout = CreateTimeSpan(5, 0, 0, 0);
	this.sessionTimeout = CreateTimeSpan(0, 12, 0, 0);
	this.setClientCookies = false;
	this.sameformfieldsasarray = false;
	this.scriptProtect = "all";
	this.compileExtForInclude = "cfm";

	/********************** Public functions **********************/

	public boolean function onApplicationStart() {
		_configureApplication();
		_instantiateSingletons();

		return true;
	}
	
	public boolean function onRequestStart(required string targetPage) {
		// Reload application settings:
		if (url.keyExists("reload")) {
			lock timeout="1" scope="application" type="exclusive" throwontimeout="yes" {
				_configureApplication();
				_instantiateSingletons();
			}
		}

		return true;
	}

	public void function onRequest(required string targetPage) {
		include arguments.targetPage;
	}

	public void function onRequestEnd(required string targetPage) {}

	public void function onError(required any exception, required string eventName) {
		local.exception = isDefined("arguments.exception.rootCause") ? arguments.exception.rootCause : arguments.exception;

		if (application.env == "production") {
			application.singleton.error.email(exception=local.exception);
		} else {
			writedump(local.exception);
			abort;
		}

		location(url="/error.cfm", addToken=false);
	}

	/********************** Private functions **********************/

	private void function _configureApplication() {
		application.env = "development";
		application.serverName	= createObject('java', 'java.net.InetAddress').localhost.getCanonicalHostName();
		application.email = {
			"noreply"	= "noreply@testapp.com",
			"errors"	= "errors@testapp.com"
		};
	}

	private void function _instantiateSingletons() {
		application.singleton.error = new components.util.error();
	}

}
