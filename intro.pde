void introScreen() {
  if (growing) {
    TextSize += 1; 
    if (TextSize > 120) growing = false;
  } else {
    TextSize -= 1;
    if (TextSize < 60) growing = true;
  }
  
  textAlign(CENTER, CENTER);
  textSize(TextSize);
  fill(pink); 
  
  waltograph = createFont("waltograph42.otf", TextSize);
  fill(black);
  textFont(waltograph);
  fill(black);
  text("Space Invaders!", width/2, height/2 - 250);
  
  textSize(50);
  fill(white);
  text("Click anywhere to start", width/2, height/2 + 100);
}
