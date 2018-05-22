// The model keeps track of state.

class Manipul8Model {
  HashMap<Integer, Integer> coeffIDs;
  HashMap<Integer, String[]> equationIDs;
  int[] coeffs;
  String[] coeffTypes;
  ArrayList<View> views;
  IntList nValues;
  IntDict colors;
  boolean hasEquation = false;
  boolean showColors;
  color standardColor;
  
  Manipul8Model() {
    views = new ArrayList<View>();
    configure();
  }
 
  void handle(Event e) {
    if (e.name == "EQUATION ADDED" && !hasEquation) { addEquation(e); }
    if (e.name == "EQUATION REMOVED" && hasEquation) { removeEquation(e);}
  }
  
  void register(View v) {
    views.add(v);
  }
  
  void broadcast(Event e) {
    ArrayList<View> viewsCopy = new ArrayList<View>();
    for (View v : views) { viewsCopy.add(v); }
    for (View v : viewsCopy) {
      if (v.responds_to(e)) { v.handle(e);} 
    }
  }
  
  void addEquation(Event e) {
    coeffTypes = equationIDs.get(e.id);
    coeffs = new int[coeffTypes.length];
    hasEquation = true;
    broadcast(new Event("MODEL CHANGED EQUATION"));
  }
  
  void removeEquation(Event e) {
    coeffTypes = null;
    coeffs = null;
    hasEquation = false;
    broadcast(new Event("MODEL CHANGED EQUATION"));
  }
  
  color getColor(String type){
    if (showColors){
      return colors.get(type);
    }
    else {
      return standardColor;
    }
  }
  
  // Sets values that affect the program's behavior. 
  void configure() {
    equationIDs = new HashMap<Integer, String[]>();
    equationIDs.put(119, new String[] {"QUAD", "LINEAR", "CONSTANT"});
    equationIDs.put(120, new String[] {"LINEAR", "CONSTANT"});
    equationIDs.put(121, new String[] {"QUAD", "LINEAR"});
    equationIDs.put(122, new String[] {"QUAD", "CONSTANT"});
    equationIDs.put(123, new String[] {"CONSTANT"});
    equationIDs.put(124, new String[] {"LINEAR"});
    equationIDs.put(125, new String[] {"QUAD"});
    
    coeffIDs = new HashMap<Integer, Integer>();
    coeffIDs.put(88,0);
    coeffIDs.put(89,1);
    coeffIDs.put(90,2);
    coeffIDs.put(91,3);
    coeffIDs.put(92,4);
    coeffIDs.put(93,0);
    coeffIDs.put(94,1);
    coeffIDs.put(95,2);
    coeffIDs.put(96,3);
    coeffIDs.put(97,4);
    coeffIDs.put(98,0);
    coeffIDs.put(99,1);
    coeffIDs.put(100,2);
    coeffIDs.put(101,3);
    coeffIDs.put(102,4);
    coeffIDs.put(103,5);
    coeffIDs.put(104,6);
    coeffIDs.put(105,7);
    coeffIDs.put(106,8);
    coeffIDs.put(107,9);
    
    nValues = new IntList();
    nValues.append(N1);
    nValues.append(N2);
    nValues.append(N3);
    
    showColors= SHOW_COLORS;
    standardColor= STANDARD_COLOR;
    colors = new IntDict();
    colors.set("QUAD", QUAD_COLOR);
    colors.set("LINEAR", LINEAR_COLOR);
    colors.set("CONSTANT", CONSTANT_COLOR); 
  }
}
