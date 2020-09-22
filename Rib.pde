
class Rib { 
  // Screen values 
  float xpos, ypos;
  float tempxpos, tempypos; 
  int sizeX; 
  int sizeY;
  boolean over = false; 
  boolean move = false; 

  // Spring simulation constants 
  float mass;       // Mass 
  float k = 0.2;    // Spring constant 
  float damp;       // Damping 
  float rest_posx;  // Rest position X 
  float rest_posy;  // Rest position Y 

  // Spring simulation variables 
  //float pos = 20.0; // Position 
  float velx = 0.0;   // X Velocity 
  float vely = 0.0;   // Y Velocity 
  float accel = 0;    // Acceleration 
  float force = 0;    // Force 

  int me;

  float max_distance = dist(0, 0, width/3, height/3);

  // Constructor
  Rib(float x, float y, int sX, int sY, float d, float m, 
    float k_in, int id) { 
    xpos = tempxpos = x; 
    ypos = tempypos = y;
    rest_posx = x;
    rest_posy = y;
    sizeX = sX;
    sizeY = sY;
    damp = d; 
    mass = m; 
    k = k_in;
    me = id;
  } 

  void update() { 
    if (overEvent()) { 
      over = true;
      rest_posy = mouseY; 
      rest_posx = mouseX;
    } else { 
      over = false;
    }

    force = -k * (tempypos - rest_posy);  // f=-ky 
    accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
    vely = damp * (vely + accel);         // Set the velocity 
    tempypos = tempypos + vely;           // Updated position 

    force = -k * (tempxpos - rest_posx);  // f=-ky 
    accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
    velx = damp * (velx + accel);         // Set the velocity 
    tempxpos = tempxpos + velx;           // Updated position 
  } 

 

void display() { 
    float ribOpacity = dist(xpos, ypos, mouseX, mouseY);
    ribOpacity = max_distance/ribOpacity*20;

    rectMode(CENTER);
   // rect(tempxpos, tempypos, sizeX, sizeY);

if(over){
  if(xpos-width/2 < 0){
  float randomX = map(tempxpos, 0, width/2, 25, 0);
     tempxpos += random(-5, randomX);
  }
  else{
      float randomX = map(tempxpos, width, width/2, -25, 0);
         tempxpos += random(randomX, 5);
  }
   tempypos += random(-7, 7);
}

    // This is checking the size of the shape and changing the LED to its colour
    for (float shapeWidth = tempxpos - sizeX/2; shapeWidth < tempxpos + sizeX/2; shapeWidth+=5) {  
      for (float shapeHeight = tempypos - sizeY/2; shapeHeight < tempypos + sizeY/2; shapeHeight+=5) {

        if (shapeWidth > 0 && shapeWidth < width && shapeHeight > 0 && shapeHeight < height) {
          stripNum = (int)(map(shapeWidth, 0, width, 0, 31));
          rowNum = (int)(map(height - shapeHeight, 0, height, 0, 40));
          LEDNum = 0;

          for (int n = 0; n < stripNum; n++) {
            LEDNum += LEDsArray[n];
          }
          LEDNum += rowNum;
          if (rowNum < LEDsArray[stripNum]) {
            LEDspeed[LEDNum] = 10;
            if (over) { 
              brightness[LEDNum] = 255; // THIS CHANGES THE LED
            } 
            else{
              brightness[LEDNum] = int(ribOpacity); // THIS CHANGES THE LED
            }
            
              Rgb[LEDNum][0] = 77;
              Rgb[LEDNum][1] = 77;
              Rgb[LEDNum][2] = 255;
            stripNumArr[LEDNum] = stripNum;
            rowNumArr[LEDNum] = rowNum;
            LEDNum = 0;
            // You wont need to insert the exact position for arduino, just have the right ID
          }
        }
      }
    }
  } 

 // Test to see if mouse is over this spring
  boolean overEvent() {
    float disX = tempxpos - mouseX;
    float disY = tempypos - mouseY;
    if (disX < sizeX/2 && disY < sizeY/2 && disX > -sizeX && disY > -sizeY) {
      return true;
    } else {
      released();
      return false;
    }
  }

  void released() { 
    rest_posx = xpos;
    rest_posy = ypos;
  }
}