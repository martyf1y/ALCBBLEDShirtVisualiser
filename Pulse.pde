void updatePulse() {  

    counter++;
    beat-=1/repeattime;
    if (counter > repeattime) counter-=counter;
    if (counter == heartRate) beat = 1;
    if (counter == heartRate*2) beat = 1;
    
  }
 
void displayPulse() {
    //float brightness = 255 / (float) heartbeatCount;
    visibility = dist(mouseX, mouseY, hX, hY);
    float shapeRadius = (beat+0.5)/2*pulseRadius;
    visibility = visibility/(max_distance*beat) * 19;
   // fill(beat*250, 81/(beat*2), 210/(beat*2), 255/visibility);
   // ellipseMode(CENTER);
   // ellipse(hX, hY, shapeRadius, shapeRadius);
    
    
    // This is checking the size of the shape and changing the LED to its colour
    for(float shapeWidth = hX - shapeRadius/2; shapeWidth < hX + shapeRadius/2; shapeWidth+=5){  
      float radiusSquared = (shapeRadius/2)*(shapeRadius/2);
      float xSquared = (shapeWidth - hX)*(shapeWidth - hX);
    for(float shapeHeight = hY - sqrt((radiusSquared-xSquared)); shapeHeight < hY + sqrt((radiusSquared-xSquared)); shapeHeight+=5){

     stripNum = (int)(map(shapeWidth, 0, width, 0, 31));
     rowNum = (int)(map(height - shapeHeight, 0, height, 0, 40));
     LEDNum = 0;
 for(int n = 0; n < stripNum; n++){
    LEDNum += LEDsArray[n];
  }
   LEDNum += rowNum;
   if(rowNum < LEDsArray[stripNum]){
    LEDspeed[LEDNum] = 10;
   brightness[LEDNum] = int(255/visibility); // THIS CHANGES THE LED
   Rgb[LEDNum][0] = int(beat*250);
   Rgb[LEDNum][1] = int(81/(beat*2));
   Rgb[LEDNum][2] = int(210/(beat*2));
    stripNumArr[LEDNum] = stripNum;
    rowNumArr[LEDNum] = rowNum;
    LEDNum = 0;
    // You wont need to insert the exact position for arduino, just have the right ID
   }
}
    }


 
 
 
  }