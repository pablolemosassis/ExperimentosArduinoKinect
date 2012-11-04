// Test sketch for El Escudo Dos
// Turn each EL channel (A-H) on in sequence and repeat
// Mike Grusin, SparkFun Electronics

int status = HIGH;

void setup() {                
  // The EL channels are on pins 2 through 9
  // Initialize the pins as outputs
  pinMode(2, OUTPUT);  // channel A
  pinMode(9, OUTPUT);  // channel H
  pinMode(6, OUTPUT);  // channel E  
  
  // We also have two status LEDs, pin 10 on the Escudo, 
  // and pin 13 on the Arduino itself
  pinMode(10, OUTPUT);     
  pinMode(13, OUTPUT); 

    
}

void loop() 
{
   

    digitalWrite(2, HIGH);   // turn the EL channel on
    delay(300);              // wait for 1/10 second
    digitalWrite(2, LOW);    // turn the EL channel off
    
    digitalWrite(9, HIGH);   // turn the EL channel on
    delay(300);              // wait for 1/10 second
    digitalWrite(9, LOW);    // turn the EL channel off
    
    digitalWrite(6, HIGH);   // turn the EL channel on
    delay(300);              // wait for 1/10 second
    digitalWrite(6, LOW);    // turn the EL channel off

    digitalWrite(10, status);   // blink both status LEDs
    delay(300);
    digitalWrite(13, status);
    delay(300);
    status = !status; 
  
}
