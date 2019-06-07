
#include <Servo.h>
#define SERVO1_PIN 9            //*head控制引脚
#define SERVO2_PIN 7            //*body控制引脚
#define BODY_MAX 175
#define BODY_MIN 5
Servo head, body;               //创建伺服电机对象

int headInit = 90;             //*头部舵机的初始位置
int headTop = 50;               //*头部活动最高处, SMALLER THE NUMBER,UPPER THE HEAD
int headLow = 100;              //*头部活动最低处
//int bodyRight = 60;            //*躯干活动最右
//int bodyLeft = 120;             //*躯干活动最左
int bodyRight=10;
int bodyLeft=120;
int bodyInit = (bodyRight+bodyLeft)/2;              //*躯干舵机的初始位置
int bodyspeed=2;
int headspeed=1;
int bodycheck=1;
int headcheck=1;
float nodMod = 1;             //*点头向量，越大越快
int nodScope = 30;              //*点头倍数，决定点头范围和速度
float shakeMod =1;           //*摇头向量，越大越快(the degree per 20 ms)
int shakeScope = 30;            //*摇头倍数，决定摇头范围和速度(the range is shakeScope*shakeMod)
int meetround=0;
int meetspeed=6;
float meetMod=meetspeed;
boolean detect=false;

//float headPos, bodyPos;
//float swayMod = shakeMod;
int headPos, bodyPos;
int swayMod = shakeMod;
int delayMode = 10;             //循环速度
int nodCount=0, shakeCount=0;
String headMode="pause", bodyMode="pause";
int outputPin=2; //it is the trigpin
int inputPin=3; //it is the echopin
int timer=0;
void action(char val) {
  if (val == 'A') {//右转
    bodyMode = "turnright";
  } else if (val == 'B') {//左转
    bodyMode = "turnleft";
  } else if (val == 'C') {//抬头
    headMode = "up";
  } else if (val == 'D') {//低头
    headMode = "down";
  } else if (val == 'E') {//头部回到初始
    headMode = "back";
  } else if (val == 'F') {//身体回到初始
    bodyMode = "back";
  } else if (val == 'G') {//点头
    nodCount = 0;
    headMode = "nod";
  } else if (val == 'H') {//向右侧摇头
    shakeCount = 0;
    bodyMode = "rightshake";
  } else if (val == 'h') {//向左侧摇头
    shakeCount = 0;
    bodyMode = "leftshake";
  } else if (val == 'I') {//左右摇晃
    swayMod = shakeMod;
    bodyMode = "sway";
  } else if (val == 'P') {//暂停
    headMode = "pause";
    bodyMode = "pause";
  } else if (val == 'j'){
    headMode="pause";
  } else if(val=='k'){
    bodyMode="pause";
  }else if(val=='m'){
    bodyMode="meet";
  }else if(val=='o'){
    detect=true;
  }else if(val=='f'){
    detect=false;
  }
 }

void headUpdate() {
  headPos=head.read();
  if (headMode == "up") {
    if (headPos > headTop) {
      headPos -=headspeed;
    }else if(headPos<headTop){
      headPos+=headspeed;
    }
    head.write(headPos);
    if(abs(headPos-headTop)<=headcheck){
      headMode = "pause";
    }
  }
  else if (headMode == "down") {
    if (headPos < headLow) {
      headPos +=headspeed;
    }else if(headPos>headLow){
      headPos-=headspeed;
    }
    head.write(headPos);
    if(abs(headPos-headTop)<=headcheck){
      headMode = "pause";
    }
  }
  else if (headMode == "back") {
    if (headPos < headInit) {
      headPos ++;
    }
    else if (headPos > headInit) {
      headPos --;
    }
    head.write(headPos);
  }
  else if (headMode == "nod") {
    if (nodCount < nodScope) {
      headPos += nodMod;
      nodCount++;
    } else if (nodScope <= nodCount && nodCount < nodScope * 2) {
      headPos -= nodMod;
      nodCount++;
    } else if (nodCount = nodScope * 2) {
      nodCount = 0 ;
    }
    head.write(headPos);
  }
 /* Serial.println(headPos);
  Serial.println(headMode);*/
}

