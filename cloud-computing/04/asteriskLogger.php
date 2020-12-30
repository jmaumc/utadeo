<?php
require "phpagi.php";

# [START speech_quickstart]
# Includes the autoloader for libraries installed with composer
require_once __DIR__ . '/vendor/autoload.php';

# Imports the Google Cloud client library
use Google\Cloud\Speech\SpeechClient;

//$agi = new AGI();
//
// Debug flags
//
$mysql_loq_queries = 0;
$mysql_log_results = 0;
$verbose_log = 0;


$asteriskServer        = "127.0.0.1";
$asteriskManagerPort   = 5038;
$asteriskUser          = "Username: admin\r\n";
$asteriskSecret        = "Secret: Utadeo2021\r\n";



// BR: Added this while loop to keep loging in to AMI if asterisk goes down.
while (true) {
    // connect to Asterisk server
    $amiSocket = fsockopen($asteriskServer, $asteriskManagerPort, $errno, $errstr, 5);
    if (!$amiSocket) {
        echo "! Error $errno connecting to Asterisk: $errstr";
		sleep(5); // retry connecting
		continue;
    } else {
       
        echo "# Successfully opened socket connection to $asteriskServer:$asteriskManagerPort\n";
    }


    fputs($amiSocket, "Action: Login\r\n");
    fputs($amiSocket, $asteriskUser);
    fputs($amiSocket, $asteriskSecret);
    fputs($amiSocket, "Events: call,hud\r\n\r\n"); // to monitor just call data, for Asterisk Manager 1.0 remove hud
    $result = fgets($amiSocket, 4096);
    logLine("! AMI Login action returned with rc=$result\n");
    $event = '';
    $stack = 0;

    $event_started = false;

	$start = NULL;
	$timeout = ini_get('default_socket_timeout');

	stream_set_timeout($amiSocket,60); // sets timeout to 60 seconds.
	$consecutiveFailures = 0;

    // Keep a loop going to read the socket and parse the resulting commands.
	// Apparently there is no good way to detect if socket is still alive???
	// This is my hack... if we fail 60 times in a row we reconnect to manager...
    // I suspect that fgets will return very quickly if socket error has occurrs
	// So, it'll reach 60 very quickly and then force relogin.
    // Otherwise, every hour it'll just relogin.
    // Perhaps you can check socket error some other way then socket_read?
    // All I know is this reconnect method has made my asteriskLogger a lot more stable.
    while ($consecutiveFailures < 60 && !safe_feof($amiSocket, $start) && (microtime(true) - $start) < $timeout) {
        $buffer = fgets($amiSocket, 4096);
        //echo("# Read " . strlen($buffer) . " "  . $buffer . "\n");

       if( $buffer === FALSE )
		{
			logLine(getTimestamp() . " Timeout or Error\n"); // TODO Remove once asteriskLogger never needs restarting.
			$consecutiveFailures++;
		}
		else {
			$consecutiveFailures = 0;
			if ($buffer == "\r\n") 
            { // handle partial packets

				$event_started = false;
				// parse the event and get the result hashtable
				$e             = getEvent($event);
				dumpEvent($e); // prints to screen


				//
				// Call Event
				//
				if ($e['Event'] == 'Dial' && $e['SubEvent'] != 'End') //Asterisk Manager 1.1 returns 2 dial events with a begin and an end subevent, by excluding the subevent end we won't get multiple records for the same call.
					{
					echo "! Dial Event src=" . $e['Channel'] . " dest=" . $e['Destination'] . "\n"; //Asterisk Manager 1.1
		
			

					$call = NULL;

					$tmpCallerID = trim($e['CallerIDNum']); //Asterisk Manager 1.0 $e['CallerID']

   			
					
					
				}

				//
				// NewCallerID for Outgoing Call
				//
				//Asterisk Manager 1.1
				if ($e['Event'] == 'NewCallerid') {
					$id          = $e['Uniqueid'];
					$tmpCallerID = trim($e['CallerIDNum']);
					//echo ("* CallerID is: $tmpCallerID\n");
				
					echo "* {e['UniqueId']} CallerID  Changed to: $tmpCallerID\n";
				
					
				}
				//Asterisk Manager 1.0

				/* if($e['Event'] == 'NewCallerid')
				{
				$id = $e['Uniqueid'];
				$tmpCallerID = trim($e['CallerID']);
				echo("* CallerID is: $tmpCallerID\n");
				if ( (strlen($calloutPrefix) > 0)  && (strpos($tmpCallerID, $calloutPrefix) === 0) )
				{
				echo("* Stripping prefix: $calloutPrefix");
				$tmpCallerID = substr($tmpCallerID, strlen($calloutPrefix));
				}
				echo("* CallerID is: $tmpCallerID\n");
				// Fetch associated call record
				//$callRecord = findCallByAsteriskId($id);
				$query = "UPDATE asterisk_log SET CallerID='" . $tmpCallerID . "', callstate='Dial' WHERE asterisk_id='" . $id . "'";
				mysql_checked_query($query);
				};*/

				//
				// Process "Hangup" events
				// Yup, we really get TWO hangup events from Asterisk!
				// Obviously, we need to take only one of them....
				//
				// Asterisk Manager 1.1
				// I didn't get the correct results from inbound calling in relation to the channel that answered, this solves that.

				if ($e['Event'] == 'Hangup') {

                   // echo "* ${e['Linkedid']} CallerID  Changed to: $tmpCallerID\n";
                    $id_Cause        = $e['Cause'];
                    $id_callfull        = $e['Uniqueid'];
                   # $id_linkedid         = $e['Linkedid'];

				    //getCall($id_callfull);

                    echo 'id_Cause: ' . $id_Cause . PHP_EOL;
                    if($id_Cause=='16')
                    {
                        echo 'id_callfull: ' . $id_callfull. PHP_EOL;
                       // if($id_callfull == $id_linkedid)
                        //{
                            getCall($id_callfull);
                        //}
                        //else{
                        //    getCall($id_linkedid);
                        //}
                    }
                
				}// End of HangupEvent.



				// success
				//Asterisk Manager 1.1
				if ($e['Event'] == 'Bridge') {
				
				
				}
				//Asterisk Manager 1.0

				/*if($e['Event'] == 'Link')
				{
				$query = "UPDATE asterisk_log SET callstate='Connected', timestampLink=NOW() WHERE asterisk_id='" . $e['Uniqueid1'] . "' OR asterisk_id='" . $e['Uniqueid2'] . "'";
				$rc = mysql_checked_query($query);

				// und vice versa .. woher immer der call kam
				// $query = "UPDATE asterisk_log SET callstate='Connected', timestampLink=NOW() WHERE asterisk_id='" . $e['Uniqueid2'] . "'";
				// $record = mysql_query($query);
				};*/

				// Reset event buffer
				$event = '';


			}
        }

        // handle partial packets
        if ($event_started)
		{
            $event .= $buffer;
        }
		else if (strstr($buffer, 'Event:'))
		{
            $event         = $buffer;
            $event_started = true;
        }

        // for if the connection to the sql database gives out.
     

    }


    logLine(getTimestamp() . " # Event loop terminated, attempting to login again\n");
    sleep(1);
}


