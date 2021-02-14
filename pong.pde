import processing.sound.*;

SoundFile wallSound ;
SoundFile raquetSound;

int heightPlayer1 = height/2;
int heightPlayer2 = height/2;

int pointsPlayer1 = 0;
int pointsPlayer2 = 0;

boolean upMovePlayer1 = false;
boolean downMovePlayer1 = false;

boolean upMovePlayer2 = false;
boolean downMovePlayer2 = false;

int moveStep = 8;

int radius = 5;
float ballX = (width/2)-radius;
float ballY = 200;
float ballXSpeed = 5;
float ballYSpeed;

boolean resetBall= false;

boolean gameStarted = false;
boolean gamePaused = false;

void setup(){
  size(650, 430);
  stroke(255, 255, 255);
  strokeWeight(10);
  ballX = (width/2);
  ballYSpeed = random(-2, 2);
  
  drawMenu(); 
  
  heightPlayer1 = height/2 - 50;
  heightPlayer2 = height/2 - 50;
  
  wallSound = new SoundFile ( this , "C:/Users/asus/Downloads/4366__noisecollector__pongblipb3.wav" );
  raquetSound = new SoundFile ( this , "C:/Users/asus/Downloads/4365__noisecollector__pongblipa5.wav");
  textSize(40);
}

void draw ()
{
  if(!gameStarted || gamePaused) return;
  
  if (resetBall){
    delay(400);
    resetBall = false;  
    heightPlayer1 = height/2 - 50;
    heightPlayer2 = height/2 - 50;
  }
  
  background(0, 0, 0);
  
  heightPlayer1 = movePlayer(heightPlayer1, downMovePlayer1, upMovePlayer1);
  heightPlayer2 = movePlayer(heightPlayer2, downMovePlayer2, upMovePlayer2);
  
  rect(50, heightPlayer1, 2, 70);
  rect(width - 50, heightPlayer2, 2, 70);
  
  if (ballY < 0 || ballY > height - radius){
    ballYSpeed = -ballYSpeed;
    wallSound.play();
    if(ballY < 0) ballY = 0;
    else ballY = height - radius;
  }
  
  if (ballX  < 54 + radius){
    if (ballY > heightPlayer1 - 10 &&  ballY - 80 <= heightPlayer1){
      ballXSpeed = 8 + Math.abs((heightPlayer1 + 37.5 - ballY)/37.5 * 3);
      ballYSpeed = - (heightPlayer1 + 37.5 - ballY)/37.5 * 4;
      raquetSound.play();
      ballX = 54 + radius;
    }else{
      resetBall = true;
      pointsPlayer2++;
    }
  }
  
  if (ballX  > width - 54 - radius){
    if (ballY > heightPlayer2 - 10 && ballY - 80 <= heightPlayer2){
      ballXSpeed = - 8 - Math.abs((heightPlayer2 + 37.5 - ballY)/37.5 * 3);
      ballYSpeed = - (heightPlayer2 + 37.5 - ballY)/40 * 4;
      raquetSound.play();
      ballX = width - 54 - radius;
    }else{
      resetBall = true;
      pointsPlayer1++;
    }
  }
  
  ballX += ballXSpeed;
  ballY += ballYSpeed;
  fill(255, 0, 0);
  text(pointsPlayer1, (width / 2) - 60, 50); 
  fill(0, 100, 255);
  text(pointsPlayer2, (width / 2) + 40, 50); 
  fill(255, 255, 255);
  
  if (resetBall){
    ballX = (width/2) - radius;
    ballY = 200;
    ballYSpeed = random(-2, 2);
    if ((pointsPlayer1 + pointsPlayer2) % 2 == 0) ballXSpeed = 5;
    else ballXSpeed = -5;
  }else ellipse(ballX , ballY , radius ,radius);
  
  for(int i = 0 ; i < 15 ; i++) rect(width /2 -1, i*(height/14), 2, 5);
  
  if (pointsPlayer1 == 10 || pointsPlayer2 == 10){
    gameStarted = false;
    drawMenu();
    
    textSize(40);
    if(pointsPlayer1 == 10) text("Left player wins", (width / 2) - 150, height - 220); 
    else text("Right player wins", (width / 2) - 150, height - 220); 
    text(pointsPlayer1 + " - " + pointsPlayer2, (width / 2) - 60, height - 170); 
    textSize(30);
    pointsPlayer1 = 0;
    pointsPlayer2 = 0;
  }
}

int movePlayer(int heightPlayer, boolean downMove, boolean upMove){
  int newHeight = heightPlayer;
  if (upMove) newHeight -= moveStep;
  if (downMove) newHeight += moveStep;
  
  if (newHeight < 5) newHeight = 5;
  if (newHeight > height - 70 - 5) newHeight = height - 70 - 5;
  return newHeight;
}

void drawMenu(){
  background(0, 0, 0);
  textSize(30);  
  text("Space to pause the game", (width / 2) - 180, height - 100); 
  text("Left Player w -> up, s -> down", (width / 2) - 230, 100); 
  text("Right Player arrows up and down", (width / 2) - 240, 130);
  
  textSize(40);
  text("Controls:", (width / 2) - 100, 60); 
  
  textSize(45);
  fill(255, 0, 0);
  text("Hit any key to start game", (width / 2) - 270, height - 40); 
  fill(255, 255, 255);
}

void keyPressed() {
  if (key == 'w') upMovePlayer1 = true;
  if (key == 's') downMovePlayer1 = true;
  
  if (keyCode == UP) upMovePlayer2 = true;
  if (keyCode == DOWN) downMovePlayer2 = true;
  
  if (gameStarted && key == ' '){
    gamePaused = !gamePaused;
    if (gamePaused) text("Space to resume", (width / 2) - 167, 200); 
  }
  if (!gameStarted) gameStarted = true;
}

void keyReleased(){
  if (key == 'w') upMovePlayer1 = false;
  if (key == 's') downMovePlayer1 = false;
  
  if (keyCode == UP) upMovePlayer2 = false;
  if (keyCode == DOWN) downMovePlayer2 = false;
}
