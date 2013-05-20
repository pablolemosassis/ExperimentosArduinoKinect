void setup()
{
  Serial.begin(57600);
}

void loop()
{
  Serial.print('H');
  delay(1000);
  Serial.print('L');
  delay(1000);
}