exit(0);



// ******************
// Helper functions *
// ******************

// go through and parse the event
function getEvent($event)
{
    $e          = array();
    $e['Event'] = '';

    $event_params = explode("\n", $event);

    foreach ($event_params as $event) {
        if (strpos($event, ": ") > 0) {
            list($key, $val) = explode(": ", $event);
            //		$values = explode(": ", $event);
            $key = trim($key);
            $val = trim($val);

            if ($key) {
                $e[$key] = $val;
            }
        }
    }
    return ($e);
}


function getTimestamp()
{
    return date('[Y-m-d H:i:s]');
}


function dumpEvent(&$event)
{
    // Skip 'Newexten' events - there just toooo many of 'em || For Asterisk manager 1.1 i choose to ignore another stack of events cause the log is populated with useless events
    if ($event['Event'] === 'Newexten' || $event['Event'] == 'UserEvent' || $event['Event'] == 'AGIExec' || $event['Event'] == 'Newchannel' || $event['Event'] == 'Newstate' || $event['Event'] == 'ExtensionStatus') {
        return;
    }

    $eventType = $event['Event'];

    logLine(getTimeStamp() . "\n");
    logLine("! --- Event -----------------------------------------------------------\n");
    foreach ($event as $eventKey => $eventValue) {
        logLine(sprintf("! %20s --> %-50s\n", $eventKey, $eventValue));
    }
    logLine("! ---------------------------------------------------------------------\n");
}


