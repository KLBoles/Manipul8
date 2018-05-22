import java.util.Collections;
import java.util.Random;

// Some constants for pattern styles
int CHUNKS_IN_ROWS = 1;
int CHUNKS_JUMBLED = 2;
int SQUARES_JUMBLED = 3;



class PatternView implements View {
  Manipul8Model model;
  Box box;
  int index;
  
  PatternView(Manipul8Model _model, Box _box, int _index) {
    model = _model;
    box = _box;
    index = _index;
    model.register(this);
  }

  void render() {
    int LABEL_WIDTH=100;
    textSize(PATTERN_TEXT_SIZE);    
    textAlign(CENTER, TOP);
    fill(255);
    text("n= " + nf(n()), box.center()[0], box.y);
    box.renderWireframe("");
    if (model.hasEquation) {
      pushMatrix(); // Padding
      int xPadding = (box.wt - PATTERN_BLOCK_SIZE * PATTERN_MAX_COLUMNS) / 2;
      translate(box.x + xPadding, box.y + PATTERN_BLOCK_SIZE + PATTERN_TEXT_SIZE);
      if (PATTERN_STYLE == CHUNKS_IN_ROWS) renderChunksInRows();
      else if (PATTERN_STYLE == CHUNKS_JUMBLED) renderChunksJumbled();
      else if (PATTERN_STYLE == SQUARES_JUMBLED) renderSquaresJumbled();
      popMatrix(); // Padding
    }
  }
    
  // Does not respect PATTERN_MAX_COLUMNS
  void renderChunksInRows() {
    for (int i=0; i < model.coeffTypes.length; i++) {
      pushMatrix();
      if (model.coeffTypes[i] == "QUAD") {  
         renderQuadPattern(model.coeffs[i]);
         translate(n() * PATTERN_BLOCK_SIZE, 0);
      }
      if (model.coeffTypes[i] == "LINEAR") { 
         renderLinearPattern(model.coeffs[i]);
         translate(n() * PATTERN_BLOCK_SIZE, 0);
      }         
      if (model.coeffTypes[i] == "CONSTANT") { 
         renderConstantPattern(model.coeffs[i]);
         translate(PATTERN_BLOCK_SIZE, 0);
      }
    }
    for (int i=0; i < model.coeffTypes.length; i++) popMatrix();
  }
  
  void renderChunksJumbled() {
    // Make a list of all the chunks we need (chunks are squares, lines, and units)
    ArrayList<String> chunkTypes = new ArrayList<String>();
    for (int i=0; i < model.coeffTypes.length; i++) {
      for (int j=0; j < model.coeffs[i]; j++) chunkTypes.add(model.coeffTypes[i]);
    }
    Collections.shuffle(chunkTypes, new Random(1)); // We want the same shuffle every time.
    log.debug(nf(chunkTypes.size()));
    
    // Find an unoccupied position for each chunk
    ArrayList<Box> chunkBoxes = new ArrayList<Box>();
    for (String chunkType : chunkTypes) {
      Box newChunkBox;
      if (chunkType == "QUAD") newChunkBox = new Box(0, 0, n(), n());
      else if (chunkType == "LINEAR") newChunkBox = new Box(0, 0, n(), 1);
      else newChunkBox = new Box(0, 0, 1, 1);
      log.debug("Placing a " + chunkType);
      while (true) {
        log.debug("  Considering position " + newChunkBox.describe());
        boolean validPosition = true;
        for (Box chunkBox : chunkBoxes) {
          if (chunkBox.intersects(newChunkBox)) {
            log.debug("    NO: intersects" + chunkBox.describe());
            validPosition = false;
            break;
          }
        }
        if (validPosition) break;
        
        newChunkBox.x++;
        if (newChunkBox.x + newChunkBox.wt - 1 >= PATTERN_MAX_COLUMNS) {
          newChunkBox.x = 0;
          newChunkBox.y++;
        } 
        if (newChunkBox.y > 1000) {
          log.error("Could not find a valid chunk placement.");
        }
      }
      chunkBoxes.add(newChunkBox);
      
      // Render the chunk represented by each box
      log.debug("  Placing " + chunkType + " at " + newChunkBox.describe());
      pushMatrix();
      translate(PATTERN_BLOCK_SIZE * newChunkBox.x, PATTERN_BLOCK_SIZE * newChunkBox.y);
      if (chunkType == "QUAD") renderQuadPattern(1);
      if (chunkType == "LINEAR") renderLinearPattern(1);
      if (chunkType == "CONSTANT") renderConstantPattern(1);
      popMatrix();
    }
  }
  
  void renderSquaresJumbled() {
    int blocks = 0;
    ArrayList<String> squareTypes = new ArrayList<String>();
    for (int i=0; i < model.coeffTypes.length; i++) {
      if (model.coeffTypes[i] == "QUAD") blocks = n() * n() * model.coeffs[i];
      else if (model.coeffTypes[i] == "LINEAR") blocks = n() * model.coeffs[i];
      else if (model.coeffTypes[i] == "CONSTANT") blocks = model.coeffs[i];
      for (int j=0; j < blocks; j++) squareTypes.add(model.coeffTypes[i]);
    }
    Collections.shuffle(squareTypes, new Random(1)); // We want the same shuffle every time.
    int i = 0, j = 0; 
    for (String squareType : squareTypes) {
      if (i >= PATTERN_MAX_COLUMNS) {
        i = 0;
        j++;
      } 
      fill(model.getColor(squareType));
      rect(i*PATTERN_BLOCK_SIZE, j*PATTERN_BLOCK_SIZE, PATTERN_BLOCK_SIZE, PATTERN_BLOCK_SIZE);
      i++;
    }
  }
  
  // Looks up the n value for this pattern view.
  int n() {
    return model.nValues.get(index);
  }
  
  void renderQuadPattern(int coeff) {
    fill(model.getColor("QUAD"));
    stroke(0);
    strokeWeight(1);
    for (int count = 0; count < coeff; count++) {
      for (int i = 0; i < n(); i++) {
        for (int j = 0; j < n(); j++) {
          rect(i*PATTERN_BLOCK_SIZE, j*PATTERN_BLOCK_SIZE, PATTERN_BLOCK_SIZE, PATTERN_BLOCK_SIZE);
        }
      }
      pushMatrix();
      translate(0, n() * PATTERN_BLOCK_SIZE);
    }
    for (int count = 0; count < coeff; count++) { popMatrix(); }
  }
  
  void renderLinearPattern(int coeff) {
    fill(model.getColor("LINEAR"));
    stroke(0);
    strokeWeight(1);
    for (int count = 0; count < coeff; count++) {
      for (int i = 0; i < n(); i++) {
          rect(i*PATTERN_BLOCK_SIZE, 0, PATTERN_BLOCK_SIZE, PATTERN_BLOCK_SIZE);
      }
      pushMatrix();
      translate(0, PATTERN_BLOCK_SIZE);
    }
    for (int count = 0; count < coeff; count++) { popMatrix(); }
  }
  
  void renderConstantPattern(int coeff) {
    fill(model.getColor("CONSTANT"));
    stroke(0);
    strokeWeight(1);
    for (int count = 0; count < coeff; count++) {
      rect(0, 0, PATTERN_BLOCK_SIZE, PATTERN_BLOCK_SIZE);
      pushMatrix();
      translate(0, PATTERN_BLOCK_SIZE);
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
    log.debug("PatternView" + e.describe());
  }
}