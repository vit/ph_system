<?php

   function array_combine1($a1, $a2)
   {
       if(count($a1) != count($a2))
           return false;
       
       if(count($a1) <= 0)
           return false;

       $a1 = array_values($a1);
       $a2 = array_values($a2);
   
       $output = array();
   
       for($i = 0; $i < count($a1); $i++)
       {
           $output[$a1[$i]] = $a2[$i];
       }
       
       return $output;
   }

function mail_prepare($qid, $mode=0) {
  $result = pg_query("
SELECT
  q.*,
  array_to_string(q.argname, chr(1)) AS argname2,
  array_to_string(q.argvalue, chr(1)) AS argvalue2,
  d.subject, d.ffrom, d.tto, d.body
FROM
  (mlqueue AS q LEFT JOIN mltask AS t ON q.task=t.tid)
  LEFT JOIN mldata AS d ON t.mail=d.mlid
WHERE
  qid=$qid
");

  if( $row = pg_fetch_array($result) ) {

//print_r($row);

    $arr1 = explode("\1", $row['argname2']);
    $arr2 = explode("\1", $row['argvalue2']);
    $arr3 = array_combine1($arr1, $arr2);

    if($mode==1)
      foreach($arr3 as $key => $val) {
        if( strpos($key, "PASSWORD")!==false )
          $arr3[$key] = "******";
//          $val = "******";
//        $argstr .= "/<b>$key</b>=$val ";
      }


    $subject = $row['subject'];
    $ffrom = $row['ffrom'];
    $tto = $row['tto'];
    $body = $row['body'];

    $subject1 = mail_subst_vars($subject, $arr3);
    $ffrom1 = mail_subst_vars($ffrom, $arr3);
    $tto1 = mail_subst_vars($tto, $arr3);
    $body1 = mail_subst_vars($body, $arr3);
    return array('subject' => $subject1, 'ffrom' => $ffrom1, 'tto' => $tto1, 'body' => $body1);
//    return array('subject' => $subject, 'ffrom' => $ffrom, 'tto' => $tto, 'body' => $body);

  }
//  return array();
  return false;
}

function mail_subst_vars($textstring, &$argarray) {
//print_r($argarray);

//  if (is_array($argarray))
//    extract( $argarray );

//  $pattern = '/{\$(\w*)}/e';
//  $textstring = preg_replace( $pattern, "\$\\1", $textstring );

    $pattern = '/{\$(\w*)}/';
    $textstring = preg_replace_callback(
        $pattern,
        function ($matches) use($argarray) {
          return $argarray[$matches[1]];
        },
        $textstring
    );

  return $textstring;
}


?>