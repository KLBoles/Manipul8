
// An equationView has a fiducial and then a certain number of 
// inputs, each occupying INPUT_SIZE squares, spaced out by
// INPUT_SPACING. The box has PADDING around these.

class EquationView implements View {
  int PADDING = 10;
  int INPUT_SIZE = 40;
  int INPUT_SPACING = 50;
  Manipul8Model model;
  Box box;
  int x, y;
  float angle;
  ArrayList<EquationCoeffView> coeffViews;

  EquationView(Manipul8Model _model) {
    model = _model;
    model.register(this);
    dispatcher.subscribeOut(this);
    coeffViews = new ArrayList<EquationCoeffView>();
  } 
  
  void render() {
     pushMatrix();
     translate(x, y);
     rotate(angle);
     box.renderWireframe("");
     for (EquationCoeffView view : coeffViews) { view.render(); }
     popMatrix();
  }
  
  boolean responds_to(Event e) {
    if (e.name == "MODEL CHANGED EQUATION") { return true;}
    if (model.coeffTypes == null) { return false; }
    if (e.name == "FIDUCIAL CHANGED" && model.equationIDs.containsKey(e.id)) { return true;}
    if (!e.has_position) { return false; }
    return box.contains(e.project(getProjection(true)));
  }
  
  boolean in_box(Event e) {
     Event projectedEvent = e.project(getProjection(true));
     return (box != null && box.contains(projectedEvent));
  }
  
  PMatrix2D getProjection() {
    return getProjection(false);
  }
  
  PMatrix2D getProjection(boolean inverted) {
    PMatrix2D matrix = new PMatrix2D();
    matrix.translate(x, y);
    matrix.rotate(angle);
    if (inverted) matrix.invert();
    return matrix;
  }
  
  void handle(Event e) {
    log.debug("      EquationView received event: " + e.describe());
    if (e.name == "MODEL CHANGED EQUATION" && model.hasEquation) { updateView(); }
    if (e.name == "FIDUCIAL CHANGED" && model.equationIDs.containsKey(e.id)) { updatePosition(e); }
    Event projectedEvent = e.project(getProjection(true));
    for (EquationCoeffView coeffView : coeffViews) {
      if (coeffView.responds_to(projectedEvent)) {
        coeffView.handle(projectedEvent);
      }
      else {
        coeffView.handle(e.rename("FIDUCIAL OUT"));
      }
    }
  }
  
  // Whenever the equation changes, we need to update the box.
  void updateView() {
    int wt = model.coeffTypes.length * INPUT_SPACING + INPUT_SIZE + 2 * PADDING;
    int ht = INPUT_SIZE + 2*PADDING;
    box = new Box(-(INPUT_SIZE/2 + PADDING), -(INPUT_SIZE/2 + PADDING), wt, ht);
    
    Box coeffBox = new Box(-INPUT_SIZE/2, -INPUT_SIZE/2, INPUT_SIZE, INPUT_SIZE);
    coeffViews = new ArrayList<EquationCoeffView>();
     for (int i=0; i < model.coeffTypes.length; i++) {
       coeffBox = coeffBox.offset(INPUT_SPACING, 0);
       coeffViews.add(new EquationCoeffView(model, coeffBox, i));
     }
  }
  
  void updatePosition(Event e) {
    x = e.x;
    y = e.y;
    angle = e.angle;
  }
}
