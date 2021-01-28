/* Sprite is an abstract class representing something that will move around the screen
 * a Sprite must know it's current position (x, y) and it's velocity vector <dx, dy>
 * by default a Sprite starts with <0, 0> velocity.
 * included in the Sprite class are a few standard methods that are useful--see comments
 */
ScreenMode SCREEN_MODE = ScreenMode.Loop; 
 
abstract class Sprite
{
  // this Sprite's current location.
  protected float x, y;
  
  // this Sprite's current velocity vector.
  protected float dx, dy;
  
  // initialize a Sprite at a given coordinate.
  Sprite(float x, float y)
  {
    this.x = x;
    this.y = y;
    
    this.dx = 0;
    this.dy = 0;
  }
  
  // initalize a Sprite at a given coordinate with a given velocity.
  Sprite(float x, float y, float dx, float dy)
  {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
  }
  
  // check to see if this Sprite is sitting on a particular color.
  boolean collidesWith(color c)
  {
    return get((int)x,(int)y)==c;
  }
  
  // make this Sprite move at the speed := |<dx, dy>| 
  // directly toward another Sprite
  void chase(Sprite other)
  {
    float speed = sqrt(dx*dx + dy*dy);
    float delX = other.x - this.x;
    float delY = other.y - this.y;
    
    if(SCREEN_MODE == ScreenMode.Loop)
    {
      if(delX < -(width / 2))  delX += width;
      if(delX > (width / 2))   delX -= width;
      
      if(delY < -(height / 2)) delY += height;
      if(delY > (height / 2))  delY -= height;
    }
    
    float mag = sqrt(delX*delX + delY*delY);
    
    if(delX != 0) x += (delX / mag) * speed;
    if(delY != 0) y += (delY / mag) * speed;
    
    boundaryCheck();
  }
  
  // make this Sprite move at the speed := |<dx, dy>| 
  // directly toward another Sprite while mafloataing
  // a minimum follow distance
  void chase(Sprite other, float minFollowDistance)
  {
    float speed = sqrt(dx*dx + dy*dy);
    
    float delX = other.x - this.x;
    float delY = other.y - this.y;
    
    if(SCREEN_MODE == ScreenMode.Loop)
    {
      if(delX < -(width / 2))  delX += width;
      if(delX > (width / 2))   delX -= width;
      
      if(delY < -(height / 2)) delY += height;
      if(delY > (height / 2))  delY -= height;
    }
    
    float mag = sqrt(delX*delX + delY*delY);
    
    if(mag > 0 && mag <= minFollowDistance) 
    {
      if(delY < delX)
      {
        x -= (delY / mag) * speed * 0.5;
        y += (delX / mag) * speed * 0.5;
      }
      else
      {
        x += (delY / mag) * speed * 0.5;
        y -= (delX / mag) * speed * 0.5;
      }
      return;
    }
    
    if(delX != 0) x += (delX / mag) * speed;
    if(delY != 0) y += (delY / mag) * speed;
    
    boundaryCheck();
  }
  
  // make this Sprite move at the speed := |<dx, dy>|
  // directly toward your mouse pofloater!
  void followMouse()
  {
    float speed = sqrt(dx*dx + dy*dy);
    float delX = mouseX - this.x;
    float delY = mouseY - this.y;
    float mag = sqrt(delX*delX + delY*delY);
    
    if(delX != 0) x += (delX / mag) * speed;
    if(delY != 0) y += (delY / mag) * speed;
  }
  
  // set the velocity of this sprite to a particular value.
  void setVelocity(float dx, float dy)
  {
    this.dx = dx;
    this.dy = dy;
  }
  
  // Move this sprite instantly to another location
  // This DOES NOT check to make sure that you are on the screen
  void moveTo(float x, float y)
  {
    this.x = x;
    this.y = y;
    
  }
  
  // move this sprite according to it's current velocity vector
  // bounces off the walls
  void move()
  {
    x += dx;
    y += dy;
    
    // make sure we don't go out of bounds
    boundaryCheck();
  }
  
  // get the distance between centers of this Sprite and another
  float distanceTo(Sprite other)
  {
    float delX = other.x - this.x;
    float delY = other.y - this.y;
    return sqrt(delX*delX + delY*delY);
  }
  
  float distanceTo(float x, float y)
  {
    float delX = x - this.x;
    float delY = y - this.y;
    return sqrt(delX*delX + delY*delY);
  }
  
  // Control this sprite using the Arrow Keys
  void keyboardControl()
  {
    // If I hit the LEFT arrow, go Left
    if(keyCode == LEFT)
    {
      dx = -5;
      dy = 0;
    }
    // if I hit the RIGHT arrow, go Right
    else if(keyCode == RIGHT)
    {
      dx = 5;
      dy = 0;
    }
    // if I hit the UP arrow, go Up
    if(keyCode == UP)
    {
      dy = -5;
      dx = 0;
    }
    // if I hit the DOWN arrow, go Down
    else if(keyCode == DOWN)
    {
      dy = 5;
      dx = 0;
    }
    // if I hit the Space Bar, Stop
    if(keyCode == ' ')
    {
      dx = 0;
      dy = 0;
    }
    
    // move x and y in the appropriate way
    x = x + dx;
    y = y + dy;
    
    // make sure we don't go out of bounds (uncomment only one of these lines!)
    boundaryCheck();
  }
  
  private void boundaryCheck()
  {
    // make sure we don't go out of bounds (uncomment only one of these lines!)
    switch(SCREEN_MODE)
    {
      case Loop:   boundaryLoop(); break;
      case Bounce: boundaryBounce(); break;
      case Stop:   boundaryStop(); break;
      default:     break;
    }
  }
  
  private void boundaryLoop()
  {
    if(x < 0) x += width;
    if(x > width) x -= width;
    if(y < 0) y += height;
    if(y > height) y -= height;
  }
  
  private void boundaryBounce()
  {
    if(x < 0 || x > width) dx = -dx;    
    if(y < 0 || y > height) dy = -dy;
  }
  
  private void boundaryStop()
  {
    if(x < 0 || x > width) dx = 0;    
    if(y < 0 || y > height) dy = 0;
  }
  
  // a Sprite itself is abstract and does not actually know
  // what it looks like.  This method must be overriden in 
  // any classes which /are/ Sprites.
  abstract void drawSprite();
}

// Easy way to set the behavior at the screen boundary.
public enum ScreenMode
{
   Loop,
   Bounce,
   Stop
}