function getCall($id_callfull)
{
           $db_host = '127.0.0.1';
           $db_user = 'root';
           $db_pwd = 'Utadeo2021';
           $database = 'asteriskcdrdb';

           //UN delay

            sleep(3);
            $link  = new mysqli($db_host, $db_user, $db_pwd,$database);
            if($link === false){
                die("ERROR: Could not connect. " . mysqli_connect_error());
            }

            $sql = "SELECT uniqueid, recordingfile FROM asteriskcdrdb.cdr WHERE uniqueid='$id_callfull'";
            echo "\n$sql\n";

            if($result = mysqli_query($link, $sql)){
                if(mysqli_num_rows($result) > 0){

                    while($row = mysqli_fetch_array($result)){
                      // calcular la hora para el formato que genera Asterisk PBX

                        $fecha_actual = localtime(time(),1);
                        $anyo_actual = $fecha_actual['tm_year'] + 1900;
                        $mes_actual = $fecha_actual['tm_mon'] + 1;
                        $mes_actual = date("m");
                        $dia_actual =date("d");
                       // $dia_actual = $fecha_actual['tm_mday'];

			$path_origen = "/var/spool/asterisk/monitor/$anyo_actual/$mes_actual/$dia_actual/";
                        echo "\n"."PATH:" . $path_origen."\n";
                  //      echo "\n"."PATH:" . $path_origen."\n";
			   // $path_origen = "/var/spool/asterisk/monitor/2018/10/25/";

                        $Id_CALL_new = $row['uniqueid'];
                       // $path_wav=$path_origen.$row['recordingfile'];
                        $path_wav=$row['recordingfile'];
                        $path_flac=$path_origen.$Id_CALL_new.".flac";

			           // echo "ID LLAMADA:" . $row['uniqueid']."\n";
			           // echo "GRABACION:" . $row['recordingfile']."\n";
                       // echo "\n"."PATH FULL :" . $path_wav."\n";
                }

                    $cadena = $path_wav;
                    echo "\n Cadena: ".$cadena;
                    $buscar = $Id_CALL_new;
                    echo "\n IDENTIFICADOR: ".$buscar."\n";
                    $resultado = strpos($cadena, $buscar);
//if (file_exists($path_wav))
                    if($resultado !== FALSE)
                                         {
                        echo "\n CONVERTIR:" . system("/usr/bin/sox $path_wav  $path_flac");
                        $linea = system("export GOOGLE_APPLICATION_CREDENTIALS=/var/lib/asterisk/agi-bin/speech/credentials.json", $retval);
                        echo "\n EXPORTAR:" . $retval . "\n";

                        //$CMD="/usr/bin/php speech.php transcribe ".$path_flac." --encoding FLAC --sample-rate 8000 --language-code es-CO";
                        //$linea=system($CMD,$retval);
                        //echo "\n SALIDA:".$linea;

                        # Instantiates a client
                        # Your Google Cloud Platform project ID
                        $projectId = 'polynomial-box-289111';
                        $speech = new SpeechClient([
                            'projectId' => $projectId,
                            'languageCode' => 'es-CO',
                        ]);
                        # The name of the audio file to transcribe
                        //$fileName = '/var/spool/asterisk/monitor/2018/10/21/1540137867.128.flac';
                        $fileName = $path_flac;
                        # The audio file's encoding and sample rate
                        $options = [
                        ];
                        # Detects speech in the audio file
                        $results = $speech->recognize(fopen($fileName, 'r'), $options);
                        $text = '';
                        foreach ($results as $result) {
                            echo 'Transcription: ' . $result->alternatives()[0]['transcript'] . PHP_EOL;
                            $text = $text . " " . utf8_decode ($result->alternatives()[0]['transcript']);
                        }
                        //$text = utf8_decode($text);
                        echo 'TEXTO: ' . $text . PHP_EOL;

                        # [END speech_quickstart]

                        # Insertar el texto

                        $sql = "UPDATE asteriskcdrdb.cdr SET voz_text='$text' WHERE uniqueid='$id_callfull'";
                        echo $sql . PHP_EOL;
                        if (mysqli_query($link, $sql)) {
                            echo "Records inserted successfully.";

                           // $sql2 = "SELECT voz_text FROM asteriskcdrdb.cdr";
                           // $result2 = mysqli_query($link, $sql2);

                            // $cadena = " ";
                           // while ($row = mysqli_fetch_array($result2))
                           // {
                           //     $cadena = $cadena . "\n" . $row['voz_text'];
                           //     //system("/usr/bin/sox $path_wav  $path_flac");
                           // }
                           // echo $cadena . PHP_EOL;


                        } else {
                            echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
                        }

                    }else {
                        echo "El fichero $path_wav no existe".PHP_EOL;
                    }









                    // Free result set
                   // mysqli_free_result();
        } else{
            echo "No records matching your query were found.";
        }
    } else{
        echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
    }

// Close connection

    mysqli_close($link);

    return "OK";
    }




    
