<?

//  include_once("contmandata/po_start.php");
  include_once("email2/mail_func.php");


  $qid = trim( $_REQUEST['qid'] );

  $prepmail = mail_prepare($qid, 1);

  $subject1 = htmlspecialchars($prepmail['subject']);
  $ffrom1 = htmlspecialchars($prepmail['ffrom']);
  $tto1 = htmlspecialchars($prepmail['tto']);
  $body1 = nl2br(htmlspecialchars($prepmail[body]));

  $PAGEBODY .= <<<PAGEBODY
<br>
<center><span class=subtitle>Mail preview</span></center>
<p>

<b>Subject:</b> $subject1<br>
<b>From:</b> $ffrom1<br>
<b>To:</b> $tto1<br>
<b>Body:</b><br>
$body1<br>

PAGEBODY;


?>