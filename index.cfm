<h1>Asset Pipeline</h1>

<p>
	A Rails 3.1-style Asset Pipeline for CFWHEELS
</p>

<h1>Installation</h1>
<p>
	Follow the installation instructions:<br>
	<a href="http://github.com/joshuairl/cfwheels-assetpipeline">http://github.com/joshuairl/cfwheels-assetpipeline</a>
</p>

<p>This plugin will override existing functionality within the Wheels core API and add ruby libraries called Rake and Sprockets.</p>

<pre>
... in /events/onApplicationStart.cfm

&lt;cfset generateBundle(type="css", bundle="bundles/core", compress=true, sources="screen,liquid,style") /&gt;	

... in your layout file - maybe /views/layout.cfm

#styleSheetLinkTag(bundle="bundles/core")#
</pre>
<p>
	When in the assetDebug mode the code about will output <code>&lt;link /&gt;</code> tags for each source listed. If assetDebug mode is off (default) you will have one script and link tag referencing application.js and application.css.  These files will include directives which then start the dependency chains for the rest of your assets.
	<br>
	<br>
	This keeps you from having to reload your app all the time just to get your newest JS files.
</p>

<h2>Overridden Methods</h2>
<ul>
	<li>styleSheetLinkTag
		<ul>
			<li><strong>sources</strong> - a list of stylesheet files that you would like included on the page.</li>
			<li><strong>type</strong> - The type of file. Defaults to <code>application.wheels.styleSheetLinkTag.type</code>.</li>
			<li><strong>media</strong> - The media type to apply the CSS to. Defaults to <code>application.wheels.styleSheetLinkTag.media</code></li>
			<li><strong>debug</strong> - (default: false) While in debug mode, pipeline will add a single script tag for each asset dependency found within the root file.</li>
		</ul>
	</li>
	<li>javaScriptIncludeTag</li>
		<ul>
			<li><strong>sources</strong> - a list of stylesheet files that you would like included on the page.</li>
			<li><strong>type</strong> - The type of file. Defaults to <code>application.wheels.javaScriptIncludeTag.type</code>.</li>
			<li><strong>debug</strong> - (default: false) While in debug mode, pipeline will add a single script tag for each asset dependency found within the root file.</li>
		</ul>
</ul>

<h2>How to Use</h2>
<p>
	For usage instructions,<br>
	visit http://github.com/joshuairl/cfwheels-assetpipeline
</p>

<h2>Uninstallation</h2>
<p>To uninstall this plugin simply delete the <tt>/plugins/AssetPipeline-0.x.zip</tt> file.</p>

<h2>Credits</h2>
<p>This plugin was created by <a href="http://joshuairl.com">Joshua F. Rountree</a>.</p>


<p><a href="<cfoutput>#cgi.http_referer#</cfoutput>">&lt;&lt;&lt; Go Back</a></p>