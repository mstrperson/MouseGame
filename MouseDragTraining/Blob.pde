public enum Shape
{
  Circle,
  Triangle,
  Square
}

public class Blob extends Sprite
{
  public Event onDrag;
  public Event onDrop;
  protected float s;
  protected color c;
  protected Shape shape;
  public boolean active;
  public boolean dragActive;
  
  public Blob(float size, Shape shape, color col)
  {
    super(random(width), random(height), random(10.0)-5.0, random(10.0)-5.0);
    onDrag = new Event(Blob.class);
    onDrop = new Event(Blob.class);
    this.s = size;
    this.shape = shape;
    this.c = col;
    this.active = true;
    this.dragActive = false;
  }
  
  // score is dependent on both speed and size.
  // smaller target and faster speed = more points!
  public float getScore()
  {
    float spd = sqrt(dx * dx + dy * dy);
    return 50*(1 + s/width) + 50 * (1 + spd/5); 
  }
  
  public boolean isActive()
  {
    return active;
  }
  
  public void drawSprite()
  {
    if(!active) return;
    
    if(dragActive)
    {
      strokeWeight(5);
      stroke(#FFFF00);
    }
    else
    {
      stroke(0);
      strokeWeight(1);
    }
    
    fill(c);
    switch(shape)
    {
      case Circle:     ellipse(x, y, s, s); break;
      case Triangle:   triangle(x, y, x+s, y, x+(s/2), y-((sqrt(3)/2)*s)); break;
      case Square:     rect(x, y, s, s); break;
    }
  }
  
  public void drag()
  {
    switch(shape)
    {
      case Circle: 
                      if(this.distanceTo(mouseX, mouseY) <= this.s/2) 
                      { 
                        this.dragActive = true;
                        onDrag.trigger(this); 
                      }
                      break;
      case Triangle: 
                      if(mouseY <= y && 
                         mouseY - y >= (-sqrt(3)/2)*(mouseX - x) &&
                         mouseY - y >= (sqrt(3)/2)*(mouseX - x - s)) 
                      { 
                        this.dragActive = true;
                        onDrag.trigger(this); 
                      }
                      break;
      case Square: 
                      if(mouseX >= x && mouseX <= x+s && mouseY >= y && mouseY <= y+s) 
                      { 
                        this.dragActive = true;
                        onDrag.trigger(this); 
                      }
                      break;
      
    }
  }
  
  public void drop()
  {
    if(dragActive)
    {
      dragActive = false;
      onDrop.trigger(this);
    }
  }
}
