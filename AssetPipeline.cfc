<cfcomponent output="false">

	<cffunction name="init" access="public" output="false">
		<cfscript>
			this.version = "1.1.5";
			application.assets = {};
			application.assets['js'] = [];
			application.assets['css'] = [];
			application.wheels.assetHost = "localhost";
			application.wheels.assetPort = "3000";
			application.wheels.assetPaths = {
				http = "#application.wheels.assetHost#:#application.wheels.assetPort#/assets",
				https = "#application.wheels.assetHost#:#application.wheels.assetPort#/assets"
			};
			application.wheels.javascriptPath = "";
			application.wheels.stylesheetPath = "";
			application.wheels.formats['CSS'] = "text/css";
			application.wheels.formats['JS'] = "application/javascript";
			$directoryCopy(source="templates/",destination="../../",nameConflict="skip");
		</cfscript>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="styleSheetLinkTag" access="public" output="false" returntype="string" mixin="controller">	
		<cfargument name="sources" type="string" required="false" default="" hint="The name of one or many CSS files in the `stylesheets` folder, minus the `.css` extension. (Can also be called with the `source` argument.)">
		<cfargument name="type" type="string" required="false" hint="The `type` attribute for the `link` tag.">
		<cfargument name="media" type="string" required="false" hint="The `media` attribute for the `link` tag.">
		<cfargument name="head" type="string" required="false" hint="Set to `true` to place the output in the `head` area of the HTML page instead of the default behavior, which is to place the output where the function is called from.">
		<cfargument name="delim" type="string" required="false" default="," hint="the delimiter to use for the list of stylesheets">
		<cfargument name="debug" type="boolean" required="false" default="false" />

		<cfscript>
			var loc = {};
			$args(name="styleSheetLinkTag", args=arguments, combine="sources/source/!", reserved="href,rel");
			arguments.rel = "stylesheet";
			loc.returnValue = "";
			arguments.sources = $listClean(list=arguments.sources, returnAs="array", delim=arguments.delim);
			loc.iEnd = ArrayLen(arguments.sources);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = arguments.sources[loc.i];
				if (ReFindNoCase("^https?:\/\/", loc.item))
				{
					arguments.href = arguments.sources[loc.i];
				}
				else
				{
					arguments.href = application.wheels.webPath & application.wheels.stylesheetPath & loc.item;
					if (!ListFindNoCase("css,cfm", ListLast(loc.item, ".")))
						arguments.href = arguments.href & ".css";
					arguments.href = $assetDomain(arguments.href) & $appendQueryString();
				}
				loc.returnValue = loc.returnValue & $tag(name="link", skip="sources,head,delim", close=true, attributes=arguments) & chr(10);
			}
			if (arguments.head)
			{
				$htmlhead(text=loc.returnValue);
				loc.returnValue = "";
			}
			</cfscript>
			<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="javaScriptIncludeTag" access="public" output="false" returntype="string" mixin="controller">
		<cfargument name="sources" type="string" required="false" default="" hint="The name of one or many JavaScript files in the `javascripts` folder, minus the `.js` extension. (Can also be called with the `source` argument.)">
		<cfargument name="type" type="string" required="false" hint="The `type` attribute for the `script` tag.">
		<cfargument name="head" type="string" required="false" hint="See documentation for @styleSheetLinkTag.">
		<cfargument name="delim" type="string" required="false" default="," hint="the delimiter to use for the list of stylesheets">
		<cfargument name="debug" type="boolean" required="false" default="false" />
		
		<cfscript>
			var loc = {};
			$args(name="javaScriptIncludeTag", args=arguments, combine="sources/source/!", reserved="src");
			loc.returnValue = "";
			arguments.sources = $listClean(list=arguments.sources, returnAs="array", delim=arguments.delim);
			loc.iEnd = ArrayLen(arguments.sources);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = arguments.sources[loc.i];
				if (ReFindNoCase("^https?:\/\/", loc.item))
				{
					arguments.src = arguments.sources[loc.i];
				}
				else
				{
					arguments.src = application.wheels.webPath & application.wheels.javascriptPath & loc.item;
					if (!ListFindNoCase("js,cfm", ListLast(loc.item, ".")))
						arguments.src = arguments.src & ".js";
					arguments.src = $assetDomain(arguments.src) & $appendQueryString();
				}
				loc.returnValue = loc.returnValue & $element(name="script", skip="sources,head,delim", attributes=arguments) & chr(10);
			}
			if (arguments.head)
			{
				$htmlhead(text=loc.returnValue);
				loc.returnValue = "";
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="$callOriginalIncludeMethod" access="public" output="false" returntype="string" mixin="controller">
		<cfargument name="$includeMethod" type="string" required="true" />
		<cfargument name="$fileType" type="string" required="true" />
		<cfargument name="sources" type="string" required="true" />
		<cfargument name="type" type="string" required="true" />
		<cfargument name="debug" type="string" required="false" default="false" />
		<cfscript>
			var originalIncludeMethod = core[arguments.$includeMethod];
			if (not arguments.debug) {
				//arguments.sources = "application.$arguments.fileType$";
				return originalIncludeMethod(argumentCollection=arguments);
			} else {
				arguments.sources = application.assets[arguments.$fileType].sources;
				return originalIncludeMethod(argumentCollection=arguments);
			}

			if (not Len(arguments.sources))
				arguments.sources = application.assets[arguments.$fileType].sources;
				return originalIncludeMethod(argumentCollection=arguments);
			
			StructDelete(arguments, "$includeMethod");
			StructDelete(arguments, "$fileType");
			StructDelete(arguments, "debug");
			StructDelete(arguments, "source");
		</cfscript>
		<cfreturn originalIncludeMethod(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="isDigestAvailable">
		<cfreturn (manifest = Sprockets.manifest) && (manifest.assets[logical_path + "." + ext]) />
	</cffunction>

	<cffunction name="$renderAsset" output="true" access="public">
		<cfargument name="asset" type="string" required="yes" />

		<cfhttp url="http://#get('assetsHost')#:#get('assetsPort')#/#arguments.asset#" result="res" method="get" >

		</cfhttp>
		<cfdump var="#res#" abort />
	</cffunction>

	<cffunction name="$directoryCopy" output="false" access="public">
		<cfargument name="source" required="true" type="string">
		<cfargument name="destination" required="true" type="string">
		<cfargument name="ignore" required="false" type="string" default="">
		<cfargument name="nameconflict" required="true" default="overwrite">

		<cfset var contents = "" />
		
		<cfif not(directoryExists(arguments.destination))>
			<cfdirectory action="create" directory="#arguments.destination#">
		</cfif>
		
		<cfdirectory action="list" directory="#arguments.source#" name="contents">

		<cfif len(arguments.ignore)>
			<cfquery dbtype="query" name="contents">
			select * from contents where name not in(#ListQualify(arguments.ignore, "'")#)
			</cfquery>
		</cfif>
		
		<cfloop query="contents">
			<cfif contents.type eq "file">
				<cfif NOT fileExists("#arguments.destination#/#name#")>
					<cffile action="copy" source="#arguments.source#/#name#" destination="#arguments.destination#/#name#" nameconflict="#arguments.nameConflict#">
				</cfif>
			<cfelseif contents.type eq "dir">
				<cfset $directoryCopy(arguments.source & "/" & name, arguments.destination & "/" &  name) />
			</cfif>
		</cfloop>
	</cffunction>
	
</cfcomponent>