ArrayList<Blob> clickableThings;

Blob activeDrag;

Blob goal;

PrintWriter file;

int score = 0;
float mult = 1;
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);

int left = 0;
int right = 0;
int middle = 0;

String startTime;
String date;

long gameStartSeconds;

boolean quit = false;

// Create a Randomly Generated Blob to Drag on!
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
    
    Blob b = new Blob(width/50+random(50), s, c);
    switch(c)
    {
      case #FF0000: 
        b.onDrag.bind(this, "rightDrag_action"); 
        b.onDrop.bind(this, "rightDrop_action"); 
        break;
      case #00FF00: 
        b.onDrag.bind(this, "leftDrag_action"); 
        b.onDrop.bind(this, "leftDrop_action"); 
        break;
      case #0000FF: 
        b.onDrag.bind(this, "middleDrag_action"); 
        b.onDrop.bind(this, "middleDrop_action"); 
        break;
    }
    
    return b;
}

public void leftDrag_action(Blob sender)
{
  if(mouseButton == LEFT)
  {
    activeDrag = sender;
  }
}

public void rightDrag_action(Blob sender)
{
  if(mouseButton == RIGHT)
  {
    activeDrag = sender;
  }
}

public void middleDrag_action(Blob sender)
{
  if(mouseButton == CENTER)
  {
    activeDrag = sender;
  }
}

public void rightDrop_action(Blob sender)
{
  if(mouseButton == RIGHT && goal.distanceTo(mouseX, mouseY) < goal.s/2)
  {
    score += sender.getScore() * mult + 5;
    sender.active = false;
    right++;
  }
  else
  {
    score -= 10;
  }
}

// This is what happens when you Drop on a "GREEN" Blob
public void leftDrop_action(Blob sender)
{
  if(mouseButton == LEFT && goal.distanceTo(mouseX, mouseY) < goal.s/2)
  {
    score += sender.getScore() * (mult/2) + 5;
    sender.active = false;
    left++;
  }
  else
  {
    score -= 10;
  }
}

// This is what happens when you Drop on a "BLUE" Blob
public void middleDrop_action(Blob sender)
{
  if(mouseButton == CENTER && goal.distanceTo(mouseX, mouseY) < goal.s/2)
  {
    score += sender.getScore() * (1.5 * mult) + 5;
    sender.active = false;
    middle++;
  }
  else
  {
    score -= 10;
  }
}

// Get the current played time as "HH:MM:SS" format.
String getPlayedTime()
{
  long gameTime = second() + 60 * (minute() + 60 * hour());
  gameTime -= gameStartSeconds;
  
  int seconds = (int)(gameTime % 60);
  gameTime /= 60;
  int minutes = (int)(gameTime % 60);
  gameTime /= 60;
  int hours = (int)gameTime;
  
  return String.format("%d:%d:%d", hours, minutes, seconds);
}

void mousePressed()
{
  if(activeDrag == null)
  {
    for(Blob b : clickableThings)
    {
      b.drag();
      if(activeDrag != null) break;
    }
  }
}

void mouseReleased()
{
  if(activeDrag != null)
  {
    activeDrag.drop();
    activeDrag = null;
  }
}

void setup()
{
  goal = new Blob(width/15, Shape.Circle, color(#FFCC11));
  date = String.format("%d-%d-%d", month(), day(), year());
  startTime = String.format("%d:%d:%d", hour(), minute(), second());
  gameStartSeconds = second() + 60 * (minute() + 60 * hour());
  file = createWriter(String.format("game_%s_%s.json", date, String.format("%d-%d-%d", hour(), minute(), second())));
  fullScreen();
  frameRate(30);
  clickableThings = new ArrayList<Blob>();
  for(int i = 0; i < 5; i++)
  {
    clickableThings.add(generateRandomBlob());
  }
}

void draw()
{
  background(255);
  
  textSize(48);
  fill(red);
  text(String.format("Right Click %d", right), 100, 150);
  fill(green);
  text(String.format("Left Click %d", left), 100, 200);
  fill(blue);
  text(String.format("Middle Click %d", middle), 100, 250);
  fill(0);
  text("Space Bar to quit.", 100, 300);
  
  text(getPlayedTime(), width - 300, 150);
  
  textSize(24);
  text("UP Arrow to increase difficulty", 100, height - 300);
  text("DOWN Arrow to decrease difficulty", 100, height - 265);
  
  if(clickableThings.size() < 25 && frameCount % 30 == 0 && random(5) > 2)
  {
    clickableThings.add(generateRandomBlob());
  }
  
  for(int i = 0; i < clickableThings.size(); i++)
  {
    if(!clickableThings.get(i).isActive()) clickableThings.remove(i);
  }
  
  goal.move();
  goal.drawSprite();
  
  for(Blob b : clickableThings)
  {
    if(b.dragActive) b.moveTo(mouseX, mouseY);
    else b.move();
    b.drawSprite();
  }
  
  fill(0);
  text(score, 100, 100);
  
  if(quit)
  {
    delay(5000);
    exit();
  }
}

void keyPressed()
{
  if(key == ' ')
  {
    file.println(String.format(
      "{\n\t\"score\":%d,\n\t\"left\":%d,\n\t\"right\":%d,\n\t\"middle\":%d,\n\t\"game_time\":\n\t{\n\t\t\"date\":\"%s\",\n\t\t\"start_time\":\"%s\",\n\t\t\"end_time\":\"%s\",\n\t\t\"played_time\":\"%s\"\n\t}\n}", 
      score, left, right, middle, date, startTime, String.format("%d:%d:%d", hour(), minute(), second()), getPlayedTime()));
    file.flush();
    file.close();
    
    textSize(72);
    fill(green);
    text("Your Score has been saved!", width/4, height/2 - 36);
    quit = true;
  }
  else if(keyCode == UP)
  {
    mult += 0.5;
    frameRate(30*mult);
  }
  else if(keyCode == DOWN)
  {
    if(mult > 1)
    {  
      mult -= 0.5;
      frameRate(30*mult);
    }
  }
}
