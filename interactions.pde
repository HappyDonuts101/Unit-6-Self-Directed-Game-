void keyPressed() {
   if (key == ' ' && mode == GAME && !laserActive) {
    laserX = paddleX + paddleWidth/2 - laserWidth/2;
    laserY = paddleY;
    laserActive = true;
  }

  // Keep your existing key controls
  if (key == 'w' || key == 'W') wkey = true;
  if (key == 'a' || key == 'A') akey = true;
  if (key == 's' || key == 'S') skey = true;
  if (key == 'd' || key == 'D') dkey = true;
  if (keyCode == UP) upkey = true;
  if (keyCode == LEFT) leftkey = true;
  if (keyCode == DOWN) downkey = true;
  if (keyCode == RIGHT) rightkey = true;
  
  // Pause with P key
  if ((key == 'p' || key == 'P') && mode == GAME) {
    mode = PAUSE;
  } else if ((key == 'p' || key == 'P') && mode == PAUSE) {
    mode = GAME;
  }
}
