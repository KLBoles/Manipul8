class EquationCoeffView implements View {
  Manipul8Model model;
  Box box;
  int coeffIndex;
  
  EquationCoeffView(Manipul8Model _model, Box _box, int _coeffIndex) {
    model = _model;
    box = _box;
    coeffIndex = _coeffIndex;
    model.register(this);
  }
  
  void render() {
    if (model.hasEquation) {
      String coeffType = model.coeffTypes[coeffIndex];
      if (model.coeffs[coeffIndex] > 0) {
        fill(model.getColor(coeffType));
      }
      else {
        noFill(); 
      }
      box.drawRect();
    }
  }
  
  boolean responds_to(Event e) {
    return box.contains(e);
  }
  
  boolean in_box(Event e) {
     return e.has_position && box.contains(e);
  }
  
  void handle(Event e) {
    if (model.debug) { e.log("EquationCoeffView" + coeffIndex + "(BOX: " + box.x +", "+ box.y + ", "+box.wt + ", "+box.ht + ")"); }
    if (e.name == "FIDUCIAL CHANGED" || e.name == "FIDUCIAL ADDED") {
      if (model.coeffIDs.containsKey(e.id)) model.coeffs[coeffIndex] = model.coeffIDs.get(e.id);
    }
    if (e.name == "FIDUCIAL REMOVED" || e.name == "FIDUCIAL OUT") {
      if (model.coeffIDs.containsKey(e.id) && model.hasEquation) model.coeffs[coeffIndex] = 0; 
    }
  }
}
