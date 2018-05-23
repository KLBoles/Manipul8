// Implements a view where there is one equation frame zone at the top 
// and a pattern zone with three cases at the bottom.

class Manipul8View implements View {
  Manipul8Model model;
  Box box;
  FrameView frameView;
  NumberLineView numberLineView;
  PatternView pv1;
  PatternView pv2;
  PatternView pv3;
  
  Manipul8View(Manipul8Model _model, Box _box) {
    model = _model;
    box = _box;
    frameView = new FrameView(model, box.rescale(box.wt, FRAME_HEIGHT));
    numberLineView = new NumberLineView(model, 
        new Box(box.x, box.y + frameView.box.ht, box.wt, NUMBER_LINE_HEIGHT));   
        
    Box pvBox = box.rescale(box.wt/3, box.ht - frameView.box.ht - numberLineView.box.ht);
    pv1 = new PatternView(model, pvBox.offset(0, frameView.box.ht + numberLineView.box.ht),            0);
    pv2 = new PatternView(model, pvBox.offset(box.wt/3, frameView.box.ht + numberLineView.box.ht),     1);
    pv3 = new PatternView(model, pvBox.offset(2 * box.wt/3, frameView.box.ht + numberLineView.box.ht), 2);
    model.register(this);
  }
  
  void render() {
    fill(255, 0, 0);
    box.renderWireframe("");
    frameView.render();
    numberLineView.render();
    pv1.render();
    pv2.render();
    pv3.render();
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
    if (pv1.responds_to(e))            pv1.handle(e);
    if (pv2.responds_to(e))            pv2.handle(e); 
    if (pv3.responds_to(e))            pv3.handle(e); 
  }
}
