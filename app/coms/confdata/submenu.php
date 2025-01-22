<?

$SUBMENU = array();
$SUBMENU[] = array('id'=>'main', 'url'=>'./', 'title'=>'Main');


//if( $CURRENTCONT > 0 ) {

//if($USERPIN)
if( $PERMISSIONS['USER_REGISTER_NEW_PAPER'] || $ispapreg )
  $SUBMENU[] = array('id'=>'mypapers', 'url'=>'./mypapers.html', 'title'=>'My&nbsp;papers');

if( $USERPIN && ($PERMISSIONS['USER_REGISTER_NEW_SUBJECT'] || $issubjman) )
  $SUBMENU[] = array('id'=>'mysubjects', 'url'=>'./mysubjects.html', 'title'=>'My&nbsp;sections');


//if( $PERMISSIONS['USER_REGISTER_NEW_SUBJECT'] || $issubjman )
if( $iseditor ) {
  $SUBMENU[] = array('id'=>'editorial', 'url'=>'./editorial.html', 'title'=>'Editor\'s&nbsp;office');
//  $SUBMENU[] = array('id'=>'reports', 'url'=>'./reports.html', 'title'=>'Reports');
}

if( $isreviewer )
  $SUBMENU[] = array('id'=>'revoffice', 'url'=>'./revoffice.html', 'title'=>'Reviewer\'s&nbsp;office');


//}


//$SUBMENU[] = array('id'=>'retrieve', 'url'=>'./retrieve.html', 'title'=>'Retrieve password');
//$SUBMENU[] = array('id'=>'new', 'url'=>'./new.html', 'title'=>'Register new user');
//$SUBMENU[] = array('id'=>'info', 'url'=>'./info.html', 'title'=>'My data');

//$SUBMENU[] = array('id'=>'', 'url'=>'', 'title'=>'');

?>