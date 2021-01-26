import java.io.*;

ArrayList<Blob> clickableThings;

int score = 0;
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);

int left = 0;
int right = 0;
int middle = 0;

void setup()
{
  fullScreen();
  frameRate(30);
  textSize(48);
  clickableThings = new ArrayList<Blob>();
  for(int i = 0; i < 5; i++)
  {
    clickableThings.add(generateRandomBlob());
  }
}

void stop()
{
    PrintWriter file = createWriter("game.json");
    file.println(String.format("{ \"score\":%d, \"left\":%d, \"right\":%d, \"middle\":%d }", score, left, right, middle));
    file.flush();
    file.close();
}

Blob generateRandomBlob()
{
  Shape s;
    switch((int)random(3))
    {
      case 1: s = Shape.Circle; break;
      case 2: s = Shape.Triangle; break;
      default: s = Shape.Square; break;
    }
    
    color c;
    switch((int)random(3))
    {
      case 1: c = red; break;
      case 2: c = green; break;
      default: c = blue; break;
    }
    
    Blob b = new Blob(width/50+random(20), s, c);
    switch(c)
    {
      case #FF0000: b.onClick.bind(this, "rightClick_action"); break;
      case #00FF00: b.onClick.bind(this, "leftClick_action"); break;
      case #0000FF: b.onClick.bind(this, "middleClick_action"); break;
    }
    
    return b;
}

void draw()
{
  background(255);
  
  fill(red);
  text(String.format("Right Click %d", right), 100, 150);
  fill(green);
  text(String.format("Left Click %d", left), 100, 200);
  fill(blue);
  text(String.format("Middle Click %d", middle), 100, 250);
  
  if(clickableThings.size() < 25 && frameCount % 30 == 0 && random(5) > 2)
  {
    clickableThings.add(generateRandomBlob());
  }
  
  for(int i = 0; i < clickableThings.size(); i++)
  {
    if(!clickableThings.get(i).isActive()) clickableThings.remove(i);
  }
  
  for(Blob b : clickableThings)
  {
    b.move();
    b.drawSprite();
  }
  
  fill(0);
  text(score, 100, 100);
}

void mousePressed()
{
  for(Blob b : clickableThings)
  {
    if(b.isActive())
      b.click();
  }
  score -= 5;
}

public void rightClick_action(Blob sender)
{
  if(mouseButton == RIGHT)
  {
    score += 105;
    sender.active = false;
    right++;
  }
  else
  {
    score -= 10;
  }
}

public void leftClick_action(Blob sender)
{
  if(mouseButton == LEFT)
  {
    score += 105;
    sender.active = false;
    left++;
  }
  else
  {
    score -= 10;
  }
}

public void middleClick_action(Blob sender)
{
  if(mouseButton == CENTER)
  {
    score += 105;
    sender.active = false;
    middle++;
  }
  else
  {
    score -= 10;
  }
}