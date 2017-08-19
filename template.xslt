<!--
	Copyright (C) 2017 Opsmate, Inc.

	This Source Code Form is subject to the terms of the Mozilla
	Public License, v. 2.0. If a copy of the MPL was not distributed
	with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

	This software is distributed WITHOUT A WARRANTY OF ANY KIND.
	See the Mozilla Public License for details.
-->
<xsl:stylesheet version="1.0"
	exclude-result-prefixes="caa xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:caa="http://xmlns.sslmate.com/caa"
	xmlns="http://www.w3.org/1999/xhtml">

	<xsl:output
		method="html"
		encoding="UTF-8"
		indent="no"
		doctype-system="about:legacy-compat"
		omit-xml-declaration="yes" />

	<xsl:param name="endpoint"/>

	<xsl:template mode="copy" match="comment()" priority="11"/>
	<xsl:template mode="copy" match="@*|node()" priority="10">
		<xsl:copy>
			<xsl:apply-templates mode="copy" select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/" priority="20">
		<xsl:apply-templates select="/caa:page"/>
	</xsl:template>
	<xsl:template match="caa:page">
		<html xml:lang="en" lang="en">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<meta name="viewport" content="width=device-width, initial-scale=1" />
				<title><xsl:value-of select="caa:title"/></title>
				<meta name="robots" content="noarchive" />
				<link rel="icon" type="image/png" href="https://sslmate.com/assets/img/favicon.png" />
				<link rel="stylesheet" type="text/css" href="style.css" />
				<script type="text/javascript">
					var caa_endpoint = '<xsl:value-of select="$endpoint"/>';
				</script>
				<xsl:apply-templates mode="copy" select="caa:head/node()"/>
			</head>
			<body>
				<a id="github_ribbon" href="https://github.com/SSLMate/caa_helper"></a>
				<div id="root">
					<div id="masthead">
						<h1>CAA Record Helper</h1>
						<p class="by">By <a href="https://sslmate.com">SSLMate</a></p>
						<ul class="nav">
							<li><a href="generate">Generate CAA Record</a></li>
							<li><a href="support">Who Supports CAA?</a></li>
							<li><a href="about">About CAA</a></li>
						</ul>
					</div>

					<xsl:apply-templates mode="copy" select="caa:body/node()"/>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template mode="copy" match="caa:ca_table" priority="20">
		<xsl:variable name="cas" select="document(@src, /)/caa:cas"/>
		<table id="{@id}">
			<thead>
				<tr>
					<td class="name_col"></td>
					<td class="type_col" colspan="2">Type of certificate</td>
				</tr>
				<tr>
					<td class="name_col"></td>
					<th class="nonwild_col">Non-Wildcard</th>
					<th class="wild_col">Wildcard</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="ca_table_row" select="$cas/caa:ca">
					<xsl:sort select="translate(caa:name, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template mode="ca_table_row" match="caa:ca">
		<xsl:variable name="identifiers">
			<xsl:call-template name="join_strings">
				<xsl:with-param name="strings" select="caa:caa"/>
			</xsl:call-template>
		</xsl:variable>
		<tr>
			<th class="name_col">
				<xsl:value-of select="caa:name"/>
				<xsl:if test="caa:aka">
					<span class="brands">
						<xsl:call-template name="join_strings">
							<xsl:with-param name="separator">, </xsl:with-param>
							<xsl:with-param name="strings" select="caa:aka"/>
						</xsl:call-template>
					</span>
				</xsl:if>
			</th>
			<td class="nonwild_col"><input type="checkbox" name="issue" value="{$identifiers}"/></td>
			<td class="wild_col"><input type="checkbox" name="issuewild" value="{$identifiers}"/></td>
		</tr>
	</xsl:template>
	<xsl:template name="join_strings">
		<xsl:param name="strings" select="/.."/>
		<xsl:param name="separator" select="' '"/>
		<xsl:for-each select="$strings">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()"><xsl:value-of select="$separator"/></xsl:if>
		</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
