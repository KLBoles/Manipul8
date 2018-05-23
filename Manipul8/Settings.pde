
// Semantic versioning will help us keep track of which version
// has problems. Major releases get increased when there are 
// breaking changes--the app starts working in a fundamentally new
// way. Minor releases are for new functionality. Patches are for
// incremental development. 
String VERSION = "0.2.1";

// Sets how much information to print to the screen.
// Options are DEBUG, INFO, WARN, ERROR.
int LOG_LEVEL = INFO;

// Causes all views to render their wireframes to show their current positions.
boolean DEBUG_VIEWS = false;

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

// Vertical space for number line view
int NUMBER_LINE_HEIGHT = 100;
int NUMBER_LINE_MAX_VALUE = 8;
int NUMBER_LINE_STROKE_WEIGHT = 4;
int NUMBER_LINE_LENGTH = 800;
int NUMBER_LINE_TICK_HEIGHT = 20;
int NUMBER_LINE_INPUT_SIZE = 40;
int NUMBER_LINE_TOKEN_SIZE = 40;
color NUMBER_LINE_TOKEN_COLOR = color(200, 0, 200);

// Amount of padding around the equation inputs
int EQUATION_PADDING = 10;

// Size of the squares sensitive to equation input fiducials
int EQUATION_INPUT_SIZE = 40;

// Offset from one equation input fiducial to the next
int EQUATION_INPUT_SPACING = 50;

int NUM_PATTERN_VIEWS = 3;

// Style for laying out blocks. Options:
// CHUNKS_IN_COLUMNS, CHUNKS_JUMBLED, SQUARES_JUMBLED
int PATTERN_STYLE = CHUNKS_JUMBLED;

// Block size in patterns
int PATTERN_BLOCK_SIZE = 20;

// Text size in patterns
int PATTERN_TEXT_SIZE = 40;

// The maximum number of columns of blocks
int PATTERN_MAX_COLUMNS = 12;

// Amount by which to to adjust fiducial orientations (in radians)
float ANGLE_OFFSET = 0;

// Colors for various types of squares in patterns
boolean SHOW_COLORS = true;
color STANDARD_COLOR = color(255,226,0);
color QUAD_COLOR = color(255,87,78);
color LINEAR_COLOR = color(125,209,69);
color CONSTANT_COLOR = color(74,201,239);

int BOX_WIREFRAME_TEXT_SIZE = 10;