void bodyUpdate() {
  bodyPos=body.read();
  if (bodyMode == "turnright") {
    if (bodyPos > bodyRight) {
      bodyPos -=bodyspeed;
    }
    else if(bodyPos<bodyRight){
      bodyPos +=bodyspeed;
    }
    body.write(bodyPos);
    
      if(abs(bodyPos-bodyRight)<=bodycheck){
      bodyMode = "pause";
    }
  }
  else if (bodyMode == "turnleft") {
    if (bodyPos < bodyLeft) {
      bodyPos +=bodyspeed;
    }
   else if(bodyPos>bodyLeft){
      bodyPos -=bodyspeed;
    }
    body.write(bodyPos);
    
     if(abs(bodyPos-bodyLeft)<=bodycheck){
      bodyMode = "pause";
    }
    
  }
  else if (bodyMode == "back") {
    if (bodyPos < bodyInit) {
      bodyPos +=bodyspeed;
    }
    else if (bodyPos > bodyInit) {
      bodyPos -=bodyspeed;
    }
    body.write(bodyPos);
    
    if(abs(bodyPos-bodyInit)<=bodycheck){
      bodyMode = "pause";
    }
    
  }
  else if (bodyMode == "leftshake") {
    if (shakeCount < shakeScope) {
      bodyPos += shakeMod;
      shakeCount++;
    } else if (shakeScope <= shakeCount && shakeCount < shakeScope * 2) {
      bodyPos -= shakeMod;
      shakeCount++;
    } else if (shakeCount = shakeScope * 2) {
      shakeCount = 0 ;
    }
    body.write(bodyPos);
  }
  else if (bodyMode == "rightshake") {
    if (shakeCount < shakeScope) {
      bodyPos -= shakeMod;
      shakeCount++;
    } else if (shakeScope <= shakeCount && shakeCount < shakeScope * 2) {
      bodyPos += shakeMod;
      shakeCount++;
    } else if (shakeCount = shakeScope * 2) {
      shakeCount = 0 ;
    }
    body.write(bodyPos);
  }
  else if (bodyMode == "sway") {
    if (bodyPos < bodyRight) {
      swayMod = -swayMod;
    } else if (bodyPos > bodyLeft) {
      swayMod = -swayMod;
    }
    bodyPos += swayMod;
    body.write(bodyPos);
  }
  else if(bodyMode=="meet"){
     timer++;
    if(meetMod<0&&(bodyPos<(bodyRight+20*meetround)||bodyPos<BODY_MIN)){
      if(timer>3){
      meetMod=meetspeed-meetround;
      timer=0;
      meetround++;
      Serial.println(meetround);
      }
    }
    else if(meetMod>0&&(bodyPos>(bodyLeft-20*meetround)||bodyPos>BODY_MAX)){
      if(timer>3){
      meetMod=-(meetspeed-meetround);
      timer=0;
      }
    }
    bodyPos+=meetMod;
    body.write(bodyPos);
     if(meetround>2){
      timer=0;
      meetround=0;
      bodyMode="back";
    }
  }
 /* Serial.println(bodyPos);
  Serial.println(bodyMode);*/
}

void renew() {
  headUpdate();
  bodyUpdate();
  delay(delayMode);
}

void setup() {
  Serial.begin(9600);
  delay(1000);
  pinMode(inputPin,INPUT);
  pinMode(outputPin,OUTPUT);
  head.attach(SERVO1_PIN);
  head.write(headInit);
  body.attach(SERVO2_PIN);
  body.write(bodyInit);
  headPos = headInit;
  bodyPos = bodyInit;
}

void checkdis(){
 /* if(!detect){
    Serial.write(0);
    return;
  }*/
  digitalWrite(outputPin,LOW);
  delayMicroseconds(2);
  digitalWrite(outputPin,HIGH);
  delayMicroseconds(10);
  digitalWrite(outputPin,LOW);
  float distance=pulseIn(inputPin,HIGH);
  distance=distance/58;
  int d=(int)distance;
  timer++;
 if(timer>30){
 // Serial.println(d);
  Serial.write(d);
  timer=0;
  }
}

void loop() {
  if (Serial.available()) {
    char val = Serial.read();
    action(val);
  }
  renew();
  checkdis();
  delay(10);
}

