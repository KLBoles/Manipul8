// A simple mechanism for handling log messages. Configure this
// to be more or less verbose as necessary. For example, 
// 
//     Logger log = new Logger(Logger.INFO);
//     log.info("Logger has been created.");
//     log.warn("False alarm. This message will not be displayed.");

int DEBUG = 1;
int INFO = 2;
int WARN = 3;
int ERROR = 4;

class Logger {
  int level;
  
  Logger(int _level) {
    level = _level;
    info("Initialized logger at level " + (level == INFO ? "INFO" : "DEBUG"));
  }
  void debug(String message) {
    log_message(DEBUG, "DEBUG: " + message);
  }
  void info(String message) {
    log_message(INFO, "INFO:  " + message);
  }
  void warn(String message) {
    log_message(WARN, "WARN:  " + message);
  }
  void error(String message) {
    log_message(ERROR, "ERROR: " + message);
  }
  void log_message(int msgLevel, String message) {
    if (level != 0 && msgLevel >= level) {
      println(message);
    }
  }
}
