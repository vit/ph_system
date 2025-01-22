<?
include_once("submenu.php");



$BODY0 = make_menu($SUBMENU, $PAGEID);

/*
$BODY0 = <<<ENDTEXT

<center><span class=ptitle>Manage user info</span></center>

<table wwidth=100% cellpadding=2 cellspacing=2>
<td><b>$RARR</b></td>
ENDTEXT;

  foreach($SUBMENU as $item) {
    if($item['id'] == $PAGEID)
      $BODY0 .=  <<<ENDTEXT
<td class=selectedmenu><b>$DARR <a href="{$item['url']}">{$item['title']}</a></b></td>

ENDTEXT;
    else
      $BODY0 .=  <<<ENDTEXT
<td class=menu><b>$DOT <a href="{$item['url']}">{$item['title']}</a></b></td>

ENDTEXT;
  }


$BODY0 .= <<<ENDTEXT
</table>

ENDTEXT;
*/


$PAGEBODY = <<<ENDTEXT
<center><span class=ptitle>Manage user info</span></center>
$BODY0
<p>
$PAGEBODY
ENDTEXT;


include_once("../finish.php");

?>