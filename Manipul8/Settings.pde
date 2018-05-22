

// Sets how much information to print to the screen.
// Options are DEBUG, INFO, WARN, ERROR.
int LOG_LEVEL = DEBUG;

// Sets how the app can be controlled. When true, 
// allows control with the mouse and keyboard; 
// otherwise allows control via TUIO events. 
boolean USE_TEST_INTERFACE = false;

// Sets the position and size of the overall view. 
int VIEW_X = 10;
int VIEW_Y = 10;
int VIEW_WIDTH = 980;
int VIEW_HEIGHT = 580;

// The 'frame' is the space where the equations can be placed. 
int FRAME_HEIGHT = 100;

// Style for laying out blocks. Options:
// CHUNKS_IN_ROWS, CHUNKS_JUMBLED, SQUARES_JUMBLED
int PATTERN_STYLE = CHUNKS_JUMBLED;

// Block size in patterns
int PATTERN_BLOCK_SIZE = 20;

// Text size in patterns
int PATTERN_TEXT_SIZE = 40;

// The maximum number of columns of blocks
int PATTERN_MAX_COLUMNS = 12;

// Sets an amount by which to to adjust fiducial 
// orientations (in radians)
float ANGLE_OFFSET = 0;

// Sets colors for squares in patterns
boolean SHOW_COLORS = true;
color STANDARD_COLOR = color(255,226,0);
color QUAD_COLOR = color(255,87,78);
color LINEAR_COLOR = color(125,209,69);
color CONSTANT_COLOR = color(74,201,239);

// Sets N values. Later, this can be changed to 
// set by fiducial. 
int N1 = 1;
int N2 = 2; 
int N3 = 4;
