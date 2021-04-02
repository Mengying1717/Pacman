public class Particle{
  float xPos = 0;
  float yPos = 0;
  color myColor;
  float speedOfLevel0 = 0.4;
  float speedOfLevel1 = 0.5;
  float speedOfLevel2 = 0.6;
  float speedOfLevel3 = 0.7;
  float speedOfLevel4 = 0.8;
  float speedOfLevel5 = 0.9;
  float speedOfLevel6 = 1.0;
  float speedOfLevel7 = 1.2;
  float speedOfLevel8 = 1.3;
  float speedOfLevel9 = 1.4;
  float speedOfLevel10 = 1.5;

  Particle(float x, float y,color parColor){
    xPos = x;
    yPos = y;
    myColor = parColor;
  }
  
  void walkOfLevel(int level){
    fill(myColor);
    noStroke();
    ellipse(xPos, yPos, 10, 10); 
    
    xPos = xPos + random(-2,2);
    yPos = yPos + random(-2,2);
    
    switch(level){
      case 0:
      xPos = xPos + speedOfLevel0;
      break;
      case 1:
      xPos = xPos + speedOfLevel1;
      break;
      case 2:
      xPos = xPos + speedOfLevel2;
      break;
      case 3:
      xPos = xPos + speedOfLevel3;
      break;
      case 4:
      xPos = xPos + speedOfLevel4;
      break;
      case 5:
      xPos = xPos + speedOfLevel5;
      break;
      case 6:
      xPos = xPos + speedOfLevel6;
      break;
      case 7:
      xPos = xPos + speedOfLevel7;
      break;
      case 8:
      xPos = xPos + speedOfLevel8;
      break;
      case 9:
      xPos = xPos + speedOfLevel9;
      break;
      case 10:
      xPos = xPos + speedOfLevel10;
      break;
    }  
  }
}
    
