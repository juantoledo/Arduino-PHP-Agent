/* Arduino PHP Agent Arduino Sketch. For communicating with the agent.php script
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
#include <Client.h>
#include <Ethernet.h>
#include <Server.h>
#include <Udp.h>
#include <WString.h>
#include <SPI.h> 
#include <Client.h>
#include <Ethernet.h>
#include <Server.h>
#include <Udp.h>
#include <WString.h>
#include <SPI.h> 
 

//Ethernet Shield Settings, please adapt to your specific needs
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; //physical mac address
byte ip[] = { 192, 168, 3, 201 }; // ip in lan
byte gateway[] = { 192, 168, 3, 1 }; // internet access via router
byte subnet[] = { 255, 255, 255, 0 }; //subnet mask
EthernetServer  server(84); //server port


//init. of the agent, this one will receive info from the Arduino; mostly agent.php
byte agentip[] = { 192, 168, 3, 200 }; //ip on the agent.php was deployed
int agentport = 80; //tcp port for it
//Client agent(agentip, agentport); 


String readString = String(100); //string for fetching data from address and control variables
int isExecuting = 0;
String pin = String(2);
String value = String(4);

int n; //numeric pin
int v; //numeric pin value
String output; 
  

void setup() {
  
  // start the Ethernet connection and the server:
  Ethernet.begin(mac, ip);
  server.begin();
  Serial.print("server is at ");
  Serial.println(Ethernet.localIP());
    
    //Serial Settings
    delay(2000);
    Serial.begin(9600);
    delay(2000);
}



void loop() {
  // Create a client connection
   EthernetClient client = server.available();
    
  //If a HTTP Request was made to this server
  if(client){
    while (client.connected()) {
      if (client.available()) {
        
        char c = client.read();
        
            //read char by char HTTP request
            if (readString.length() < 100) {
              //store characters to string
              readString.concat(c);
            }
          
            //if HTTP request has ended
            if (c == '\n') {
              
              //Put digital
              if(readString.indexOf("/?pd=")!=-1 && readString.indexOf("&v=")!=-1) {
                pin = readString.substring(readString.indexOf("/?pd=")+5,readString.indexOf("&"));
                value = readString.substring(readString.indexOf("&v=")+3,readString.indexOf("&", readString.indexOf("&v=")+1));
                
                char narray[3];
                char varray[2];
                pin.toCharArray(narray, sizeof(narray));
                value.toCharArray(varray, sizeof(varray));
                n = atoi(narray);
                v = atoi(varray);
                //Serial.print(n);
                //Serial.println(v);
                digitalWrite(n,v);
              }
              ///////////////////
              
              //Put analog
              if(readString.indexOf("/?pa=")!=-1 && readString.indexOf("&v=")!=-1) {
                pin = readString.substring(readString.indexOf("/?pa=")+5,readString.indexOf("&"));
                value = readString.substring(readString.indexOf("&v=")+3,readString.indexOf("&", readString.indexOf("&v=")+1));
                
                char narray[3];
                char varray[5];
                pin.toCharArray(narray, sizeof(narray));
                value.toCharArray(varray, sizeof(varray));
                n = atoi(narray);
                v = atoi(varray);
                //Serial.print(n);
                //Serial.println(v);
                analogWrite(n,v);
              }
              
              
              //get digital
              if(readString.indexOf("/?gd=")!=-1) {
                pin = readString.substring(readString.indexOf("/?gd=")+5,readString.indexOf("&"));
                char narray[3];
                pin.toCharArray(narray, sizeof(narray));
                n = atoi(narray);
                //Serial.print(n);
                client.println(digitalRead(n));
              }
              
              //get analog
              if(readString.indexOf("/?ga=")!=-1) {
                pin = readString.substring(readString.indexOf("/?ga=")+5,readString.indexOf("&"));
                char narray[5];
                pin.toCharArray(narray, sizeof(narray));
                n = atoi(narray);
                //Serial.print(n);
                client.println(analogRead(n));
              }
              
              //Pin mode
              if(readString.indexOf("/?pm=")!=-1 && readString.indexOf("&v=")!=-1) {
                pin = readString.substring(readString.indexOf("/?pm=")+5,readString.indexOf("&"));
                value = readString.substring(readString.indexOf("&v=")+3,readString.indexOf("&", readString.indexOf("&v=")+1));
                
                char narray[3];
                char varray[2];
                pin.toCharArray(narray, sizeof(narray));
                value.toCharArray(varray, sizeof(varray));
                n = atoi(narray);
                v = atoi(varray);
                switch(v)
                {
                  case 0: pinMode(n,OUTPUT); /*Serial.println("OK;");*/ break;
                  case 1: pinMode(n,INPUT); /*Serial.println("OK;");*/ break;
                }  
              }
              
              //now output HTML data header
              client.println();
              client.println();
              delay(1);
              //stopping client
              client.stop();
            
              /////////////////////
              //clearing string for next read
              readString="";
              pin="";
              value="";
                
            }
        }
    }
  }
  else{
      /*
        *
        * HERE YOU CAN PLACE YOUR OWN LOGIC, FOR EXAMPLE, A SIGNAL FROM A SENSOR, A SERIAL MESSAGE, ETC AND SEND IT TO THE PHP AGENT 
        * IN THE FORM AS FOLLOWING:
        
           /agent.php?data=D1-0   //digital pin: 0, value read from the Arduino's input: 0 
           
           or 
           
           /agent.php?data=A4-130 //analog pin: 4, value read from the Arduino's input: 130
        * 
        * Example: 
        
              output = "D2-1";
        *     if(agent.connect())
              {
                Serial.println("Conn<OK>");
                agent.print("GET /agent.php?data=");
                agent.print(output);
                agent.println(" HTTP/1.0");
                agent.println();
                agent.flush();
                agent.stop();
                delay(500);
              }
              else {
                Serial.println("CONN<FAIL>");
              }
              output="";
        *
        */  
  }
}