//
// Locate associated record in "Calls" module
//
           
function exec_cmd($programexe,$programvars) 
{ 
//foreach ($tasks as $key => $v){ 
   switch ($pid = pcntl_fork()) { 
      case -1: 
         // @fail 
         die('Fork failed'); 
         break; 

      case 0: 
         // @child: Include() misbehaving code here 
         print "FORK: Child #{$x} \\n"; 
         echo "child after fork:", getmypid(), PHP_EOL; 
         pcntl_exec($programexe,$programvars); 
         // generate_fatal_error(); // Undefined function 
         break; 

      default: 
         // @parent 
         print "FORK: $x Parent\\n"; 
         echo "parent after fork:", getmypid(), PHP_EOL; 
         // pcntl_waitpid($pid, $status); 
         break; 
   } 

print "Done! :^)\\n\\n"; 
} 



function findCallByAsteriskId($asteriskId)
{
    global $soapClient, $soapSessionId;
    logLine("# +++ findCallByAsteriskId($asteriskId)\n");

    //
    // First, fetch row in asterisk_log...
    //

    $sql         = sprintf("SELECT * from asterisk_log WHERE asterisk_id='$asteriskId'", $asteriskId);
    $queryResult = mysql_checked_query($sql);
    if ($queryResult === FALSE) {
        logLine("Asterisk ID NOT FOUND in asterisk_log (db query returned FALSE)");
        return FALSE;
    }

    while ($row = mysql_fetch_assoc($queryResult)) {
        $callRecId = $row['call_record_id'];
        logLine("! Found entry in asterisk_log recordId=$callRecId\n");

        //
        // ... then locate Object in Calls module:
        //
        $soapResult    = $soapClient->call('get_entry', array(
            'session' => $soapSessionId,
            'module_name' => 'Calls',
            'id' => $callRecId
        ));
        $resultDecoded = decode_name_value_list($soapResult['entry_list'][0]['name_value_list']);
        // echo ("# ** Soap call successfull, dumping result ******************************\n");
        // var_dump($soapResult);
        // var_dump($resultDecoded);
        // var_dump($row);
        // echo ("# ***********************************************************************\n");

        //
        // also store raw sql data in case we need it later...
        //
        return array(
            'bitter' => $row,
            'sweet' => $resultDecoded
        );
    }
    logLine("! Warning, results set was empty!\n");
    return FALSE;
}
// AsteriskManager 1.1 for inbound calling
function findCallByAsteriskDestId($asteriskDestId)
{
    global $soapClient, $soapSessionId, $verbose_logging;
    logLine("# +++ findCallByAsteriskDestId($asteriskDestId)\n");

    //
    // First, fetch row in asterisk_log...
    //

    $sql         = sprintf("SELECT * from asterisk_log WHERE asterisk_dest_id='$asteriskDestId'", $asteriskDestId);
    $queryResult = mysql_checked_query($sql);
    if ($queryResult === FALSE) {
        return FALSE;
    }

    while ($row = mysql_fetch_assoc($queryResult)) {
        $callRecId = $row['call_record_id'];
        logLine("! FindCallByAsteriskDestId - Found entry in asterisk_log recordId=$callRecId\n");

        //
        // ... then locate Object in Calls module:
        //
        $soapResult    = $soapClient->call('get_entry', array(
            'session' => $soapSessionId,
            'module_name' => 'Calls',
            'id' => $callRecId
        ));
        $resultDecoded = decode_name_value_list($soapResult['entry_list'][0]['name_value_list']);

		// echo ("# ** Soap call successfull, dumping result ******************************\n");
        // var_dump($soapResult);
        if( $verbose_logging ) {
			var_dump($resultDecoded);
		}
        // var_dump($row);
        // echo ("# ***********************************************************************\n");

        //
        // also store raw sql data in case we need it later...
        //
        return array(
            'bitter' => $row,
            'sweet' => $resultDecoded
        );
    }
    logLine( "! Warning, FindCallByAsteriskDestId results set was empty!\n");
    return FALSE;
}

