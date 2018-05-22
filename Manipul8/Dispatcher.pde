// Watches for events and alerts subscribers. 
// This is needed because views otherwise can't know when a fiducial has left
// their box. 

class Dispatcher {
  ArrayList<View> outSubscribers;
  
  Dispatcher() {
    outSubscribers = new ArrayList<View>(); 
  }
  
  void subscribeOut(View v) { outSubscribers.add(v); }
  void unsubscribeOut(View v) { outSubscribers.remove(v); }
  
  boolean responds_to(Event e) {
    return e.has_position; 
  }
  
  void handle(Event e) {
    Event eOut = e.clone();
    eOut.name = "FIDUCIAL OUT";
    for (View v : outSubscribers) { 
      if (!v.in_box(e)) v.handle(eOut);
    }
  }
}
