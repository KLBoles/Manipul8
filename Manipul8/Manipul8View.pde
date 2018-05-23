// Implements a view where there is one equation frame zone at the top 
// and a pattern zone with three cases at the bottom.

class Manipul8View implements View {
  Manipul8Model model;
  Box box;
  FrameView frameView;
  NumberLineView numberLineView;
  ArrayList<PatternView> patternViews;
  PatternView pv1;
  PatternView pv2;
  PatternView pv3;
  
  Manipul8View(Manipul8Model _model, Box _box) {
    model = _model;
    box = _box;
    frameView = new FrameView(model, box.rescale(box.wt, FRAME_HEIGHT));
    numberLineView = new NumberLineView(model, 
        new Box(box.x, box.y + frameView.box.ht, box.wt, NUMBER_LINE_HEIGHT));   
    Box pvBox = box.rescale(box.wt/NUM_PATTERN_VIEWS, 
        box.ht - frameView.box.ht - numberLineView.box.ht);
    patternViews = new ArrayList<PatternView>();
    for (int i=0; i<NUM_PATTERN_VIEWS; i++) {
      int xOffset = i * box.wt/NUM_PATTERN_VIEWS;
      int yOffset = frameView.box.ht + numberLineView.box.ht;
      PatternView pv = new PatternView(model, pvBox.offset(xOffset, yOffset), i);
      patternViews.add(pv);
    }
    model.register(this);
  }
  
  void render() {
    fill(255, 0, 0);
    frameView.render();
    numberLineView.render();
    for (PatternView pv : patternViews) pv.render();
    stroke(NUMBER_LINE_TOKEN_COLOR);
    strokeWeight(NUMBER_LINE_STROKE_WEIGHT);
    for (int i=0; i<model.nValues.size(); i++) {
      int n = model.nValues.get(i);
      int[] tokenCenter = numberLineView.inputViews.get(n).box.center();
      int[] viewCenter = patternViews.get(i).box.center();
      int viewY = patternViews.get(i).box.y;
      line(tokenCenter[0], tokenCenter[1], viewCenter[0], viewY); 
    }
  }
  
  boolean responds_to(Event e) {
    return box.contains(e);
  }
  
  boolean in_box(Event e) {
     return e.has_position && box.contains(e);
  }
  
  void handle(Event e) {
    log.debug("  Manipul8View received event: " + e.describe());
    if (frameView.responds_to(e))      frameView.handle(e);
    if (numberLineView.responds_to(e)) numberLineView.handle(e);
    for (PatternView pv : patternViews) if (pv.responds_to(e)) pv.handle(e);
  }
}
