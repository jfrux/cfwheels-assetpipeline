<cfcomponent output="false">

	<cffunction name="init" access="public" output="false">
		<cfscript>
			this.version = "1.1.5";
			application.assets = [];

			$directoryCopy(source="templates/",destination="../../",nameConflict="skip");
		</cfscript>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="styleSheetLinkTag" access="public" output="false" returntype="string" mixin="controller">	
		<cfargument name="sources" type="string" required="false" default="" />
		<cfargument name="type" type="string" required="false" default="#application.wheels.functions.styleSheetLinkTag.type#" />
		<cfargument name="media" type="string" required="false" default="#application.wheels.functions.styleSheetLinkTag.media#" />
		<cfargument name="debug" type="boolean" required="false" default="false" />
		<cfreturn $callOriginalIncludeMethod($includeMethod="styleSheetLinkTag", $fileType="css", argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="javaScriptIncludeTag" access="public" output="false" returntype="string" mixin="controller">
		<cfargument name="sources" type="string" required="false" default="" />
		<cfargument name="type" type="string" required="false" default="#application.wheels.functions.javaScriptIncludeTag.type#" />
		<cfargument name="debug" type="boolean" required="false" default="false" />

		<cfreturn $callOriginalIncludeMethod($includeMethod="javaScriptIncludeTag", $fileType="js", argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="$callOriginalIncludeMethod" access="public" output="false" returntype="string" mixin="controller">
		<cfargument name="$includeMethod" type="string" required="true" />
		<cfargument name="$fileType" type="string" required="true" />
		<cfargument name="sources" type="string" required="true" />
		<cfargument name="type" type="string" required="true" />
		<cfargument name="debug" type="string" required="false" default="false" />
		<cfscript>
			var originalIncludeMethod = core[arguments.$includeMethod];
			
			if (not ListFindNoCase("production,testing", application.wheels.environment))
			{
				if (not Len(arguments.sources))
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
	
	<cffunction name="$directoryCopy" output="true" access="public">
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
				<cffile action="copy" source="#arguments.source#/#name#" destination="#arguments.destination#/#name#" nameconflict="#arguments.nameConflict#">
			<cfelseif contents.type eq "dir">
				<cfset $directoryCopy(arguments.source & "/" & name, arguments.destination & "/" &  name) />
			</cfif>
		</cfloop>
	</cffunction>
	
</cfcomponent>