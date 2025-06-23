// ================= ENEMY PROJECTILE VARIABLES =================
final int MAXPROJECTILES = 5; 
float[] enemyProjX = new float[MAXPROJECTILES];
float[] enemyProjY = new float[MAXPROJECTILES];
boolean[] enemyProjActive = new boolean[MAXPROJECTILES]; 
float enemyProjSpeed = 8; 
float enemyProjWidth = 6;
float enemyProjHeight = 15;
int lastShotTime = 0; 
int shotDelay = 500;

// ================= BUNKER VARIABLES =================
int[] bunkerHealth = {5, 5, 5}; 
color[] bunkerColors = {#00FF00, #00FF00, #00FF00}; 
int bunkerWidth = 100;
int bunkerHeight = 20;
int[] bunkerX = {150, 410, 670}; 
int bunkerY = 650; 

// ================= LASER (PLAYER BULLET) VARIABLES =================
float laserX, laserY; 
float laserSpeed = 8;
float laserWidth = 12;
float laserHeight = 30;
boolean laserActive = false; 

// ================= ENEMY MOVEMENT VARIABLES =================
float enemySpeed = 3; 
int enemyDirection = 1; 

// ================= PADDLE VARIABLES =================
float paddleWidth = 120;
float paddleHeight = 10;
float paddleX; 
float paddleY; 
float paddleSpeed = 10;

// ================= ENEMY ARRAY =================
int n = 40; 
int[] x = new int[n]; 
int[] y = new int[n]; 
float brickw = 80;
float brickh = 50;
boolean[] enemyAlive = new boolean[n]; 

// ================= COLORS =================
color darkblue = #064780;
color black = #000000;
color white = #FFFFFF;
color pink = #ef7a85;
color purple = #b298dc;
color red = #b23a48;
color lightblue = #ADD8E6;
color orange = #FFA500;
color green = #00FF00;

// ================= TEXT =================
float TextSize = 100;
boolean growing = true;
PFont waltograph;

// ================= GAME STATE VARIABLES =================
int lives = 3;
int score = 0;
final int INTRO = 0;
final int GAME = 1;
final int GAMEOVER = 2;
final int WIN = 3;
final int PAUSE = 4;
int mode = INTRO;

// ================= PLAYER CONTROLS =================
boolean wkey, akey, skey, dkey;
boolean upkey, leftkey, downkey, rightkey;

// ================= SETUP =================
void setup() {
  size(920, 1350); 
  paddleX = width/2 - paddleWidth/2; 
  paddleY = 800;

  // === SETUP ENEMIES ===
  int i = 0;
  int row = 0;
  while (row < 6) { 
    int col = 0;
    while (col < 8 && i < n) { 
      x[i] = 100 + col * (int)(brickw + 20); 
      y[i] = 100 + row * (int)(brickh + 20); 
      enemyAlive[i] = true;
      i++;
      col++;
    }
    row++;
  }
}

// ================= DRAW LOOP =================
void draw() {
  background(darkblue);

 
  if (mode == INTRO) {
    introScreen();
  } else if (mode == GAME) {
    gameScreen();
  } else if (mode == GAMEOVER) {
    gameOverScreen(); 
  } else if (mode == WIN) {
    winScreen(); 
  } else if (mode == PAUSE) {
    pauseScreen(); 
  }
}

// ================= MOUSE CONTROLS =================
void mousePressed() {
  if (mode == INTRO) {
    mode = GAME; 
  } 
  else if (mode == GAME) {
   
    if (mouseX > width - 100 && mouseX < width - 20 && 
        mouseY > 50 && mouseY < 90) {
      mode = PAUSE;
    }
  }
  else if (mode == GAMEOVER || mode == WIN) {
    resetGame(); 
    mode = INTRO; 
  }
  else if (mode == PAUSE) {
  
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && 
        mouseY > height/2 + 100 && mouseY < height/2 + 160) {
      mode = GAME;
    }
  }
}

// ================= RESET GAME FUNCTION =================
void resetGame() {
  lives = 3;
  score = 0;
  
  // Reset bunkers
  for (int i = 0; i < 3; i++) {
    bunkerHealth[i] = 5;
    bunkerColors[i] = green;
  }

  // Reset enemies
  int i = 0;
  int row = 0;
  while (row < 6) {
    int col = 0;
    while (col < 8 && i < n) {
      x[i] = 100 + col * (int)(brickw + 20);
      y[i] = 100 + row * (int)(brickh + 20);
      enemyAlive[i] = true;
      i++;
      col++;
    }
    row++;
  }

  // Reset enemy bullets
  int j = 0;
  while (j < MAXPROJECTILES) {
    enemyProjActive[j] = false; 
    j++;
  }
}

// ================= ENEMY MOVEMENT =================
void updateEnemies() {
  // === Check if any enemy hits left or right edge ===
  boolean hitEdge = false;
  int i = 0;
  while (i < n && !hitEdge) {
    if (enemyAlive[i]) { 
      hitEdge = (x[i] <= 0 && enemyDirection == -1) || 
                (x[i] + brickw >= width && enemyDirection == 1);
    }
    i++;
  }

  // === Reverse direction if needed ===
  if (hitEdge) {
    enemyDirection *= -1; 
  }

  // === Move all alive enemies horizontally ===
  int j = 0;
  while (j < n) {
    if (enemyAlive[j]) {
      x[j] += enemySpeed * enemyDirection; // Move left or right
    }
    j++;
  }
}
