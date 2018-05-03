import java.util.Map; //<>// //<>// //<>//
import TUIO.*;

TuioProcessing tuioClient;
Dispatcher dispatcher = new Dispatcher();
Manipul8Model model = new Manipul8Model();

// Manipul8View view = new Manipul8View(model, new Box(10, 10, 4000, 3000));
Manipul8View view = new Manipul8View(model, new Box(10, 10, 600, 400));

//Calibration calibration;

float ANGLE_OFFSET = PI;

int scaleX(float x) {
   return int(-330+3700 * x);
}
int scaleY(float y) {
  return int(-500+3300 * y);
}

void setup() {
  //size(4000, 3000);
  size(620, 420);
//calibration = new Calibration();
  //size(3500, 2000);
  tuioClient  = new TuioProcessing(this);
  setupTesting();
}

void draw() {
  //if(!calibration.calibrated) calibration.draw();
  background(0);
  view.render();
}

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  Event e = new Event("FIDUCIAL ADDED", scaleX(tobj.getX()), scaleY(tobj.getY()), tobj.getAngle() + ANGLE_OFFSET, tobj.getSymbolID());
  view.handle(e);
  dispatcher.handle(e);
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  Event e = new Event("FIDUCIAL CHANGED", scaleX(tobj.getX()), scaleY(tobj.getY()), tobj.getAngle()+ANGLE_OFFSET, tobj.getSymbolID());
  view.handle(e);
  dispatcher.handle(e);
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  Event e = new Event("FIDUCIAL REMOVED", scaleX(tobj.getX()), scaleY(tobj.getY()), tobj.getAngle()+ANGLE_OFFSET, tobj.getSymbolID());
  view.handle(e);
  dispatcher.handle(e);
}


// ====== TESTING =========

Event fakeFiducial;

void setupTesting() {
  int frameCenter[] = view.frameView.box.center();
  fakeFiducial = new Event("FIDUCIAL ADDED", frameCenter[0], frameCenter[1], radians(45), 119);
  view.handle(fakeFiducial);
  dispatcher.handle(fakeFiducial);
  
  fakeFiducial.name = "FIDUCIAL CHANGED";
  view.handle(fakeFiducial);
  dispatcher.handle(fakeFiducial);
}

void keyPressed() {
  if (key == 'q') replaceFiducial(119, true);
  if (key == 'l') replaceFiducial(120, true);
  if (key == '0') replaceFiducial(88, false);
  if (key == '1') replaceFiducial(89, false);
  if (key == '2') replaceFiducial(90, false);
}

void replaceFiducial(int id, boolean remove) {
  if (remove) {
    fakeFiducial.name = "FIDUCIAL REMOVED";
    view.handle(fakeFiducial);
    dispatcher.handle(fakeFiducial);
  }
  fakeFiducial.name = "FIDUCIAL ADDED";
  fakeFiducial.id = id;
  view.handle(fakeFiducial);
  dispatcher.handle(fakeFiducial);
}

void mouseMoved() {
  fakeFiducial.name = "FIDUCIAL CHANGED";
  fakeFiducial.x = mouseX;
  fakeFiducial.y = mouseY;
  view.handle(fakeFiducial);
  dispatcher.handle(fakeFiducial);
}
