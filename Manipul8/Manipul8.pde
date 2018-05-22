import java.util.Map; //<>//
import TUIO.*;

Logger log;
TuioProcessing tuioClient;
Dispatcher dispatcher;
Manipul8Model model;
Manipul8View view;
Calibration calibration;

void setup() {
  // This is the only setting that can't live in Settings, due to a 
  // Processing requirement. Keep this in sync with 
  // the values of VIEW_* in Settings. 
  size(1000, 600);
  
  noLoop();
  log = new Logger(LOG_LEVEL);
  dispatcher = new Dispatcher();
  model = new Manipul8Model();
  Box viewBox = new Box(VIEW_X, VIEW_Y, VIEW_WIDTH, VIEW_HEIGHT);
  view = new Manipul8View(model, viewBox);
  calibration = new Calibration();
  tuioClient  = new TuioProcessing(this);
  if (USE_TEST_INTERFACE) { setupTesting(); } 
}

void draw() {
  background(0);
  view.render();
  if(!calibration.calibrated) calibration.draw();
}

// ====== TUIO INTERFACE =========

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (!USE_TEST_INTERFACE) {
    //Event e = new Event("FIDUCIAL ADDED", scaleX(tobj.getX()), scaleY(tobj.getY()), tobj.getAngle() + ANGLE_OFFSET, tobj.getSymbolID());
    Event e = new Event("FIDUCIAL ADDED", tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle() + ANGLE_OFFSET, tobj.getSymbolID());

    log.info(e.describe());
    view.handle(e);
    dispatcher.handle(e);
    redraw();
  }
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (!USE_TEST_INTERFACE) {
    //Event e = new Event("FIDUCIAL CHANGED", scaleX(tobj.getX()), scaleY(tobj.getY()), tobj.getAngle()+ANGLE_OFFSET, tobj.getSymbolID());
    Event e = new Event("FIDUCIAL CHANGED", tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle()+ANGLE_OFFSET, tobj.getSymbolID());
    log.info(e.describe());
    view.handle(e);
    dispatcher.handle(e);
    redraw();
  }
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (!USE_TEST_INTERFACE) {
    //Event e = new Event("FIDUCIAL REMOVED", scaleX(tobj.getX()), scaleY(tobj.getY()), tobj.getAngle()+ANGLE_OFFSET, tobj.getSymbolID());
    Event e = new Event("FIDUCIAL REMOVED", tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle()+ANGLE_OFFSET, tobj.getSymbolID());
    log.info(e.describe());
    view.handle(e);
    dispatcher.handle(e);
    redraw();
  }
}

// ====== UNUSED TUIO EVENTS =========
// These are defines so TUIO doesn't complain that they're missing. 
void refresh(TuioTime bundleTime) {}
void addTuioCursor(TuioCursor tcur) {}
void removeTuioCursor(TuioCursor tcur) {}
void updateTuioCursor(TuioCursor tcur) {}
void addTuioBlob(TuioBlob tblb) {}
void removeTuioBlob(TuioBlob tblb) {}
void updateTuioBlob(TuioBlob tblb) {}

// ====== Mouse events =========
void keyPressed() {
  calibrationKeyPressedHandler();
  if (USE_TEST_INTERFACE) testInterfaceKeyPressedHandler();
  if (key == 'k') model.showColors = !model.showColors;
  redraw();
}

void mouseMoved() {
  if (USE_TEST_INTERFACE) {
    testInterfaceMouseMovedHandler();
    redraw();
  }
}
