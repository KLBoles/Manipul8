
class NumberLineView implements View {
  ArrayList<NumberLineInputView> inputViews;
  Manipul8Model model;
  Box box;
   
  NumberLineView(Manipul8Model _model, Box _box) {
    model = _model;
    box = _box;
    inputViews = new ArrayList<NumberLineInputView>();
    
    int[] c = box.center();
    int nlStartX = c[0] - NUMBER_LINE_LENGTH/2;
    float tickInterval = NUMBER_LINE_LENGTH / NUMBER_LINE_MAX_VALUE;
    for (int i=0; i<=NUMBER_LINE_MAX_VALUE; i++) {
      int tickX = nlStartX + int(i*tickInterval);
      Box tickBox = new Box(tickX - NUMBER_LINE_INPUT_SIZE/2, c[1] - NUMBER_LINE_INPUT_SIZE/2, 
          NUMBER_LINE_INPUT_SIZE, NUMBER_LINE_INPUT_SIZE);
      inputViews.add(new NumberLineInputView(model, tickBox, i));
    }
    model.register(this);
    dispatcher.subscribeOut(this);
  } 
  
  void render() {
    if (DEBUG_VIEWS) box.renderWireframe("Number line view");
    strokeWeight(NUMBER_LINE_STROKE_WEIGHT);
    stroke(255);
    int[] c = box.center();
    int nlStartX = c[0] - NUMBER_LINE_LENGTH/2;
    line(nlStartX, c[1], nlStartX + NUMBER_LINE_LENGTH, c[1]);
    float tickInterval = NUMBER_LINE_LENGTH / NUMBER_LINE_MAX_VALUE;
    for (int i=0; i<=NUMBER_LINE_MAX_VALUE; i++) {
      int tickX = nlStartX + int(i*tickInterval);
      line(tickX, c[1] - NUMBER_LINE_TICK_HEIGHT, tickX, c[1] + NUMBER_LINE_TICK_HEIGHT);
    }
    for (NumberLineInputView inputView : inputViews) {
      inputView.render();
    } 
    
  }
  
  boolean responds_to(Event e) {
    return box.contains(e); 
  }
  
  boolean in_box(Event e) {
     return e.has_position && box.contains(e);
  }
  
  void handle(Event e) {   
    log.debug("    NumberLineView received event: " + e.describe());
    for (NumberLineInputView inputView : inputViews) {
      if (inputView.responds_to(e)) inputView.handle(e);
    }
  }
}
