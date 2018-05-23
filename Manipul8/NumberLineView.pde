
class NumberLineView implements View {
  Manipul8Model model;
  Box box;
   
  NumberLineView(Manipul8Model _model, Box _box) {
    model = _model;
    box = _box;
    model.register(this);
    dispatcher.subscribeOut(this);
  } 
  
  void render() {
    box.renderWireframe("Number line view");
    draw_number_line();
  }
  
  void draw_number_line() {
    strokeWeight(NUMBER_LINE_STROKE_WEIGHT);
    stroke(255);
    int[] c = box.center();
    line(c[0] - NUMBER_LINE_LENGTH/2, c[1], c[0] + NUMBER_LINE_LENGTH/2, c[1]);
    int 
  }
  
  boolean responds_to(Event e) {
    return box.contains(e); 
  }
  
  boolean in_box(Event e) {
     return e.has_position && box.contains(e);
  }
  
  void handle(Event e) {   
    log.debug("    NumberLineView received event: " + e.describe());
    if (e.name == "FIDUCIAL ADDED" || e.name == "FIDUCIAL CHANGED") {
      if (model.equationIDs.containsKey(e.id) && !model.hasEquation) { 
        model.handle(e.rename("EQUATION ADDED"));
      }
    }
  }
}
