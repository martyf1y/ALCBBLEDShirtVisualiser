class BirdObject
{
  PVector pos;
  float dirAngle=0;            // direction of birds
  float randomSpeedChange=random(1)-0.5;       // magnitude of random speed changes
  int unrest=5;                                // % chance of random changes
  float speed=0;
  float minSpeed=3;                            // lower speed limit
  float maxSpeed=10;                            // upper speed limit
  int timer;
  float endTime = 1000;
  PVector moveStep = new PVector(0, 1);
  float dirX = cos(degrees(random(0, 360)));
  float dirY = sin(degrees(random(0, 180)));
  float ranWave = random(20, 30);
  float ranWaveWidth = random(5, 20); // This is the width between each spiral side, larger is wider
  int red, green, blue;

  BirdObject(float inX, float inY, float inSPEED, int r, int g, int b) {
    pos = new PVector(inX, inY); 
    speed = inSPEED;  
    timer = millis();
    red = r;
    green = g;
    blue = b;
  }

  void Move() {
    //moveStep = new PVector(0,1);
    //  if (endTime <=  millis() - timer) {
    //    dir = cos(degrees(random(-15, 15)));
    //    timer = millis();
    //    endTime = random(500, 3000);
    //  } 
    // dir = cos(degrees(200));
    float wave = sin(radians(millis()/ranWave*speed/2));
    moveStep = new PVector((dirX*3) + wave * ranWaveWidth, random(-0.5, -1));
    // moveStep.x = moveStep.x * speed;
    moveStep.y = moveStep.y * speed;
    //    moveStep.mult(speed);

    pos.add(moveStep);
    // check border condition

    if (pos.x<0) {
      speed = random(3, 7);
      pos.x=hX; 
      pos.y=height- hY;
      dirX = cos(degrees(random(0, 180)));
      ranWaveWidth = random(5, 20);
      ranWave = random(4, 20);
    }
    if (pos.x>=width) {
      speed = random(3, 7);
      pos.x = hX; 
      pos.y = height- hY;
      dirX = cos(degrees(random(0, 180)));
      ranWaveWidth = random(5, 20);
      ranWave = random(4, 20);
    }
    if (pos.y>=height) {
      speed = random(3, 7);
      pos.y = height- hY;
      pos.x = hX; 
      dirX = cos(degrees(random(0, 180)));
      ranWaveWidth = random(5, 20);
      ranWave = random(4, 20);
    }
    if (pos.y<=0) {
      speed = random(3, 7);
      pos.y= height- hY;
      pos.x = hX; 
      dirX = cos(degrees(random(0, 180)));
      ranWaveWidth = random(5, 20);
      ranWave = random(4, 20);
    }

    //  ranWave = random(20, 30);
    ranWaveWidth = random(5, 20);
    //  dirX = cos(degrees(random(0, 180)));
    speed += 0.07;


    stripNum = (int)(map(pos.x, 0, width, 0, 31));
    rowNum = (int)(map(pos.y, 0, height, 0, 40));
    LEDNum = 0;
    for (int n = 0; n < stripNum; n++) {
      LEDNum += LEDsArray[n];
    }
    LEDNum += rowNum;
    if (rowNum < LEDsArray[stripNum]) {
      LEDspeed[LEDNum] = int(speed/1.5);
      brightness[LEDNum] = int(255/visibility);
      ; // THIS CHANGES THE LED
      Rgb[LEDNum][0] = int(beat*250);
      Rgb[LEDNum][1] = int(81/(beat*2));
      Rgb[LEDNum][2] = int(210/(beat));

      //  Rgb[LEDNum][0] = 0;
      // Rgb[LEDNum][1] = 0;
      // Rgb[LEDNum][2] = 255;
      stripNumArr[LEDNum] = stripNum;
      rowNumArr[LEDNum] = rowNum;
      LEDNum = 0;
      // You wont need to insert the exact position for arduino, just have the right ID
    }
  }
}