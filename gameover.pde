void gameOverScreen() {
  fill(red);
  textSize(100);
  text("GAME OVER", width/2, height/2 - 100);
  
  textSize(50);
  fill(white);
  text("Score: " + score, width/2, height/2 + 50);
  
  textSize(30);
  text("Click anywhere to return to menu", width/2, height/2 + 180);
}

void winScreen() {
  fill(green);
  textSize(100);
  text("YOU WIN!", width/2, height/2 - 100);
  
  textSize(50);
  fill(white);
  text("Score: " + score, width/2, height/2 + 50);
  
  textSize(30);
  text("Click anywhere to return to menu", width/2, height/2 + 180);
}