//
// Repacks a name_value_list eg returned by get_entry() into a hash (aka associative array in PHP speak)
//
function decode_name_value_list(&$nvl)
{
    $result = array();

    foreach ($nvl as $nvlEntry) {
        $key          = $nvlEntry['name'];
        $val          = $nvlEntry['value'];
        $result[$key] = $val;
    }
    return $result;
}


//
// Attempt to find a Sugar Account with a matching phone number.
//
function findSugarAccountByPhoneNumber($aPhoneNumber)
{
    global $soapClient, $soapSessionId;
    logLine("# +++ find AccountByPhoneNumber($aPhoneNumber)\n");

    // Add if phonenumber .length == 10
    $searchPattern = $aPhoneNumber;

    $aPhoneNumber = preg_replace( '/\D/', '', $aPhoneNumber); // removes everything that isn't a digit.
    if( preg_match('/([0-9]{7})$/',$aPhoneNumber,$matches) ){
        $aPhoneNumber = $matches[1];
    }

    $regje = preg_replace( '/(\d)/', '$1\[^\\d\]*',$aPhoneNumber);
    $regje = '(' . $regje . ')$';

    $soapArgs = array(
        'session' => $soapSessionId,
        'module_name' => 'Accounts',
        'query' => "accounts.phone_office REGEXP '$regje' OR accounts.phone_alternate REGEXP '$regje'",
    );

    // print "--- SOAP get_entry_list() ----- ARGS ----------------------------------------\n";
    // var_dump($soapArgs);
    // print "-----------------------------------------------------------------------------\n";

    $soapResult = $soapClient->call('get_entry_list', $soapArgs);

    //print "--- SOAP get_entry_list() FOR GET CONTACT ------------------------------------\n";
    //var_dump($soapResult);
    //print "-----------------------------------------------------------------------------\n";

    if( !isSoapResultAnError($soapResult))
    {
        $resultDecoded = decode_name_value_list($soapResult['entry_list'][0]['name_value_list']);
        //print "--- Decoded get_entry_list() FOR GET CONTACT --------------------------------------\n";
        //var_dump($resultDecoded);
        //print "-----------------------------------------------------------------------------\n";
        return array(
            'type' => 'Accounts',
            'values' => $resultDecoded
        );
    }

    return FALSE;
}


