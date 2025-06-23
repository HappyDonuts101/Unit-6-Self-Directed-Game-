void gameScreen() {
    // Set background color
    background(darkblue);

    // SCORE AND LIVES DISPLAY
    fill(0, 100); 
    noStroke();
    rect(20, 20, 200, 60); 
    rect(width-220, 20, 200, 60);
    fill(255); // White text
    textSize(32);
    textAlign(LEFT, TOP);
    text("Score: " + score, 30, 30); 
    textAlign(RIGHT, TOP);
    text("Lives: " + lives, width-30, 30); 
    textAlign(CENTER); 
    
    // Update game elements
    updateLaser(); // Handle laser movement and collisions
    updateEnemies(); // Handle enemy movement
    updateEnemyProjectiles(); // Handle enemy bullets

    // DRAW BUNKERS
    int bunkerCounter = 0;
    while (bunkerCounter < 3) {
        if (bunkerHealth[bunkerCounter] > 0) {
  
            fill(bunkerColors[bunkerCounter]);
            rect(bunkerX[bunkerCounter], bunkerY, bunkerWidth, bunkerHeight);
            
            // Draw triangular top of bunker
            triangle(bunkerX[bunkerCounter], bunkerY, 
                    bunkerX[bunkerCounter]+10, bunkerY-10, 
                    bunkerX[bunkerCounter]+bunkerWidth, bunkerY);
            
            // Draw damage notches
            fill(darkblue);
            triangle(bunkerX[bunkerCounter]+20, bunkerY, 
                    bunkerX[bunkerCounter]+30, bunkerY-10, 
                    bunkerX[bunkerCounter]+40, bunkerY);
            triangle(bunkerX[bunkerCounter]+60, bunkerY, 
                    bunkerX[bunkerCounter]+70, bunkerY-10, 
                    bunkerX[bunkerCounter]+80, bunkerY);
        }
        bunkerCounter++;
    }

    // DRAW ENEMIES
    int enemyIndex = 0;
    while (enemyIndex < n) {
        if (enemyAlive[enemyIndex]) {
            // Set color based on row (y-position)
            if (y[enemyIndex] == 100) fill(pink);      
            else if (y[enemyIndex] == 170) fill(purple); 
            else if (y[enemyIndex] == 240) fill(red);    
            else if (y[enemyIndex] == 310) fill(orange); 
            else if (y[enemyIndex] == 380) fill(green);  
            
            rect(x[enemyIndex], y[enemyIndex], brickw, brickh);
        }
        enemyIndex++;
    }

    // PADDLE CONTROLS
    if (keyPressed) {  
        if (keyCode == LEFT) {
            paddleX -= paddleSpeed; // Move left
        }
        if (keyCode == RIGHT) {
            paddleX += paddleSpeed; // Move right
        }
    }
    
    paddleX = constrain(paddleX, 0, width - paddleWidth);
    
   //PAddle button
    fill(lightblue);
    noStroke();
    rect(paddleX, paddleY, paddleWidth, paddleHeight);
    
    // PAUSE BUTTON
    fill(orange);
    rect(width - 100, 50, 80, 40); 
    fill(black);
    textSize(20);
    text("Pause", width - 60, 70); 
}

void updateLaser() {
    if (!laserActive) return;


    fill(#FFFF00);
    rect(laserX, laserY, laserWidth, laserHeight);

   
    laserY -= laserSpeed;

    
    if (laserY + laserHeight < 0) {
        laserActive = false;
        return;
    }

   
   int i = 0;
boolean hitDetected = false;

while (i < n && !hitDetected) {
    if (enemyAlive[i]) {
        // Check if laser overlaps with enemy
        boolean hitLeft = laserX < x[i] + brickw;
        boolean hitRight = laserX + laserWidth > x[i];
        boolean hitTop = laserY < y[i] + brickh;
        boolean hitBottom = laserY + laserHeight > y[i];
        
        if (hitLeft && hitRight && hitTop && hitBottom) {
  
            enemyAlive[i] = false;
            score += 100;
            laserActive = false;
            hitDetected = true;
            
        
            if (score >= 4000) {
                mode = WIN;
            }
        }
    }
    i++;
}
}

void updateEnemyProjectiles() {

    // ======== BULLET SPAWNING SECTION ========

    if (millis() - lastShotTime > shotDelay) {// Checks if enough time has passed since the last shot
        lastShotTime = millis(); 

        // Random number 
        int bulletsToFire = (int)random(1, 5);
        int bulletsFired = 0;
        int i = 0;

   
        while (i < MAXPROJECTILES && bulletsFired < bulletsToFire) {
            if (!enemyProjActive[i] && random(1) > 0.3) { 
                int randomEnemy = (int)random(n); 

               
                if (enemyAlive[randomEnemy]) {
                   
                    enemyProjX[i] = x[randomEnemy] + brickw / 2;
                    enemyProjY[i] = y[randomEnemy] + brickh;
                    enemyProjActive[i] = true; 
                    bulletsFired++;
                }
            }
            i++;
        }
    }

    // ======== BULLET SECTION ========

    int i = 0;
    while (i < MAXPROJECTILES) {
        if (enemyProjActive[i]) {
            fill(255, 0, 0);
            rect(enemyProjX[i] - enemyProjWidth / 2, enemyProjY[i], enemyProjWidth, enemyProjHeight);

            
            enemyProjY[i] += enemyProjSpeed;

            //  collision with bunkers ===
            boolean hitBunker = false;
            int b = 0;
            while (b < 3 && !hitBunker) {
                if (bunkerHealth[b] > 0 &&
                    enemyProjY[i] + enemyProjHeight > bunkerY &&
                    enemyProjX[i] > bunkerX[b] && 
                    enemyProjX[i] < bunkerX[b] + bunkerWidth) { 

                    bunkerHealth[b]--; 
                    bunkerColors[b] = lerpColor(red, green, bunkerHealth[b] / 5.0);
                    hitBunker = true; 
                }
                b++;
            }

            if (hitBunker) {
                enemyProjActive[i] = false; 
            } 
            else {
                // ===  collision with the paddle ===
                boolean hitPaddle = 
                    (enemyProjY[i] + enemyProjHeight >= paddleY) && // Bullet hits top of paddle
                    (enemyProjY[i] <= paddleY + paddleHeight) && // Bullet hits bottom of paddle
                    (enemyProjX[i] + enemyProjWidth / 2 >= paddleX) && // Bullet right edge is beyond paddle left
                    (enemyProjX[i] - enemyProjWidth / 2 <= paddleX + paddleWidth); // Bullet left edge is before paddle right

                if (hitPaddle) {
                    lives--; 
                    enemyProjActive[i] = false;

             
                    if (lives <= 0) {
                        mode = GAMEOVER;
                    }
                }

            
                if (enemyProjY[i] > height) {
                    enemyProjActive[i] = false; 
                }
            }
        }
        i++;
    }
}
