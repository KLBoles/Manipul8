
class FrameView implements View {
  Manipul8Model model;
  Box box;
  EquationView equationView;
   
  FrameView(Manipul8Model _model, Box _box) {
    model = _model;
    box = _box;
    equationView = new EquationView(model);
    model.register(this);
    dispatcher.subscribeOut(this);
  } 
  
  void render() {
    if (model.hasEquation) { equationView.render();}
  }
  
  boolean responds_to(Event e) {
    return box.contains(e); 
  }
  
  boolean in_box(Event e) {
     return e.has_position && box.contains(e);
  }
  
  void handle(Event e) {   
    log.debug("    FrameView received event: " + e.describe());
    if (e.name == "FIDUCIAL ADDED" || e.name == "FIDUCIAL CHANGED") {
      if (model.equationIDs.containsKey(e.id) && !model.hasEquation) { 
        model.handle(e.rename("EQUATION ADDED"));
      }
    }
    if ((e.name == "FIDUCIAL REMOVED" || e.name == "FIDUCIAL OUT")) {
      if (model.hasEquation && model.equationIDs.containsKey(e.id)) { 
        model.handle(e.rename("EQUATION REMOVED"));
      }
    }
    if (equationView.responds_to(e)) {
       equationView.handle(e);
    }
  }
}