//
// Attempt to find a Sugar object (Contact,..) by phone number
//
// NOTE: As of v2.2, callListener now updates a column in asterisk_log table with contact_id so it doesn't have to perform
// a complex query each time.  But, since callListener only works when you're logged into sugar and have "Call Notification" on.
// we still have to try and find object related to phone number here for the other cases.
//
//
function findSugarObjectByPhoneNumber($aPhoneNumber)
{
    global $soapClient, $soapSessionId;
    logLine("# +++ find ContactByPhoneNumber($aPhoneNumber)\n");

    // Add if phonenumber .length == 10
    $searchPattern = $aPhoneNumber;
    //$searchPattern = regexify($aPhoneNumber);


    //
    // Plan A: Attempt to locate an object in Contacts
    //        $soapResult = $soapClient->call('get_entry' , array('session' => $soapSessionId, 'module_name' => 'Calls', 'id' => $callRecId));
    //


    //************ CID.agi
    // =~ <--- use the left side as input string to regex.
    // s -- replace.
    //
    //$number =~ s/\D//g;
    //$number =~ m/([0-9]{7})$/;
    //$number = $1 if ($1);
    //
    //if ($1) {
    //  $regje = $number;
    //  $regje =~ s/(\d)/$1\[^\\d\]*/g;
    //  $regje = '(' . $regje . ')' . '$';
    //} elsif($number) {
    //  $regje = '^' . $number . '$';
    //} else {
    //  debugAndQuit("No caller ID found for this call");
    //}
    //
    //debug("Searching for regexp $regje",5);
    //
    //# lookup the number @ contacts
    //$result = $service->get_entry_list($sid,"Contacts","contacts.phone_home REGEXP '$regje' OR contacts.phone_mobile REGEXP '$regje' OR contacts.phone_work REGEXP '$regje' OR contacts.phone_other REGEXP '$regje' OR contacts.phone_fax REGEXP '$regje'","",0,{a=>"first_name",b=>"last_name",c=>"account_name"},1,0)->result;
    //$id = $result->{entry_list}[0]{id};

    // TODO figure out what that 2nd case could be the elseif part...

    $aPhoneNumber = preg_replace( '/\D/', '', $aPhoneNumber); // removes everything that isn't a digit.
	if( preg_match('/([0-9]{7})$/',$aPhoneNumber,$matches) ){
		$aPhoneNumber = $matches[1];
	}

	$regje = preg_replace( '/(\d)/', '$1\[^\\d\]*',$aPhoneNumber);
	$regje = '(' . $regje . ')$';

    logLine("  findSugarObjectByPhoneNumber: Contact query components- Phone: $aPhoneNumber   RegEx: $regje\n");
    //*******/



    $soapArgs = array(
        'session' => $soapSessionId,
        'module_name' => 'Contacts',
        'select_fields' => array( 'id','account_id' ),
        // 2nd version 'query' => "((contacts.phone_work = '$searchPattern') OR (contacts.phone_mobile = '$searchPattern') OR (contacts.phone_home = '$searchPattern') OR (contacts.phone_other = '$searchPattern'))", );
        // Original...
		//'query' => "((contacts.phone_work LIKE '$searchPattern') OR (contacts.phone_mobile LIKE '$searchPattern') OR (contacts.phone_home LIKE '$searchPattern') OR (contacts.phone_other LIKE '$searchPattern'))"
		// Liz Version: Only works on mysql
		'query' => "contacts.phone_home REGEXP '$regje' OR contacts.phone_mobile REGEXP '$regje' OR contacts.phone_work REGEXP '$regje' OR contacts.phone_other REGEXP '$regje' OR contacts.phone_fax REGEXP '$regje'",

    );

    // print "--- SOAP get_entry_list() ----- ARGS ----------------------------------------\n";
    // var_dump($soapArgs);
    // print "-----------------------------------------------------------------------------\n";

    $soapResult = $soapClient->call('get_entry_list', $soapArgs);

    //print "--- SOAP get_entry_list() FOR GET CONTACT ------------------------------------\n";
    //var_dump($soapResult);
    //print "-----------------------------------------------------------------------------\n";

    if( !isSoapResultAnError($soapResult))
    {
        $resultDecoded = decode_name_value_list($soapResult['entry_list'][0]['name_value_list']);

        if( count($soapResult['entry_list']) > 1 ) {
            $foundMultipleAccounts = FALSE;
            $account_id = $resultDecoded['account_id'];
            // TODO I had 43 entries returned for 2 contacts with matching number... need better distinct support.  Apparently, no way to do this via soap... probably need to create a new service endpoint.
            for($i=1; $i<count($soapResult['entry_list']); $i++ ) {
                $resultDecoded = decode_name_value_list($soapResult['entry_list'][$i]['name_value_list']);
                if( $account_id != $resultDecoded['account_id'] ) {
                    $foundMultipleAccounts = TRUE;
                }
            }
            if( !$foundMultipleAccounts )
            {
                $result = array();
                $result['id'] = $account_id;
                logLine("Found multiple contacts -- all belong to same account, associating call with account.\n");
                return array( 'type' => 'Accounts', 'values' => $result );
            }
            else {
                logLine("Multiple contacts matched multiple accounts, Not associating\n");
                return FALSE;
            }
        }

        //print "--- Decoded get_entry_list() FOR GET CONTACT --------------------------------------\n";
        //var_dump($resultDecoded);
        //print "-----------------------------------------------------------------------------\n";
        return array(
            'type' => 'Contacts',
            'values' => $resultDecoded
        );
    }

    // Oops nothing found :-(
    return FALSE;
}

// Function only necessary in case of the original query used.
// Replace a phone number to search with a universal-match-anyway(tm) expression to be used
// in a SQL 'LIKE' condition - eg 1234 --> %1%2%3%4%
//

