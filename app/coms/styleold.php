<?

/*
$bgcolor="#3fffff";
$textcolor="#0000ff";
$bigtitlecolor="#ff0000";
$linecolor="#ff0000";
$bordercolor="#af3377";
$errorcolor="#ff0000";
*/

$bgcolor="#ffff80";
$textcolor="#0000ff";
//$bigtitlecolor="#ff0000";
$bigtitlecolor="#0000ff";
$linecolor="#0000ff";
$bordercolor="#0000ff";
$errorcolor="#ff0000";

//$inputbgcolor = "#fff080";
$inputbgcolor = "#ffffb6";


/*
$cell1color = "#ddffff";
$cell2color = "#ffddff";
$cell3color = "#ffffdd";
*/

$cell1color = "#e0e070";
$cell2color = "#fff080";
$cell3color = "#ffffb6";

//$cell4color = "#ffff00";
//$cell4color = "#b6b6ff";
$cell4color = "#ffff50";

$cell5color = "#dddd00";

$cell6color = "#b6ffb6";
$cell7color = "#ddffdd";

$cell8color = "#ffb6b6";

$selection1color = "#cc0000";
$selection1bgcolor = "#ccffff";

$selection2color = "#cc0000";
$selection2bgcolor = "#ffffb6";

$selection3color = "#000000";
$selection3bgcolor = "#ccccff";
$selection3bgcolor = "#eeeeff";


$col1 = "#FFEFD0";
$col2 = "#FFF6DF";
$col3 = "#6E4F6E";


	$bgcolor="#ffffe5";
//	$bgcolor="#e5ffff";
//	$bgcolor="#ffe5ff";
	$bgcolor="#9FCFFF";
//	$bgcolor="#f7f7ff";
	$bgcolor="#ffffff";

	$textcolor="#333300";
//	$textcolor="#003333";
//	$textcolor="#330033";
	$textcolor="#1B27B3";
//	$textcolor="#1F2DCC";

	$inputbgcolor = "#ffffb6";
//	$inputbgcolor = "#b6ffff";
//	$inputbgcolor = "#ffb6ff";
//	$inputbgcolor = "#ffddff";
	$inputbgcolor = "#B0F0FF";
	$inputbgcolor = "#ffffff";

	$invinputbgcolor = "#444411";
//	$invinputbgcolor = "#114444";
//	$invinputbgcolor = "#441144";
	$invinputbgcolor = "#2c38c4";

$linecolor=$textcolor;
$bordercolor=$textcolor;



print <<<ENDTEXT

<style type="text/css"><!--
body {
 background-color : $bgcolor;
 margin: 0;
}

body, h4, table, td, th, tr, a {
 font-family : arial, sans-serif;
 font-size : 10pt;
 color: $textcolor;
}

.bigtitle {
 font-size : 32pt;
 font-family: ccursive, serif;
 color: $bigtitlecolor;
 mmargin: 0; padding:0; border-width: 0;
 bbackground-color : #ff0000;
}

.cmstitle {
 font-size : 10pt;
 bbackground-color : #ff0000;
}

.ptitle {
 font-size : 14pt;
 font-weight: 700;
}

.subtitle {
 font-size : 12pt;
 font-weight: 700;
}

.userwelcome {
 font-weight: 700;
}

.username {
 font-family: cursive, serif;
 font-weight: 700;
}

.error {
 font-weight: 700;
 color: $errorcolor;
}

.bigalert {
 font-size: 36pt;
 color: $errorcolor;
}

.alertborder {
 border-color: $errorcolor;
 border-style: solid;
 border-width: thin;
}

hr.line {
 height: 4px;
 margin-top: 0;
 mmargin: 0;
 ppadding: 0;
 bborder-width: 0;
 bborder: none;
 background-color: $linecolor;
}

.version {
 font-size : 8pt;
}

input, textarea, select {
 background-color: $inputbgcolor;
 border: solid $bordercolor;
 border-width: 1px;
 color: $textcolor;
}

input, select {
 height:1.5em;
}

.logoninput {
 height:1.5em;
}

.logonbutton {
 height:1.5em;
}

.logoninput {
 width:40px;
}

.menu {
}

.selectedmenu {
 border: solid $bordercolor;
 border-width: 1px;
}

aa {
 color: #000077;
}

.sselectedmenu a {
 ccolor: #0000ff;
 color: #5555ff;
}


.cell1 {
 background-color: $cell1color;
}

.cell2 {
 background-color: $cell2color;
}

.cell3 {
 background-color: $cell3color;
}

.cell4 {
 background-color: $cell4color;
}

.cell5 {
 background-color: $cell5color;
}

.cell6 {
 background-color: $cell6color;
}

.cell7 {
 background-color: $cell7color;
}

.cell8 {
 background-color: $cell8color;
}

.selection1 {
 color: $selection1color;
 background-color: $selection1bgcolor;
}

.selection2 {
 color: $selection2color;
 background-color: $selection2bgcolor;
}

.selection3 {
 color: $selection3color;
 background-color: $selection3bgcolor;
}





* {
 font-family : arial, sans-serif;
 font-size : 10pt;
 background-color : $bgcolor;
 color: $textcolor;
}



.topmenu, .topmenu * {color: $bgcolor; ffont-family: arial, sans-serif; font-size: 10pt; background-color: $textcolor;}
.topmenu a {color: $bgcolor; ffont-family: arial, sans-serif; font-size: 10pt; tTEXT-DECORATION: none;}
.topmenu a:hover {color: $bgcolor; ffont-family: arial, sans-serif; font-size: 10pt; TEXT-DECORATION: underline;}

.topmenu * input, .topmenu * textarea, .topmenu * select {
 background-color: $invinputbgcolor;
 border: solid $bgcolor;
 border-width: 1px;
 color: $bgcolor;
}

.topmenu1, .topmenu1 * {color: $textcolor; ffont-family: sans-serif; font-size: 10pt; background-color: $bgcolor;}
.topmenu1 a {color: $textcolor; ffont-family: sans-serif; font-size: 10pt; tTEXT-DECORATION: none;}
.topmenu1 a:hover {color: $textcolor; ffont-family: sans-serif; font-size: 10pt; TEXT-DECORATION: underline;}



input, textarea, select {
 background-color: $inputbgcolor;
 border: solid $textcolor;
 border-width: 1px;
 color: $textcolor;
}


.userwelcome, .userwelcome * {
 	font-weight: 100;
}

.username, .username * {
 font-family: cursive, serif;
 font-weight: 100;
}


hr.line {
 height: 4px;
 margin-top: 4pt;
 background-color: $textcolor;
}


body { margin: 0; }

h1, .h1 { font-size : 16pt; margin: 4pt; }
h2, .h2 { font-size : 14pt; margin: 3pt; }
h3, .h3 { font-size : 12pt; margin: 2pt; }
h4, .h4 { font-size : 10pt; margin: 1pt; }


small * { font-size : 8pt; }


--></style>

ENDTEXT;

?>