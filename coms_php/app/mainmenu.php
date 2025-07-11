<?

$MAINMENU = array();
$MAINMENU[] = array('id'=>'home', 'url'=>"{$ROOT}", 'title'=>'Home');
//$MAINMENU[] = array('id'=>'pin', 'url'=>"{$ROOT}pin/", 'title'=>'Manage PIN');
$MAINMENU[] = array('id'=>'pin', 'url'=>"{$ROOT}pin/", 'title'=>'User&nbsp;info');
//$MAINMENU[] = array('id'=>'user', 'url'=>"{$ROOT}user/", 'title'=>'User info');
$MAINMENU[] = array('id'=>'conf', 'url'=>"{$ROOT}conf/", 'title'=>'Conferences');

if($iscontman)
  $MAINMENU[] = array('id'=>'contman', 'url'=>"{$ROOT}contman/", 'title'=>'Manager&nbsp;office');

$MAINMENU[] = array('id'=>'membership', 'url'=>"{$ROOT}membership/", 'title'=>'IPACS&nbsp;membership');


//$MAINMENU[] = array('id'=>'', 'url'=>'', 'title'=>'');

?>