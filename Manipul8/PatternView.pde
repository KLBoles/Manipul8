import java.util.Collections;
import java.util.Random;

// Some constants for pattern styles
int CHUNKS_IN_COLUMNS = 1;
int SQUARES_JUMBLED = 2;
int CHUNKS_JUMBLED_HORIZONTAL = 3;
int CHUNKS_JUMBLED_VERTICAL = 4;
int CHUNKS_JUMBLED_DIAG = 5;

// ========================================================
// HELPER: SearchStrategy
// The jumbled layouts place one block at a time. Each time
// they go to place a block, they need a strategy for searching
// through the possible placements. Implementing SearchStrategy
// as a class lets us flexibly swap out the strategy. 

interface SearchStrategy {
  void next(Box box, Box boundingBox); 
}

// Scans along rows
class HorizontalSearch implements SearchStrategy{
  void next(Box box, Box boundingBox) {
    box.x++;
    if (!boundingBox.contains(box)) {
      box.x = 0;
      box.y++;
    } 
    if (!boundingBox.contains(box)) {
      log.error("Could not find a valid chunk placement.");
    }
  }
}

// Scans along columns
class VerticalSearch implements SearchStrategy{
  void next(Box box, Box boundingBox) {
    box.y++;
    if (!boundingBox.contains(box)) {
      box.y = 0;
      box.x++;
    } 
    if (!boundingBox.contains(box)) {
      log.error("Could not find a valid chunk placement.");
    }
  }
}

// Scans diagonally. Whee!
class DiagonalSearch implements SearchStrategy{
  String mode;
  
  void next(Box box, Box boundingBox) {
    while (true) {
      if (box.x == 0 && box.y == 0) mode = "shiftRight";
      if (mode == "shiftRight") {
        box.x = box.y + 1;
        box.y = 0;
        mode = "diagonal";
      }
      else if (mode == "diagonal") {
        box.x -= 1;
        box.y += 1;
        if (box.x == 0) mode = "shiftRight";
      }
      if (!boundingBox.contains(box.rescale(1,1))) {
        log.error("Could not find a valid chunk placement.");
        return;
      }
      if (boundingBox.contains(box)) break;
    }
  }
}
// ==========================================================

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
    if (index >= model.nValues.size()) return; 
    int LABEL_WIDTH=100;
    textSize(PATTERN_TEXT_SIZE);    
    textAlign(CENTER, TOP);
    fill(255);
    text("n= " + nf(n()), box.center()[0], box.y);
    if (DEBUG_VIEWS) box.renderWireframe("PatternView " + nf(index));
    if (model.hasEquation) {
      pushMatrix(); // Padding
      int xPadding = (box.wt - PATTERN_BLOCK_SIZE * PATTERN_MAX_COLUMNS) / 2;
      translate(box.x + xPadding, box.y + PATTERN_BLOCK_SIZE + PATTERN_TEXT_SIZE);
      if (PATTERN_STYLE == CHUNKS_IN_COLUMNS) renderChunksInColumns();
      else if (PATTERN_STYLE == CHUNKS_JUMBLED_HORIZONTAL) renderChunksJumbled(new HorizontalSearch());
      else if (PATTERN_STYLE == CHUNKS_JUMBLED_VERTICAL) renderChunksJumbled(new VerticalSearch());
      else if (PATTERN_STYLE == CHUNKS_JUMBLED_DIAG) renderChunksJumbled(new DiagonalSearch());
      else if (PATTERN_STYLE == SQUARES_JUMBLED) renderSquaresJumbled();
      popMatrix(); // Padding
    }
  }
    
  // Does not respect PATTERN_MAX_COLUMNS
  void renderChunksInColumns() {
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
  
  void renderChunksJumbled(SearchStrategy strategy) {
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
      get_valid_position(newChunkBox, chunkBoxes, strategy);
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
  
  // A helper. Given a box and a list of pre-placed boxes, finds the next valid placement
  // for the box and assigns its position. 
  void get_valid_position(Box newChunkBox, ArrayList<Box> chunkBoxes, SearchStrategy Strategy) {
    Box boundingBox = new Box(0, 0, PATTERN_MAX_COLUMNS, PATTERN_MAX_ROWS);
    while (true) {
      boolean validPosition = true;
      for (Box chunkBox : chunkBoxes) {
        if (chunkBox.intersects(newChunkBox)) {
          validPosition = false;
          break;
        }
      }
      if (validPosition) break;
      Strategy.next(newChunkBox, boundingBox);
    }
  }
  
  void renderSquaresJumbled() {
    strokeWeight(1);
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
      stroke(0);
      rect(i*PATTERN_BLOCK_SIZE, j*PATTERN_BLOCK_SIZE, PATTERN_BLOCK_SIZE, PATTERN_BLOCK_SIZE);
      i++;
    }
  }
  
  // Looks up the n value for this pattern view.
  int n() {
    if (index >= model.nValues.size()) {
      log.warn("Tried to access nValues["+index+"] but there are only " + 
          model.nValues.size() + " values.");
      return -1;
    }
    else {
      return model.nValues.get(index);
    }
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
