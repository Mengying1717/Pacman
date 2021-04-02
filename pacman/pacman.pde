import processing.serial.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minimOver;
Minim minimStart;
Minim minimEat;
AudioPlayer player;

Serial port;

final int welcomePage=0;
final int gameStart=1;
final int gameOver=2;
final int gamePause=3;

int gameState = welcomePage;
int radius = 15;
int direction = 1;
int direction2 = 0;
int score = 0;
int missed = 0;
int level = 0;
int numberOfParticle = 10;

boolean running = false;

String s0 = "Don't Miss 10 Particle In Every Level!";
String s1 = "Level: 0";
String s2 = "Missed: 0";
String s3 = "score: 0";
String s4 = "Ooops, you missed 10 Particle XD!";
String s5;
String s6;
String bA = "pressedA";
String bB = "pressedB";
String bAB = "pressedAB";
String b8 = "pressed8";
String b16 = "pressed16";

String audioName = "gameOver.mp3";

float renderX = 250;
float renderY = 250;
color myColor;

ArrayList<Particle> poop = new ArrayList();

void setup(){
  printArray(Serial.list());
  port = new Serial(this, Serial.list()[1], 115200);
  port.bufferUntil(10);
  size(500, 500);
  ellipseMode(RADIUS);
}

void draw(){
  switch(gameState){
    case welcomePage:
    welcomePage();
    break;
    
    case gameStart:
    gameStart();
    move();
    break;
    
    case gamePause:
    gamePause();
    break;
    
    case gameOver:
    gameOver(); 
    break;

  }
}
    
void welcomePage(){
  background(0);
  
  textSize(24);
  textAlign(CENTER, CENTER);
  fill(255, 255, 0);
  text(s0,250,200);
 
  textSize(12);
  text("Press AB to Start Game",250,250);
}

void gameStart(){
  background(0);
  fill (255, 255, 0);
  smooth ();
  render();
  
  fill (255);  
  textSize(24);
  textAlign(CENTER, BOTTOM);
  text(s1,250,50);
  
  textSize(10);
  textAlign(RIGHT, BOTTOM);
  text(s2,450,50);
  text(s3,450,35);
  
  for(int i = 0; i<(10); i++){
    Particle P = new Particle((int)random(-width*2,width/3), (int)random(50,height-50), color(random(0,250),random(0,250),random(0,250)));
    poop.add(P);
  } 
}

void move(){
  for(int i = 0; i<(10); i++){
    Particle Pn = (Particle) poop.get(i);
    Pn.walkOfLevel(level);
    
    if (dist(renderX, renderY, Pn.xPos, Pn.yPos)<radius){
      poop.remove(i);
      gameEatPlay();
      
      score = score + 1;
      level = score/10;
      setupLevelPage();
    }
    if(Pn.xPos > width){
      missed = missed + 1;
      Pn.xPos = 0;
    }
  }
  
  if(missed > 0){
    gameState = gameOver;
    gameOverPlay();
    port.write("Show gameOver icon\n");
  }
  s1 = "Level: " + level;
  s2 = "Missed: " + missed;
  s3 = "score: " + score;
  s5 = "Win! Press AB to the Level: " + level;
  s6 = "Total score is: " + score;
}

void setupLevelPage(){
  if((score == 10) || (score == 20) || (score == 30) || (score == 40) || (score == 50) 
  || (score == 60) || (score == 70) || (score == 80) || (score == 90) || (score == 100)){
    gameState = gamePause;
  }
}

void gameOverPlay(){
  minimOver = new Minim(this);
  player = minimOver.loadFile("gameOver.mp3",2048);
  player.play();
}

void gameStartPlay(){
  minimStart = new Minim(this);
  player = minimStart.loadFile("gameStart.mp3",2048);
  player.play();
}

void gameEatPlay(){
  minimEat = new Minim(this);
  player = minimEat.loadFile("gameEat.mp3",2048);
  player.play();
}

void gamePause(){
  background(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text(s5,250,200);
  textSize(12);
  text("Next Level will be more fast!",250,250);
  missed = 0;
  
}

void gameOver(){
  
  gameState = gameOver;
  background(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text(s4,250,200);
  text(s6,250,250);
  
  textSize(12);
  text("Press AB to Restart Game",250,300);
  poop.clear();
  score = 0;
  missed = 0;
  level = 0;
  port.write("Show gameOver icon\n");
  println("Show gameOver icon");
}

void render(){
    for ( int i=-1; i < 2; i++) {
    for ( int j=-1; j < 2; j++) {
      pushMatrix();
      translate(renderX + (i * width), renderY + (j*height));
      if ( direction == -1) { 
        rotate(PI);
      }
      if ( direction2 == 1) { 
        rotate(HALF_PI);
      }
      if ( direction2 == -1) { 
        rotate( PI + HALF_PI );
      }
      arc(0, 0, radius, radius, map((millis() % 500), 0, 500, 0, 0.52), map((millis() % 500), 0, 500, TWO_PI, 5.76) );
      popMatrix();
    }
  }
}

void serialEvent(Serial p) {

  String inData = p.readString();
  if(inData.charAt(0) == '*') {
    inData = inData.substring(1);
    inData = trim(inData);
    
    if(inData.equals(bAB) == true){
      println("pressedAB");  
      gameState = gameStart;
      gameStartPlay();
    }
    
    if(inData.equals(bA) == true){
      println("pressedA");
      renderY = renderY - 25;
      direction = 0;
      direction2 = -1;
    } 
    else if(inData.equals(bB) == true){
      println("pressedB");
      renderY = renderY + 25;
      direction = 0;
      direction2 = 1;
    }
    else if(inData.equals(b8) == true){
      println("pressed8");
      renderX = renderX - 35;
      direction = -1;
      direction2 = 0;
    }
    else if(inData.equals(b16) == true){
      println("pressed16");
      renderX = renderX + 35;
      direction = 1;
      direction2 = 0;
    }
  }
}
