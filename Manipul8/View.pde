// Defines the View interface. 
// An interface describes properties required by every class which 
// implements that interface. This lets us work with different kinds
// of things using a common language. Every view in this app implements 
// the View interface.

interface View {
  void render();
  boolean responds_to(Event e);
  boolean in_box(Event e);
  void handle(Event e);
}