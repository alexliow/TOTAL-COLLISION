
int height1 = 500;
int width1 = 700;

Game game;
Runner runner1;
int runnerSize = 60;
float runnerMargin = 60.0;
Enemy enemy1;
Enemy enemy2;
Enemy enemy3;
Enemy[] enemies;
int enemyCount;

float gravity =10000;

float jumpTime = 0.0;
boolean jump = false;

float collideTextVert;
float collideTextHor;

void setup(){
  frameRate(500);
  size(700, 500);
  frameRate(300);
  background(255);
  fill(20);
  noStroke();
  game = new Game();
  runner1 = new Runner(runnerMargin, height1 - runnerSize);
  enemy1 = new Enemy(60.0, 4.0, 1.2, 0.0);
  
  enemyCount = 3;
  
  enemies = new Enemy[enemyCount];
  enemies[0] = enemy1;
  
}

void draw(){
  
  
  switch (game.gameState){
    case "menu":
      runner1.display();
      textSize(32);
      text("Press UP to start.", 10, 30);
      text("Watch out for <TOTAL COLLISIONS>.", 10, 60);
      break;
     case "play":
     background(255);
      enemy1.display();
      enemy1.move();
      runner1.display();
      runner1.run();
      
      if (enemy2!=null){
        enemy2.display();
        enemy2.move(); 
      }
      
      if (enemy3!=null){
        enemy3.display();
        enemy3.move(); 
      }
      
      for (int i = 0; i < enemyCount; i++){
        if (enemies[i] != null){
          enemies[i].display();
          if (enemies[i].xPos >= runnerMargin - enemies[i].objWidth && 
            enemies[i].xPos <= runnerMargin + runnerSize){
            if (runner1.yPos + runnerSize >= height1 - enemies[i].objHeight + 2){
              println("TotalCollide!!");
              
              game.gameState = "lost";
            }
          }
        }
      }
      
      
      
      
     //makes new enemies when last enemy of wave has left screen
     
     if (enemies[1] == null){
       if(enemies[0].xPos + enemies[0].objWidth < 0){
         generateEnemies(2);
       }
     }
     else if (enemies[2] == null) {
       if (enemies[1].xPos + enemies[1].objWidth < 0){
         generateEnemies(3);
      }
     }
     else {
       if (enemies[2].xPos + enemies[2].objWidth < 0){
         generateEnemies(3);
      }
     }
      
      break;
     case "lost":
       textSize(120);
       text("TOTAL", 20, 120);
       text("COLLISION", 20, 240);
       text("!", 20, 360);
       
       collideTextVert = random(height1);
       collideTextHor = random(-50, width1);
       textSize(12);
       text("collide!", collideTextHor, collideTextVert);
       
       break;
     
      
  }
  
  if (height1 - runnerSize < runner1.yPos){
    jump = false; 
    jumpTime = 0;
  }
  
}



void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP){
      if (game.gameState == "menu"){
        game.gameState = "play";
      }
      if (game.gameState == "lost"){
        game.gameState = "play"; 
      }
     jump = true;
    }
  }
}

void generateEnemies(int x){
  if (x == 2) {
     enemy1 = new Enemy(random(60,120), 4.0, random(0.8,1.0), 0.0);
     enemy2 = new Enemy(random(50,100), 4.0, random(0.8,1.0), random(180,280));
     enemies[0]= enemy1;
     enemies[1]= enemy2;
     enemies[2] = null;
   }
    
   if (x == 3) {
     enemy1 = new Enemy(random(60,120), 4.0, random(0.8,1.0), 0.0);
     enemy2 = new Enemy(random(50,100), 4.0, random(0.8,1.0), random(180,280));
     enemy3 = new Enemy(random(60,110), 4.0, random(0.8,1.0), random(420,640));
     enemies[0]= enemy1;
     enemies[1]= enemy2;
     enemies[2]= enemy3; 
   }
}

class Runner {
  float xPos;
  float yPos;
  float xVelocity;
  float yVelocity = 5;
  
  Runner(float _xPos, float _yPos){
    xPos = _xPos;
    yPos = _yPos;
  }
  
  void run() {
    //xPos = xPos + 1;
    if (xPos > width1){
      xPos = 0;
    }
    if (jump == true){
      yPos = (height1 - runnerSize) -  (yVelocity * sin(radians(88)) * jumpTime) + ( 0.03 * sq(jumpTime));
      jumpTime += 1;
    }
  }
  
  
  void display() {
    rect(xPos, yPos, runnerSize, runnerSize);
  }

}

class Enemy {
  float xPos;
  float objHeight;
  float objWidth;
  float speed;
  float buffer;
  
  Enemy(float _objHeight, float _objWidth, float _speed, float _buffer){
    
    objHeight = _objHeight;
    objWidth = _objWidth;
    speed = _speed;
   buffer = _buffer;
    
    xPos = width1 + buffer;
  }
  
  void move() {
    xPos = xPos - speed;
    //if (xPos < -20){
    //  xPos = width1;
    //}
  }
  
  void display() {
    rect(xPos, height1-objHeight, objWidth, objHeight);
  }

}

class Game {
  String gameState;
  String[] states = {"menu", "play", "lost"};
  int points = 0;
  
  Game(){
    gameState = "menu";
  }
  
  
}