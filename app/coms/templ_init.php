<?

$SYMBOLS = array(
//  'DARR' => '&darr;',
//  'RARR' => '&rarr;',
//  'DOT' => '&#149;'

  'DARR' => '*',
  'RARR' => '=>',
  'DOT' => '*'

);


//$DARR = '*';
//$RARR = '=>';
//$DOT = '*';


function make_menu($SUBMENU, $ID) {
  $SYMBOLS = &$GLOBALS['SYMBOLS'];

  $BODY0 = <<<ENDTEXT

<table cellpadding=2 cellspacing=2>
<tr>
<td><b>{$SYMBOLS['RARR']}</b></td>
ENDTEXT;

  foreach($SUBMENU as $item) {
    if($item['id'] == $ID)
      $BODY0 .=  <<<ENDTEXT
<td class=selectedmenu><b>{$SYMBOLS['DARR']}&nbsp;<a href="{$item['url']}">{$item['title']}</a></b></td>

ENDTEXT;
    else
      $BODY0 .=  <<<ENDTEXT
<td class=menu><b>{$SYMBOLS['DOT']}&nbsp;<a href="{$item['url']}">{$item['title']}</a></b></td>

ENDTEXT;
  }

  $BODY0 .= <<<ENDTEXT
</tr>
</table>

ENDTEXT;

  return $BODY0;
}


?>
