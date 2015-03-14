public class TextLabel
{
  int x,y;
  color textColor;
  String label;
  int labelSize;
  PFont font;
  int rotation;
  int align;
  
  public TextLabel(String label, PFont font, int labelSize, color textColor,int x, int y)
  {
    this.label = label;
    this.labelSize = labelSize;
    this.textColor = textColor;
    this.x = x;
    this.y = y;
    this.font = font;
    this.align = LEFT;
  }
  
  public void draw()
  {
    textFont(font, this.labelSize);
    smooth();
    textAlign(align);
    fill(textColor);
    text(this.label, this.x , this.y);
  }
  
}
