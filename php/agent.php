<?php
 /* Arduino PHP Agent Script. For communicating with the Arduino Ethernet Shield
    Copyright (C) 2011  Juan Toledo Carrasco juantoledo@gmail.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/	

require_once "config.php";


	//if the Arduino sent some data
	if(isset($_GET['data']))
	{
		
		/*need to ve validated with regexp, [0] D or A (digital / analog)+number   [1] : the value
			only works with "D1-0", "A10-102" based get Parameter
		*/
		$signal = explode("-",$_GET['data']);   
		
		$signalType = $signal[0][0]; //signalType , could be A or D
		$pin = substr($signal[0],1); // any of the Arduino dig/analog pins
		$value = $signal[1]; //the value of that pin
		////////////////////////////////
		


		//remove this
		echo "Wow ! The Arduino just sent a message. Or maybe you are testing the agent from the URL:<br>SignalType: ".$signalType.", pin:".$pin.", value:".$value;
		
		

	}
	else{ //if not, it means a direct order to the Arduino, for example

		//this code is only for testing
		/*sleep(1);
		digitalWrite(6,1);
		sleep(1);
		digitalWrite(7,1);	
		sleep(1);
		digitalWrite(7,0);
		sleep(1);
		digitalWrite(6,0);	
		sleep(1);
		pinMode(7,0);*/
		echo "It Works!<br>";
		echo "The Arduino Says: The Digital pin 7 has a value: ". digitalRead(7);

		echo "<br><br>Now, try to simulate the Arduino&acute;s call to this script: <a href='http://".$_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"]."/agent.php?data=D7-1&'>http://".$_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"]."/agent.php?data=D7-1&</a>";

	}


/**
This function adds an abstraction layer to all the HTTP-Arduino-Ethernet-Shield-pinMode logic.
Returns the resulting value of the call to the Arduino's HTTP Server Infrastructure over the Ethernet Shield
In this case, valid pin modes are 1: INPUT or 0: OUTPUT
*/
function pinMode($pin,$mode)
{
	return getResponse($GLOBALS['params']['arduinohost'],$GLOBALS['params']['arduinoport'],$GLOBALS['params']['arduinohttpmethod'],"/?pm=$pin&v=$mode&");
}



/**
This function adds an abstraction layer to all the HTTP-Arduino-Ethernet-Shield-digitalWrite logic.
Returns the resulting value of the call to the Arduino's HTTP Server Infrastructure over the Ethernet Shield
In this case, valid digital values are 1 or 0
*/
function digitalWrite($pin,$value)
{
	return getResponse($GLOBALS['params']['arduinohost'],$GLOBALS['params']['arduinoport'],$GLOBALS['params']['arduinohttpmethod'],"/?pd=$pin&v=$value&");
}


/**
This function adds an abstraction layer to all the HTTP-Arduino-Ethernet-Shield-analogWrite logic.
Returns the resulting value of the call to the Arduino's HTTP Server Infrastructure over the Ethernet Shield
*/
function analogWrite($pin,$value)
{
	return getResponse($GLOBALS['params']['arduinohost'],$GLOBALS['params']['arduinoport'],$GLOBALS['params']['arduinohttpmethod'],"/?pa=$pin&v=$value&");
}

/**
This function adds an abstraction layer to all the HTTP-Arduino-Ethernet-Shield-digitalRead logic.
Returns the resulting value of the call to the Arduino's HTTP Server Infrastructure over the Ethernet Shield
*/
function digitalRead($pin)
{
	return getResponse($GLOBALS['params']['arduinohost'],$GLOBALS['params']['arduinoport'],$GLOBALS['params']['arduinohttpmethod'],"/?gd=$pin&");
}


/**
This function adds an abstraction layer to all the HTTP-Arduino-Ethernet-Shield-analogRead logic.
Returns the resulting value of the call to the Arduino's HTTP Server Infrastructure over the Ethernet Shield
*/
function analogRead($pin)
{
	return getResponse($GLOBALS['params']['arduinohost'],$GLOBALS['params']['arduinoport'],$GLOBALS['params']['arduinohttpmethod'],"/?ga=$pin&");
}


/**
This function was made to connect via HTTP with a WEB Server and to return it's response as a String. 
*/
function getResponse($domain,$portno,$method,$url)
{
	$http_response = "";
	$http_request = $method." ".$url ." HTTP/1.0\r\n";
	$http_request .= "\r\n";

	$fp = fsockopen($domain, $portno, $errno, $errstr);
	if($fp){
    		fputs($fp, $http_request);
    		while (!feof($fp)) $http_response .= fgets($fp, 128);
    		fclose($fp);
	}
	return $http_response;
}


?>
