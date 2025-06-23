void pauseScreen() {
  fill(0, 0, 150);
  rect(0, 0, width, height);
  
  fill(white);
  textSize(100);
  text("PAUSED", width/2, height/2);
  
  // Continue button
  fill(green);
  rect(width/2 - 100, height/2 + 100, 200, 60);
  fill(black);
  textSize(30);
  text("Continue", width/2, height/2 + 130);
}
