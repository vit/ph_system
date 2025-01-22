<?

// Rename this config_safe.php to config.php and add password

// Database Schemas
$SHEMA = "userschema, cmsmlschema, comsml01, coms01, membership01";

// Database Name
$DN="db00060892";

// Database Host
$HN="postgres";

// Database User Name
$UL="db00060892";

// Database User Password
$UP=""; // <-- Password Here


//$ROOT = "/cms/";
$ROOT = "/";

// $papersdir = "papers";
$papersdir = "/data/papers";


$COMS_DOMAIN_NAME = $_SERVER["COMS_DOMAIN_NAME"];
$COOKIEDOMAIN = ".$COMS_DOMAIN_NAME";


	//  $FROMEMAIL = "cap@physcon.ru";
	$FROMEMAIL = "cap@physcon.org";
	$RETURNEMAIL = "errors@physcon.org"; // for errors

  $MEMBER_LOG_EMAIL = "ipacs@physcon.ru";

	$FILE_UPLOADED_LOG_EMAIL = "cap@physcon.ru";
//  $FILE_UPLOADED_LOG_EMAIL = array( "cap@physcon.ru", "shiegin@gmail.com" );

	$FILE_UPLOADED_LOG_EMAIL_PART = array(
//		8 => array( "cap@physcon.ru" ),
//		15 => array( 'physcon2013@ipicyt.edu.mx', 'eruiz@ipicyt.edu.mx', 'jgbarajas@ipicyt.edu.mx', "fradkov@mail.ru" ),
//		1598 => array( 'physcon2015@itu.edu.tr', 'cap@physcon.ru' ),
//		1608 => array( 'physcon2017@ino.it', 'cap@physcon.ru' )
	);

	$FROMEMAIL_PART = array(
//		15 => 'physcon2013@ipicyt.edu.mx',
//		1608 => 'physcon2017@ino.it'
		1636 => 'physcon2021@physcon.ru'
	);

?>
