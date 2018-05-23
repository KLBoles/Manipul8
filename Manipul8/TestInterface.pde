// ====== TEST INTERFACE =========
// When active, the mouse pointer acts as a fiducial. The 
// 'q', 'l', '0', '1', '2' keys change which fiducial ID is sent. 

Event fakeFiducial;

void setupTesting() {
  showHelp();
  int frameCenter[] = view.frameView.box.center();
  fakeFiducial = new Event("FIDUCIAL ADDED", frameCenter[0], frameCenter[1], radians(0), 119);
  view.handle(fakeFiducial);
  dispatcher.handle(fakeFiducial);
  
  fakeFiducial.name = "FIDUCIAL CHANGED";
  view.handle(fakeFiducial);
  dispatcher.handle(fakeFiducial);
  
  fakeFiducial.id = 102;
  fakeFiducial.x = frameCenter[0] + 50;
  view.handle(fakeFiducial);
  dispatcher.handle(fakeFiducial);
  
  fakeFiducial.id = 105;
  fakeFiducial.x = frameCenter[0] + 90;
  view.handle(fakeFiducial);
  dispatcher.handle(fakeFiducial);
}

void showHelp() {
  log.info("========================================================================");
  log.info("Using testing interface. The mouse pointer will now act as a fiducial.");
  log.info("Use these controls to switch which fiducial is controlled: ");
  log.info("  q: quadratic equation fiducial");
  log.info("  l: linear equation fiducial");
  log.info("  [0,1,2]: coefficient fiducial");
  log.info("  [x,y,z]: number line token fiducial");
  log.info("");
  log.info("  h: show this help message");
  log.info("========================================================================");
  log.info("");
}

void testInterfaceKeyPressedHandler() {
  if (key == 'q') replaceFiducial(119, true);
  if (key == 'l') replaceFiducial(120, true);
  if (key == '0') replaceFiducial(88, false);
  if (key == '1') replaceFiducial(89, false);
  if (key == '2') replaceFiducial(90, false);
  if (key == 'x') replaceFiducial(85, false);
  if (key == 'y') replaceFiducial(86, false);
  if (key == 'z') replaceFiducial(87, false);
  if (key == 'h') showHelp();
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

void testInterfaceMouseMovedHandler() {
  if (USE_TEST_INTERFACE) {
    fakeFiducial.name = "FIDUCIAL CHANGED";
    fakeFiducial.x = mouseX;
    fakeFiducial.y = mouseY;
    view.handle(fakeFiducial);
    dispatcher.handle(fakeFiducial);
  }
}
