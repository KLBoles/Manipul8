class Event {
 int x, y, id;
 float angle;
 String name;
 boolean has_position;
 
 Event(String _name) {
  name = _name;
  has_position = false;
 }
 
 Event(int _x, int _y) {
   name = "Unnamed";
   x = _x;
   y = _y;
   has_position = true;
 }
 
 Event(String _name, int _x, int _y, float _angle, int _id) {
    name = _name;
    x = _x;
    y = _y; 
    angle = _angle;
    id = _id;
    has_position = true;
  }
 
 // Returns a copy of the event.
 Event clone() {
   Event newEvent = new Event(name);
   newEvent.x = x;
   newEvent.y = y;
   newEvent.angle = angle;
   newEvent.id = id;
   newEvent.has_position = has_position;
   return newEvent;
 }
 
 Event rename(String _name) {
   Event newEvent = this.clone();
   newEvent.name = _name;
   return newEvent;
 }
 
 // Projects the event's position through a matrix and returns a clone.
 Event project(PMatrix2D matrix) {
   Event newEvent = clone();
   if (has_position) { 
     newEvent.x = int(matrix.multX(x, y));
     newEvent.y = int(matrix.multY(x, y));
   }
   return newEvent;
 }
 
 String describe() {
   return "["+name+"] x:"+nf(x)+" y:"+nf(y)+" angle:"+nf(angle)+" id:"+nf(id);
 }
}