/*function regexify($aPhoneNumber)
{
return '%' . join('%', str_split($aPhoneNumber)) . '%';
}
*/
//
// Finds related account for given contact id
//
function findAccountForContact($aContactId)
{
    global $soapClient, $soapSessionId;
    logLine("# +++ findAccountForContact($aContactId)\n");

    $soapArgs = array(
        'session' => $soapSessionId,
        'module_name' => 'Contacts',
        'module_id' => $aContactId,
        'related_module' => 'Accounts',
        'related_module_query' => '',
        'deleted' => 0
    );

    $soapResult = $soapClient->call('get_relationships', $soapArgs);

    if ($soapResult['error']['number'] != '0') {
        logLine("! WARNING Soap call returned with error " . $soapResult['error']['number'] . " " . $soapResult['error']['name'] . " // " . $soapResult['error']['description'] . "\n");
        return FALSE;
    } else {
        // var_dump($soapResult);

        isSoapResultAnError($soapResult);

        $assocCount = count($soapResult['ids']);

        if ($assocCount == 0) {
            logLine("# No associated account found\n");
            return FALSE;
        } else {
            if ($assocCount > 1) {
                logLine("! WARNING: More than one associated account found, using first one.\n");
            }

            $assoAccountID = $soapResult['ids'][0]['id'];
            logLine("# Associated account is $assoAccountID\n");
            return $assoAccountID;
        }
    }
}

/**
 * prints soap result info
 * Returns true if results were returned, FALSE if an error or no results are returned.
 *
 * @param $soapResult
 */
function isSoapResultAnError($soapResult) {
    $retVal = FALSE;
    if ($soapResult['error']['number'] != 0) {
        logLine("! Warning: SOAP error " . $soapResult['error']['number'] . " " . $soapResult['error']['string'] . "\n");
        $retVal = TRUE;
    }
    else if( $soapResult['result_count'] == 0 ) {
        logLine("! No results returned\n");
        $retVal = TRUE;
    }
    return $retVal;
}

/**
 * Performs a soap call to set a relationship between a call record and a bean (contact)
 * @param $callRecordId the call record id.
 * @param $beanType usually "Contacts"
 * @param $beanId
 */
function setRelationshipBetweenCallAndBean($callRecordId,$beanType, $beanId) {
    global $soapSessionId, $soapClient,$verbose_logging;

    if( !empty($callRecordId) && !empty($beanId) && !empty($beanType)  ) {
        $soapArgs   = array(
            'session' => $soapSessionId,
            'set_relationship_value' => array(
                'module1' => 'Calls',
                'module1_id' => $callRecordId,
                'module2' => $beanType,
                'module2_id' => $beanId
            )
        );

        logLine("# Establishing relation to $beanType... Call ID: $callRecordId to Bean ID: $beanId\n");
        if( $verbose_logging ) {
            var_dump($soapArgs);
        }
        $soapResult = $soapClient->call('set_relationship', $soapArgs);
        isSoapResultAnError($soapResult);
    }
    else {
        logLine("! Invalid Arguments passed to setRelationshipBetweenCallAndBean");
    }
}

///
/// Given the channel ($rawData['channel']) from the AMI Event, this returns the user ID the call should be assigned to.
/// If a suitable user extension cannot be found, Admin is returned
///
function findUserIdFromChannel( $channel )
{
	global $userGUID;
	$assignedUser = $userGUID; // Use logged in user as fallback

	$asteriskExt = extractExtensionNumberFromChannel($channel);

	$maybeAssignedUser = findUserByAsteriskExtension($asteriskExt);
	if ($maybeAssignedUser) {
		$assignedUser = $maybeAssignedUser;
		logLine("! Assigned user id set to $assignedUser\n");
	}
	else {
		$assignedUser = $userGUID;
		logLine(" ! Assigned user will be set to Administrator.\n");
	}

	return $assignedUser;
}

//
// Attempt to find assigned user by asterisk ext
// PRIVATE METHOD: See findUserIdFromChannel
//
function extractExtensionNumberFromChannel( $channel )
{
	global $sugar_config;
	$asteriskExt = FALSE;
	$channelSplit = array();
	logLine("Looking for user extension number in: $channel\n");

	// KEEP THIS BLOCK OF CODE IN SYNC WITH OUTBOUND
	// BR: This cases matches things like Local/LC-52@from-internal-4bbbb
	$pattern = $sugar_config['asterisk_dialin_ext_match'];
	if( !startsWith($pattern,'/') ) {
		$pattern = '/' . $pattern . '/i';
	}
	if( !empty($sugar_config['asterisk_dialin_ext_match']) && preg_match($pattern, $channel, $regs)) {
		logLine("Matched User REGEX.  Regex: " . $regs[1] . "\n");
		$asteriskExt = $regs[1];
	}
	// This matches the standard cases such as SIP/### or IAX/###
	else if (eregi('^([[:alpha:]]+)/([[:alnum:]]+)-', $channel, $channelSplit) > 0){
		$asteriskExt = $channelSplit[2];
		logLine("Channel Matched SIP/### style regex.  Ext is:" . $asteriskExt . "\n");
	}
	else {
		$asteriskExt = FALSE;
	}

	return $asteriskExt;
}

