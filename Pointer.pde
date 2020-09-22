
void drawShape() {
  //  calculate node  starting locations
  for (int i=0; i<nodes; i++){
    nodeStartX[i] = centerX+cos(radians(rotAngle))*radius;
    nodeStartY[i] = centerY+sin(radians(rotAngle))*radius;
    rotAngle += 360.0/nodes;
  }


  for(int i = 0; i<3; i++){
    if(Tc[i]==Rc[i]){}
    else if(Tc[i]<Rc[i]){
    Tc[i] ++;
    }
    else if(Tc[i]>Rc[i])
    {
      Tc[i] --;
    }
  }

  // draw polygon
  curveTightness(organicConstant);
  fill(Tc[0],Tc[1],Tc[2]);
  beginShape();
  for (int i=0; i<nodes; i++){
  //  line(nodeX[i], nodeY[i]);
   // curveVertex(nodeX[i], nodeY[i]);
  //  ellipse(nodeX[i], nodeY[i], 10, 10);
  }
  //ellipse(centerX, centerY, 30, 30);
  endShape(CLOSE);
  
   for (int i=0; i<nodes; i++){
      if (nodeX[i] > 0 && nodeX[i] < width && nodeY[i] > 0 && nodeY[i] < height) {
   stripNum = (int)(map(nodeX[i], 0, width, 0, 31));
    rowNum = (int)(map(nodeY[i], height, 0, 0, 40));
    LEDNum = 0;
    for (int n = 0; n < stripNum; n++) {
      LEDNum += LEDsArray[n];
    }
    LEDNum += rowNum;
    if (rowNum < LEDsArray[stripNum]) {
      LEDspeed[LEDNum] = 10;
      brightness[LEDNum] = 255;
      ; // THIS CHANGES THE LED
      Rgb[LEDNum][0] = Tc[0];
      Rgb[LEDNum][1] = Tc[1];
      Rgb[LEDNum][2] = Tc[2];

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
}

void moveShape() {
  //move center point
  float deltaX = pointerX-centerX;
  float deltaY = pointerY-centerY;

  // create springing effect
  deltaX *= springing;
  deltaY *= springing;
  accelX += deltaX;
  accelY += deltaY;

  // move predator's center
  centerX += accelX;
  centerY += accelY;

  // slow down springing
  accelX *= damping;
  accelY *= damping;

  // change curve tightness
  organicConstant = 1-((abs(accelX)+abs(accelY))*.1);

  //move nodes
  for (int i=0; i<nodes; i++){
    nodeX[i] = nodeStartX[i]+sin(radians(angle[i]))*(accelX*2);
    nodeY[i] = nodeStartY[i]+sin(radians(angle[i]))*(accelY*2);
    angle[i]+=frequency[i];
  }
}