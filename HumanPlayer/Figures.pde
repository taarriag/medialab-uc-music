//Classes
class Color
{
  public int red;
  public int green;
  public int blue;
  public int opacity;
  
  public Color(int red, int green, int blue, int opacity)
  {
    this.red = red;
    this.green = green;
    this.blue = blue;
    this.opacity = opacity;
  }
  
  public boolean equalsColor(Color color2)
  {
    if(this.red == color2.red && this.green == color2.green && this.blue == color2.blue && this.opacity == color2.opacity)
      return true;
      
    return false;
  }
}

abstract class Figure
{
  public int xpos;
  public int ypos;
  public Color innerColor;
  public Color outerColor;
  
  public Figure(int xpos, int ypos)
  {
    this.xpos = xpos;
    this.ypos = ypos;
    this.outerColor = new Color(0,0,0,255);
    this.innerColor = new Color(255,255,255,255);
  }
  abstract void draw();
}

class Circle extends Figure
{
  public int radious;
  
  public Circle(int xpos,int ypos, int radious)
  {
    super(xpos,ypos);
    this.radious = radious;
  }
  
  public void draw()
  {
      fill(innerColor.red,innerColor.green,innerColor.blue,innerColor.opacity);
      stroke(outerColor.red,outerColor.green,outerColor.blue,outerColor.opacity);
      smooth();
      ellipse(xpos,ypos,radious*2,radious*2);
  }
}

class Rectangle extends Figure
{
  public int width;
  public int height;
  
  public Rectangle(int xpos,int ypos, int width,int height)
  {
    super(xpos,ypos);
    this.width = width;
    this.height = height;
  } 
  
  public void draw()
  {
      fill(innerColor.red,innerColor.green,innerColor.blue,innerColor.opacity);
      stroke(outerColor.red,outerColor.green,outerColor.blue,outerColor.opacity);
      smooth();
      rect(xpos,ypos,width,height);
  }
}

class Triangle extends Figure
{
  public int x1,y1,x2,y2,x3,y3;
  
  public Triangle(int x1,int y1,int x2,int y2,int x3,int y3)
  {
    super(x1,y1);
    
    this.x1 = x1;
    this.x2 = x2;
    this.x3 = x3;
    
    this.y1 = y1;
    this.y2 = y2;
    this.y3 = y3;
  } 
  
  public void draw()
  {
      fill(innerColor.red,innerColor.green,innerColor.blue,innerColor.opacity);
      stroke(outerColor.red,outerColor.green,outerColor.blue,outerColor.opacity);
      smooth();
      triangle(x1,y1,x2,y2,x3,y3);
  }
  
  public float getArea()
  {
    int a = x1 - x3;
    int b = y1 - y3;
    int c = x2 - x3;
    int d = y2 - y3;
    return 0.5*abs((a*d) - (b*c));
  }
  
  //Chequea si un punto esta exactamente dentro del triangulo
  public boolean isInside(int x,int y)
  {
    //Usamos la tecnica de definir 3 triangulos a partir del punto a
    //chequear y los vertices de este triangulo
    Triangle t1 = new Triangle(x,y,x1,y1,x2,y2);
    Triangle t2 = new Triangle(x,y,x2,y2,x3,y3);
    Triangle t3 = new Triangle(x,y,x1,y1,x3,y3);
    
     if(t1.getArea() + t2.getArea() + t3.getArea() > this.getArea())
        return false;
     
     return true;
    
  }
}
