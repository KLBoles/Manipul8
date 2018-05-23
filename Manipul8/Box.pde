class Box {
  int TEXT_PADDING = 3;
  int x, y, wt, ht;
  
  Box(int _x, int _y, int _wt, int _ht) {
    x = _x;
    y = _y; 
    wt = _wt;
    ht = _ht; 
  }
  
  // Returns true or false depending on whether the event is within the box.
  boolean contains(Event e) {
    return e.has_position && x <= e.x && e.x < (x + wt) && y <= e.y && e.y < (y + ht); 
  }
  
  boolean intersects(Box b) {
    boolean xOverlap = !((max(x, x + wt) <= min(b.x, b.x + b.wt)) || (max(b.x, b.x + b.wt) <= min(x, x + wt)));
    boolean yOverlap = !((max(y, y + ht) <= min(b.y, b.y + b.ht)) || (max(b.y, b.y + b.ht) <= min(y, x + ht)));
    return xOverlap && yOverlap;
  }
  
  // Returns a new box, offset by x and y values.
  Box offset(int _x, int _y) {
    return new Box(x + _x, y + _y, wt, ht);
  }
  
  // Returns a new box, offset by ht and wt values. 
  Box rescale(int _wt, int _ht) {
    return new Box(x, y, _wt, _ht); 
  }
  
  // Draws a labeled rectangle in this box's position, useful for debugging.
  void renderWireframe(String label) {
    noFill();
    stroke(255);
    strokeWeight(1);
    drawRect();
    fill(255);
    textSize(BOX_WIREFRAME_TEXT_SIZE);
    textAlign(LEFT);
    addText(label);
  }
  
  // Draws a rectangle 
  void drawRect() {
    rect(x, y, wt, ht);
  }
  
  // Adds text within this box, wrapping if necessary. 
  void addText(String message) {
    text(message, x + TEXT_PADDING, y + TEXT_PADDING, wt - 2*TEXT_PADDING, ht - 2*TEXT_PADDING);
  }
  
  String describe() {
    return "(" + x + ", " + y + ", " + wt + ", " + ht + ")"; 
  }
  
  int[] center() {
    int cent[] = {x + wt/2, y + ht/2};
    return cent;
  }
}
