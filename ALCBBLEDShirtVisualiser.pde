// Script by Matt, June 2015

BirdObject Birdy, PulseBirdy; // This is for the sending the signal away
Rib[] ribs = new Rib[10];
//int birdNum = 1;
//ArrayList Birds;

// LEDS
int maxLEDs = 1054;
int [] LEDspeed = new int [maxLEDs];
int[][] Rgb = new int [1054][3];
int [] brightness = new int [maxLEDs];
int [] stripNumArr = new int [maxLEDs];
int [] rowNumArr = new int [maxLEDs];
int[] LEDsArray = {23, 25, 26, 27, 38, 40, 40, 40, 40, 37, 36, 35, 35, 34, 34, 34, 34, 34, 35, 35, 35, 37, 40, 40, 40, 40, 38, 27, 26, 25, 24};

int stripNum; // This is which strip the LED is on
int rowNum; //This is how far up the LED is
int LEDNum; // This is the LED ID

//Pulse 
// Pulse
float max_distance;
int hX = 300; 
int hY = 280; //the heart position
float visibility;
int counter;
float heartRate = 10;
float beat;
float pulseRadius = 105;
float repeattime = 35;



/// pointer 

// center point
float centerX = 0, centerY = 0;
float radius = 20, rotAngle = -90;
float accelX, accelY;
float springing = 2, damping = .28;
float[] Rc = new float[3]; // The random colours for the pointer to go to
int[]Tc = new int[3]; // The actual colours that the pointer is

//corner nodes
int nodes = 5;
float nodeStartX[] = new float[nodes];
float nodeStartY[] = new float[nodes];
float[]nodeX = new float[nodes];
float[]nodeY = new float[nodes];
float[]angle = new float[nodes];
float[]frequency = new float[nodes];

// soft-body dynamics
float organicConstant = 1;

//timer
int time;
int wait = 5000;


// Ribs
float pointerX;
float pointerY;
float easing = 0.9;
int followX, followY;

void setup()
{
  size(640, 820); // half this
  background(0);

  Birdy = new BirdObject(random(0, 620), 0, random(7, 12)+0.2, 120, 25, 205); // half this
  PulseBirdy = new BirdObject(hX, height - hY, random(7, 12)+0.2, 0, 0, 0); // half this

  /// Pulse
  time = millis();//store the current time
  noStroke();
  // pulse distance
  max_distance = dist(hX, 0, width, hX);


  // Ribs
  noCursor();
  int posX = 40;
  int posY = 440;
  int sizeX = 15;
  ribs[0] = new Rib(posX, posY, posX*2, sizeX, 0.98, 8.0, 0.1, 0); 
  ribs[1] = new Rib(posX*2, posY+75, posX*4, int(sizeX*1.5), 0.95, 9.0, 0.1, 1); 
  ribs[2] = new Rib(posX*3, posY+170, posX*6, sizeX*2, 0.90, 9.9, 0.1, 2);
  ribs[3] = new Rib(posX*2, posY+240, posX*4, int(sizeX*1.5), 0.95, 9.0, 0.1, 1); 
  ribs[4] = new Rib(posX, posY+320, posX*2, sizeX, 0.90, 9.9, 0.1, 2);
  ribs[5] = new Rib(width-40, posY, 80, sizeX, 0.98, 8.0, 0.1, 0); 
  ribs[6] = new Rib(width-80, posY+75, 160, int(sizeX*1.5), 0.95, 9.0, 0.1, 1); 
  ribs[7] = new Rib(width-120, posY+170, 240, sizeX*2, 0.90, 9.9, 0.1, 2);
  ribs[8] = new Rib(width-70, posY+240, 149, int(sizeX*1.5), 0.95, 9.0, 0.1, 1); 
  ribs[9] = new Rib(width-28, posY+320, 56, sizeX, 0.90, 9.9, 0.1, 2);
  
  
  /// pointer
   Rc[0] = random(30, 205);
  Rc[1] = random(30, 205);
  Rc[2] = random(30, 205);
  Tc[0] = 255;
  Tc[1] = 255;
  Tc[2] = 255;
  
  //center shape in window
  centerX = width/2;
  centerY = height/2;
  // iniitalize frequencies for corner nodes
  for (int i=0; i<nodes; i++){
    frequency[i] = random(5, 12);
  }
}

void draw() {

  background(0);
 // fill(0);
 // rect(width/2,height/2,width, height);
  centerX += 10;
  centerY += 10;
  
  //// The basic grid
  for (int x=0; x < LEDsArray.length; x++) {
    for (int y = 0; y < LEDsArray[x]; y++) {
      fill(255, 255, 255);
       //  ellipse(x * 20 + 10, height - 10 - (y*20), 10, 10); // half this
    }
  }
 moveShape();
  drawShape();
  updatePulse();
  displayPulse();

  if (millis() - time >= wait) {
    // println("tick");//if it is, do something
    repeattime = random(25, 120); // Pulse speed changes
    time = millis();//also update the stored time
      for(int i = 0; i<3; i++){
    Rc[i] = random(30, 255);
  }
  }





  ////// Bird Stuff
  Birdy.Move();
  PulseBirdy.Move();

  //}
  /// Ribs stuff


  float targetX = mouseX;
  float dx = targetX - pointerX;
  pointerX += dx * easing;

  float targetY = mouseY;
  float dy = targetY - pointerY;
  pointerY += dy * easing;

  for (Rib rib : ribs) { 
    rib.update(); 
    rib.display();
  }
  for (int i = 0; i < 10; i ++) {

    if (ribs[i].over) {
      easing = 0.1;
      break;
    } else {
      easing = 0.9;
    }
  }

  /// Mouse
  //fill(255);
  //strokeWeight(20.0);
  //stroke(255, 100);
  //ellipse(pointerX, pointerY, 20, 20);
  //strokeWeight(0);

 


  //////////// This updates the LEDs ////////////
  for (int i=0; i<maxLEDs; i++) {
    //SignalShine = ( Signal ) LED.get(i);
    if (brightness[i] != 0) {
      ShineOn(i, rowNumArr[i], stripNumArr[i], brightness[i], LEDspeed[i]); //Get the right ID, brightness and speed to update LED
    }
  }

  // ALWAYS PUT SHOW AT THE BOTTOM !!!!!!!!!!!!!!!!!!!!!!
}

void ShineOn(int ID, int rowNum, int columnNum, float bright, int thisSpeed) {

  ///// Make sure to get LED brightness before we go any further!
  int r = Rgb[ID][0];
  int g = Rgb[ID][1];
  int b = Rgb[ID][2];

  // This would just be the ID number
  fill(r, g, b, bright);
  ellipse(columnNum * 20 + 10, height - 10 - (rowNum*20), 10, 10); // half this

  bright -= 1*thisSpeed;

  if (bright <= 0) {
    bright = 0;
    LEDspeed[ID] = 0;
  }
  brightness[ID] = int(bright);
}

void keyPressed() { 
  if (key==' ') setup();
  //  if (key=='f') fade=!fade;
}