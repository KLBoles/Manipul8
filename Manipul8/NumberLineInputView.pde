class NumberLineInputView implements View {
  Manipul8Model model;
  Box box;
  int index, currentFiducialId;
  
  NumberLineInputView(Manipul8Model _model, Box _box, int _index) {
    model = _model;
    box = _box;
    index = _index;
    currentFiducialId = -1;
    model.register(this);
    dispatcher.subscribeOut(this);
  }
  
  void render() {
    if (DEBUG_VIEWS) box.renderWireframe(nf(index));
    if (currentFiducialId != -1) {
      noStroke();
      fill(NUMBER_LINE_TOKEN_COLOR);
      ellipse(box.center()[0], box.center()[1], NUMBER_LINE_TOKEN_SIZE, NUMBER_LINE_TOKEN_SIZE);
    }
  }
  
  boolean responds_to(Event e) {
    return (
      (currentFiducialId == -1 && box.contains(e) && model.numberLineTokenIDs.hasValue(e.id)) ||
      (e.name == "FIDUCIAL OUT" && e.id == currentFiducialId)
    );
  }
  
  boolean in_box(Event e) {
     return e.has_position && box.contains(e);
  }
  
  void handle(Event e) {
    log.debug("        NumberLineInput " + index + " (BOX: " + box.x +", "+ box.y + ", "+box.wt + ", "+box.ht + ") received event: " + e.describe());
    if (currentFiducialId == -1 && box.contains(e) && model.numberLineTokenIDs.hasValue(e.id)) {
       model.add_n(index);
       currentFiducialId = e.id;
    }
    if (e.name == "FIDUCIAL OUT" && e.id == currentFiducialId) {
      model.remove_n(index);
      currentFiducialId = -1;
    }
  }
}