//
// Locate user by asterisk extension
// NOTE: THIS RETURNS JUST AN ID
// PRIVATE METHOD: See findUserIdFromChannel
//
function findUserByAsteriskExtension($aExtension)
{
    logLine("# +++ findUserByAsteriskExtension($aExtension)\n");

	$qry = "select id from users join users_cstm on users.id = users_cstm.id_c where users_cstm.asterisk_ext_c=$aExtension and status='Active'";
	$result = mysql_checked_query($qry);
	if( $result ) {
		$row = mysql_fetch_array($result);
		return $row['id'];
	}

	return FALSE;

	///// OLD WAY OF DOING IT IS WITH SOAP... DIDN"T WORK FOR ME... so reverted to db query.
/*
    global $soapClient, $soapSessionId;
    print("# +++ findUserByAsteriskExtension($aExtension)\n");

			//'select_fields'=>array('id', 'first_name', 'last_name'),
		//'deleted' => 0,
    $soapArgs = array(
        'session' => $soapSessionId,
        'module_name' => 'Users',
		'query' => '(users_cstm.asterisk_ext_c=\'710\')',
   // 	'query' => sprintf("(users_cstm.asterisk_ext_c='%s')", $aExtension),
'select_fields'=>array('id', 'first_name', 'last_name'),
    );
	//var_dump($soapArgs);

    $soapResult = $soapClient->call('get_entry_list', $soapArgs);

     var_dump($soapResult);

    if ($soapResult['error']['number'] != 0) {
        logLine("! Warning: SOAP error " . $soapResult['error']['number'] . " " . $soapResult['error']['string'] . "\n");
    }
	else if( $soapResult['result_count'] == 0 ) {
		logLine("! No results returned\n");
	}
	else {
        $resultDecoded = decode_name_value_list($soapResult['entry_list'][0]['name_value_list']);
        // print "--- SOAP get_entry_list() ----- RESULT --------------------------------------\n";
         var_dump($resultDecoded);
        // print "-----------------------------------------------------------------------------\n";
        return $resultDecoded['id'];
    }

    return FALSE;
	*/
}

//
// Checked execution of a MySQL query
//
// This function provides a wrapper around mysql_query(), providing SQL and error loggin
//
function mysql_checked_query($aQuery)
{
    global $mysql_loq_queries;
    global $mysql_log_results;

	if( $mysql_loq_queries || $mysql_log_results )
	{
		logLine("# +++ mysql_checked_query()\n");
	}

    $query = trim($aQuery);
    if ($mysql_loq_queries) {
		logLine("  ! SQL: $query\n");
    }

    // Is this is a SELECT ?
    $isSelect = eregi("^select", $query);

    $sqlResult = mysql_query($query);

    if ($mysql_log_results) {
        if (!$sqlResult) {
            // Error occured
            logLine("! SQL error " . mysql_errno() . " (" . mysql_error() . ")\n");
        } else {
            // SQL succeeded
            if ($isSelect) {
                logLine("  --> Rows in result set: " . mysql_num_rows($sqlResult) . "\n");
            } else {
                logLine("  --> Rows affected: " . mysql_affected_rows() . "\n");
            }
        }
    }


    return $sqlResult;
}

function logLine($str)
{
	global $sugar_config;
    print($str);

	// if logging is enabled.
	if( !empty($sugar_config['asterisk_log_file']) )
	{
		$myFile = $sugar_config['asterisk_log_file'];
		$fh = fopen($myFile, 'a') or die("can't open file");
		fwrite($fh, $str);
		fclose($fh);
	}
}

// Theoretically safe method, feof will block indefinitely.
function safe_feof($fp, &$start = NULL) {
 $start = microtime(true);
 return feof($fp);
}

function startsWith($haystack, $needle)
{
    $length = strlen($needle);
    return (substr($haystack, 0, $length) === $needle);
}

function endsWith($haystack, $needle)
{
    $length = strlen($needle);
    $start  = $length * -1; //negative
    return (substr($haystack, $start) === $needle);
}


?>
