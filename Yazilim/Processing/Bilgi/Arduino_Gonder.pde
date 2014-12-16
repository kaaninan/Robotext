// ## ARDUINO'YA GONDERME ## //


// MOTOR

void uno_motor_kontrol_manual() {

  println("MOTOR:: SOL: "+int(motor_sol)+" SAG: "+int(motor_sag)+"    YON:: SOL: "+int(motor_sol_ters)+" SAG: "+int(motor_sag_ters)+"    ETKIN:: "+int(motor_etkin_sol_on)+","+int(motor_etkin_sol_arka)+","+int(motor_etkin_sag_on)+","+int(motor_etkin_sag_arka)+"     BUZZER:: "+int(buzzer));

  if (int(motor_etkin_sol_on) == 1)
    arduino_uno.analogWrite(a_motor_sol_on, int(motor_sol));
  else
    arduino_uno.analogWrite(a_motor_sol_on, 0);

  if (int(motor_etkin_sol_arka) == 1)
    arduino_uno.analogWrite(a_motor_sol_arka, int(motor_sol));
  else
    arduino_uno.analogWrite(a_motor_sol_arka, 0);



  if (int(motor_etkin_sag_on) == 1)
    arduino_uno.analogWrite(a_motor_sag_on, int(motor_sag));
  else
    arduino_uno.analogWrite(a_motor_sag_on, 0);

  if (int(motor_etkin_sag_arka) == 1)
    arduino_uno.analogWrite(a_motor_sag_arka, int(motor_sag));
  else
    arduino_uno.analogWrite(a_motor_sag_arka, 0);



  if (int(motor_sol_ters) == 1) {
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.HIGH);
    arduino_uno.digitalWrite(a_motor_sol_arka_d, Arduino.LOW);
  } else {
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.LOW);
    arduino_uno.digitalWrite(a_motor_sol_arka_d, Arduino.HIGH);
  }


  if (int(motor_sag_ters) == 1) {
    arduino_uno.digitalWrite(a_motor_sag_on_d, Arduino.HIGH);
    arduino_uno.digitalWrite(a_motor_sag_arka_d, Arduino.LOW);
  } else {
    arduino_uno.digitalWrite(a_motor_sag_on_d, Arduino.LOW);
    arduino_uno.digitalWrite(a_motor_sag_arka_d, Arduino.HIGH);
  }


  // LED

  if (int(motor_etkin_sol_on) == 0 && int(motor_etkin_sol_arka) == 0 && int(motor_etkin_sag_on) == 0 && int(motor_etkin_sag_arka) == 0) {

    arduino_uno.digitalWrite(a_led_k_1, Arduino.LOW);
    arduino_uno.digitalWrite(a_led_k_2, Arduino.LOW);
    arduino_uno.digitalWrite(a_led_y_1, Arduino.LOW);
    arduino_uno.digitalWrite(a_led_y_2, Arduino.LOW);
  } else {

    if (int(motor_sag) == 0 && int(motor_sol) == 0) {
      arduino_uno.digitalWrite(a_led_k_1, Arduino.HIGH);
      arduino_uno.digitalWrite(a_led_k_2, Arduino.HIGH);
      arduino_uno.digitalWrite(a_led_y_1, Arduino.LOW);
      arduino_uno.digitalWrite(a_led_y_2, Arduino.LOW);
    } else {
      arduino_uno.digitalWrite(a_led_k_1, Arduino.LOW);
      arduino_uno.digitalWrite(a_led_k_2, Arduino.LOW);
      arduino_uno.digitalWrite(a_led_y_1, Arduino.HIGH);
      arduino_uno.digitalWrite(a_led_y_2, Arduino.HIGH);
    }
  }
}
