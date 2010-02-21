// some code by ladyada from adafruit
// http://urlfold.com/lym

#define DEBOUNCE 10

#define A 0
#define B 1

#define APIN 14
#define BPIN 15

byte buttons[] = { APIN, BPIN};

#define NUMBUTTONS sizeof(buttons)

byte pressed[NUMBUTTONS], justpressed[NUMBUTTONS], justreleased[NUMBUTTONS];

void setup() {
  Serial.begin(9600);
  
  Serial.print('r', BYTE); // send RESET command

  // enable pull-up resistors on switch pins
  for (byte i = 0; i< NUMBUTTONS; i++) {
    pinMode(buttons[i], INPUT);
    digitalWrite(buttons[i], HIGH);
  }
}

void check_buttons() {
  static byte previousstate[NUMBUTTONS];
  static byte currentstate[NUMBUTTONS];
  static long lasttime;
  byte index;

  if (millis() < lasttime) {
    // we wrapped around, lets just try again
    lasttime = millis();
  }

  if ((lasttime + DEBOUNCE) > millis()) {
    // not enough time has passed to debounce
    return;
  }
  // ok we have waited DEBOUNCE milliseconds, lets reset the timer
  lasttime = millis();

  for (index = 0; index < NUMBUTTONS; index++) {
    justpressed[index] = 0;
    justreleased[index] = 0;

    currentstate[index] = digitalRead(buttons[index]);

    if (currentstate[index] == previousstate[index]) {
      if ((pressed[index] == LOW) && (currentstate[index] == LOW)) {
        // just pressed
        justpressed[index] = 1;
      } else if ((pressed[index] == HIGH) && (currentstate[index] == HIGH)) {
        // just released
        justreleased[index] = 1;
      }
      
      pressed[index] = !currentstate[index];
    }
    
    previousstate[index] = currentstate[index];
  }
}

void loop() {
  check_buttons();

  if (justpressed[A]) {
    Serial.print('a', BYTE);
    delay(500);
  }
  if (justpressed[B]) {
    Serial.print('b', BYTE);
    delay(500);
  }
}

