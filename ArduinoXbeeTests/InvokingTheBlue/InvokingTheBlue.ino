
//waiting for the first time - runs only once
int delayZero = 1;

//time before light on
int firstDelay = 20000;
//time before light off
int secondDelay = 200; 
//
//lasta amount of time to reduce from firstDelay
int lastReduce = 500;
//array of amounts to reduce from firstDelay
int myPins[] = {5000, 4000, 3000, 2000, 1000, lastReduce};
int i = 0;
//
//how many times it has blinked
int howManyBlinks = 0;
//how many times it should blink
int howManyBlinksTotal = 10;
//if it has blinked more than howManyBlinksTotal, stop blinking
boolean stopBlinking = false;


void setup() {

  
  // The EL channels are on pins 2 through 9
			// Initialize the pins as outputs
			pinMode(2, OUTPUT);  // channel A  
			pinMode(3, OUTPUT);  // channel B   
			pinMode(4, OUTPUT);  // channel C
			pinMode(5, OUTPUT);  // channel D 

			pinMode(6, OUTPUT);  // channel E

			pinMode(7, OUTPUT);  // channel F
			pinMode(8, OUTPUT);  // channel G
			pinMode(9, OUTPUT);  // channel H
			
}

void loop() {
  //delay for the first time
  delay(delayZero); 
  delayZero = 0;
  //
  delay(firstDelay);  
  digitalWrite(6, HIGH);
  
  delay(secondDelay);  
  if(!stopBlinking){
    digitalWrite(6, LOW);
  }
 
  //descrease how much time it should take untill it lights on again 
  firstDelay = firstDelay - myPins[i]; 
  if(myPins[i] == lastReduce){
     
  }else{
     i = i + 1;
  }
  //
  //makes on and off with iqual speed and starts counting the blinks
  if(firstDelay < 500){
    firstDelay = secondDelay;
    howManyBlinks = howManyBlinks + 1;
  }
  //
  if(howManyBlinks >= howManyBlinksTotal){
    stopBlinking = true;
  }
}
