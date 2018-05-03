class PatternView implements View {
  Manipul8Model model;
  Box box;
  int index;
  
  int BLOCK_SIZE = 5;
  
  PatternView(Manipul8Model _model, Box _box, int _index) {
    model = _model;
    box = _box;
    index = _index;
    model.register(this);
  }

  void render() {
    int LABEL_WIDTH=100;
    textSize(50);
    Box labelBox = new Box(box.x-box.wt/2+LABEL_WIDTH/2,box.y+10,LABEL_WIDTH,100);
    box.renderWireframe("n= " + (index+1));
    if (model.hasEquation) {
      pushMatrix(); // Padding
      translate(box.x + BLOCK_SIZE, box.y + BLOCK_SIZE); 
      for (int i=0; i < model.coeffTypes.length; i++) {
        pushMatrix();
        if (model.coeffTypes[i] == "QUAD") {  
           renderQuadPattern(model.coeffs[i]);
           translate(n() * BLOCK_SIZE, 0);
        }
        if (model.coeffTypes[i] == "LINEAR") { 
           renderLinearPattern(model.coeffs[i]);
           translate(n() * BLOCK_SIZE, 0);
        }         
        if (model.coeffTypes[i] == "CONSTANT") { 
           renderConstantPattern(model.coeffs[i]);
           translate(BLOCK_SIZE, 0);
        }
      }
      for (int i=0; i < model.coeffTypes.length; i++) popMatrix();
      popMatrix(); // Padding
    }
  }
  
  // Looks up the n value for this pattern view.
  int n() {
    return model.nValues.get(index);
  }
  
  void renderQuadPattern(int coeff) {
    fill(model.getColor("QUAD"));
    stroke(0);
    //strokeWeight(4);
    for (int count = 0; count < coeff; count++) {
      for (int i = 0; i < n(); i++) {
        for (int j = 0; j < n(); j++) {
          rect(i*BLOCK_SIZE, j*BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
        }
      }
      pushMatrix();
      translate(0, n() * BLOCK_SIZE);
    }
    for (int count = 0; count < coeff; count++) { popMatrix(); }
  }
  
  void renderLinearPattern(int coeff) {
    fill(model.getColor("LINEAR"));
    for (int count = 0; count < coeff; count++) {
      for (int i = 0; i < n(); i++) {
          rect(i*BLOCK_SIZE, 0, BLOCK_SIZE, BLOCK_SIZE);
      }
      pushMatrix();
      translate(0, BLOCK_SIZE);
    }
    for (int count = 0; count < coeff; count++) { popMatrix(); }
  }
  
  void renderConstantPattern(int coeff) {
    fill(model.getColor("CONSTANT"));
    for (int count = 0; count < coeff; count++) {
      rect(0, 0, BLOCK_SIZE, BLOCK_SIZE);
      pushMatrix();
      translate(0, BLOCK_SIZE);
    }
    for (int count = 0; count < coeff; count++) { popMatrix(); }
  }
  
  boolean responds_to(Event e) {
    // When we implement going backwards, this should be changed. 
    return false; 
  }
  
  boolean in_box(Event e) {
     return e.has_position && box.contains(e);
  }
  
  void handle(Event e) {
    if (model.debug) { e.log("PatternView"); }
  }
}
