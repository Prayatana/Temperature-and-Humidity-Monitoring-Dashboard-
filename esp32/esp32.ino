#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <WiFiClient.h>
#include "time.h"
#include <WiFiUdp.h>
#include <NTPClient.h>
#include <DHT.h>
#include <DHT_U.h>

#define DHT_PIN 21
#define DHTTYPE DHT11
DHT_Unified dht(DHT_PIN, DHTTYPE);

const char *ntpServer = "asia.pool.ntp.org";
const long gmtOffset_sec = 20700;

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, ntpServer, gmtOffset_sec);

// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "rangestudio"
#define WIFI_PASSWORD "rangestudio"

// Insert Firebase project API Key
#define API_KEY "AIzaSyCuYIBlLl4ELtpoY4xexBJsO7VstIQel3s"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://iot-project-aa3a6-default-rtdb.firebaseio.com"

// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;

FirebaseConfig config;


unsigned long sendDataPrevMillis = 0;
bool signupOK = false;


void setup()
{
  Serial.begin(115200);
  pinMode(DHT_PIN, INPUT);
  delay(1000);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }

  timeClient.begin();
  timeClient.setUpdateInterval(500);

  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", ""))
  {
    Serial.println("ok");
    signupOK = true;
  }
  else
  {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  dht.begin();
}

void loop()
{
  FirebaseAuth auth;
  timeClient.update();
  unsigned long currentTime = timeClient.getEpochTime();

  sensors_event_t event;
  dht.temperature().getEvent(&event);
  float temperature = event.temperature;
  dht.humidity().getEvent(&event);
  float humidity = event.relative_humidity;

  if(!isnan(temperature) && !isnan(humidity)){
    Serial.print("Temperature: ");
    Serial.println(temperature);
    Serial.print("Humidity: ");
    Serial.println(humidity);
  }

  

  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    // Write an Int number on the database path test/int
    Firebase.RTDB.pushFloat(&fbdo, "test/temperature", temperature);
    Firebase.RTDB.pushFloat(&fbdo, "test/humidity", humidity);
  }
}