<?

$SUBMENU = array();
$SUBMENU[] = array('id'=>'main', 'url'=>'./', 'title'=>'Main');

$SUBMENU[] = array('id'=>'find', 'url'=>'./find.html', 'title'=>'Find&nbsp;user');
$SUBMENU[] = array('id'=>'retrieve', 'url'=>'./retrieve.html', 'title'=>'Retrieve&nbsp;password');
$SUBMENU[] = array('id'=>'new', 'url'=>'./new.html', 'title'=>'Register&nbsp;new&nbsp;user');

if($USERPIN)
  $SUBMENU[] = array('id'=>'info', 'url'=>'./info.html', 'title'=>'My&nbsp;data');

//$SUBMENU[] = array('id'=>'', 'url'=>'', 'title'=>'');

?>