public enum Shape
{
  Circle,
  Triangle,
  Square
}

public class Blob extends Sprite
{
  public Event onClick;
  protected float s;
  protected color c;
  protected Shape shape;
  public boolean active;
  
  public Blob(float size, Shape shape, color col)
  {
    super(random(width), random(height), random(10.0)-5.0, random(10.0)-5.0);
    onClick = new Event(Blob.class);
    this.s = size;
    this.shape = shape;
    this.c = col;
    this.active = true;
  }
  
  public boolean isActive()
  {
    return active;
  }
  
  public void drawSprite()
  {
    if(!active) return;
    
    fill(c);
    switch(shape)
    {
      case Circle:     ellipse(x, y, s*2, s*2); break;
      case Triangle:   triangle(x, y, x+s, y, x+(s/2), y-((sqrt(3)/2)*s)); break;
      case Square:     rect(x, y, s, s); break;
    }
  }
  
  public void click()
  {
    switch(shape)
    {
      case Circle: 
                      if(this.distanceTo(mouseX, mouseY) <= this.s) { onClick.trigger(this); }
                      break;
      case Triangle: 
                      if(mouseY <= y && 
                         mouseY - y >= (-sqrt(3)/2)*(mouseX - x) &&
                         mouseY - y >= (sqrt(3)/2)*(mouseX - x - s)) 
                      { onClick.trigger(this); }
                      break;
      case Square: 
                      if(mouseX >= x && mouseX <= x+s && mouseY >= y && mouseY <= y+s) 
                      { onClick.trigger(this); }
                      break;
      
    }
  }
}
