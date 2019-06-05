
import processing.serial.*;
import ddf.minim.*;
import processing.video.*;
PImage background;
message mymessage;

Serial port;
robot_screen myscreen;

int screenWidth = 1920;//your PC screenWidth
int screenHeight = 1080;//your PC screenHeight
int videoWidth = 1280;//your LCD screenWidth
int videoHeight = 720;//your LCD screenWidth

int unitx;
int unity;
int counter=0;
ArrayList<Button> buttons;
ArrayList<PlanButton> planbuttons;
TaskRunner tr;
position mypos;
video_manager myvideo;
audio_manager myaudio;
boolean success;
//ArrayList<ball> balls;

void setup() {
  fullScreen(SPAN);
  background(200);
  frameRate(60);
  //balls=new ArrayList<ball>();
  unity = screenHeight / 10;  //the 1/10 of screen height
  unitx = screenWidth / 10;   //the 1/10 of screen width
  mypos=new position();
  myscreen=new robot_screen();
  myvideo=new video_manager(this);
  myaudio=new audio_manager(this);
  mymessage=new message();
  success = false;
  try_connection();
 // success=true;
  if(success) {
    init();
  } else {
    print("Error: No Connection.");
    exit();
  }
  
}

void draw() { 
  background(200);
 // mirror();
  for(int i = 0; i < buttons.size(); i++) {
    Button b = buttons.get(i);
    b.render();
  }
  for(int i = 0; i < planbuttons.size(); i++) {
    PlanButton b = planbuttons.get(i);
    b.render();
  }
  tr.update();
  myscreen.render();
  mymessage.show_text();
}

void mouseClicked() {
  for(int i = 0; i < buttons.size(); i++) {
    Button b = buttons.get(i);
    if(b.mouseIn()) {
      tr.run(b.title);
      return;
    }
  }
  for(int i = 0; i < planbuttons.size(); i++) {
    PlanButton b = planbuttons.get(i);
    if(b.mouseIn()) {
      tr.run(b.title);
      return;
    }
  }
}

void init() {
  //video display
  fill(0);
  myscreen.draworigin();
  rectMode(CENTER);
 // background=loadImage("background.jpg");
 // image(background,0,0,screenWidth,screenWidth/1.6);
  //video mirror
  textAlign(CENTER);
  fill(#3E3A39);
//  rect(unitx * 2.986,unity * 2.867,videoWidth * 0.375,videoHeight * 0.375);
  rect(unitx * 3,unity * 4.5,videoWidth * 0.8,videoHeight * 0.8);
  textSize(20);
  fill(#E2E2E1);
  text("Video Mirror",unitx * 3,unity * 4.5);
  
  buttons = new ArrayList<Button>();
  buttons.add(new Button(unitx*7.90, unity*3.22,"NORMAL"));
  buttons.add(new Button(unitx*8.40, unity*3.22,"PLAY"));
  buttons.add(new Button(unitx * 8.94, unity * 3.22, "reset"));
  buttons.add(new Button(unitx * 9.44, unity * 3.22, "pause"));
  
  buttons.add(new Button(unitx * 6.91, unity * 4.30, "turnright"));
  buttons.add(new Button(unitx * 7.42, unity * 4.30, "turnleft"));
  buttons.add(new Button(unitx * 7.92, unity * 4.30, "up"));
  buttons.add(new Button(unitx * 8.43, unity * 4.30, "down"));
  buttons.add(new Button(unitx * 8.94, unity * 4.30, "headback"));
  buttons.add(new Button(unitx * 9.44, unity * 4.30, "bodyback"));
  
  buttons.add(new Button(unitx * 6.91, unity * 5.13, "nod"));
  buttons.add(new Button(unitx * 7.42, unity * 5.13, "rightshake"));
  buttons.add(new Button(unitx * 7.92, unity * 5.13, "leftshake"));
  buttons.add(new Button(unitx * 8.43, unity * 5.13, "sway"));
  buttons.add(new Button(unitx * 8.94, unity * 5.13, "meet"));
 
  buttons.add(new Button(unitx * 6.91, unity * 6.78, "v1"));
  buttons.add(new Button(unitx * 7.42, unity * 6.78, "v2"));
  buttons.add(new Button(unitx * 7.92, unity * 6.78, "v3"));
  buttons.add(new Button(unitx * 8.43, unity * 6.78, "v4"));
  buttons.add(new Button(unitx * 8.94, unity * 6.78, "v5"));
  buttons.add(new Button(unitx * 9.44, unity * 6.78, "v6"));
  
  buttons.add(new Button(unitx * 6.91, unity * 7.76, "v7"));
  buttons.add(new Button(unitx * 7.42, unity * 7.76, "v8"));
  buttons.add(new Button(unitx * 7.92, unity * 7.76, "v9"));
  buttons.add(new Button(unitx * 8.43, unity * 7.76, "v10"));
  buttons.add(new Button(unitx * 8.94, unity * 7.76, "v11"));
  buttons.add(new Button(unitx * 9.44, unity * 7.76, "v12"));
  
  buttons.add(new Button(unitx * 6.91, unity * 8.74, "a1"));
  buttons.add(new Button(unitx * 7.42, unity * 8.74, "a2"));
  buttons.add(new Button(unitx * 7.92, unity * 8.74, "a3"));
  buttons.add(new Button(unitx * 8.43, unity * 8.74, "a4"));
  buttons.add(new Button(unitx * 8.94, unity * 8.74, "a5"));
  buttons.add(new Button(unitx * 9.44, unity * 8.74, "a6"));
  
  buttons.add(new Button(unitx * 6.91, unity * 9.72, "a7"));
  buttons.add(new Button(unitx * 7.42, unity * 9.72, "a8"));
  buttons.add(new Button(unitx * 7.92, unity * 9.72, "a9"));
  buttons.add(new Button(unitx * 8.43, unity * 9.72, "a10"));
  
  planbuttons = new ArrayList<PlanButton>();
  planbuttons.add(new PlanButton(unitx * 1.18, unity * 8.58, "group 1"));
  planbuttons.add(new PlanButton(unitx * 2.08, unity * 8.58, "group 2"));
  planbuttons.add(new PlanButton(unitx * 2.99, unity * 8.58, "group 3"));
  planbuttons.add(new PlanButton(unitx * 3.89, unity * 8.58, "group 4"));
  planbuttons.add(new PlanButton(unitx * 4.79, unity * 8.58, "group 5"));

  tr = new TaskRunner();
}

void try_connection() {
  try {
    String portName = Serial.list()[0];//your port number
    port = new Serial(this, portName, 9600);
    success = true;
  } catch(Exception e) {}
  
  delay(1000);
}

class Button {
  float x, y, w, h;
  String title;
  float t = 0;
  
  Button(float _x, float _y, String _title) {
    x = _x;
    y = _y;
    w = 60;
    h = 60;
    title = _title;
  }
  
  void render() {
    if(mouseIn()) {
      t +=0.4 * (1 - t);
    } else {
      t *=0.6;
    }
    
    stroke(#F7F8F8);
    fill(map(t, 0, 1, 23, 247), map(t, 0, 1, 85, 248), map(t, 0, 1, 166, 248));
    rect(x, y, w, h);
    textSize(12);
    fill(map(t, 0, 1, 247, 23), map(t, 0, 1, 248, 85), map(t, 0, 1, 248, 166));
    text(title, x, y + 2);
  }
  
  boolean mouseIn() {
    return abs(mouseX - x) < w / 2 && abs(mouseY - y) < h / 2;
  }
}

class PlanButton {
  float x, y, w, h;
  String title;
  float t = 0;
  
  PlanButton(float _x, float _y, String _title) {
    x = _x;
    y = _y;
    w = 100;
    h = 100;
    title = _title;
  }
  
  void render() {
    if(mouseIn()) {
      t += .4 * (1 - t);
    } else {
      t *= .6;
    }
    noStroke();
    fill(map(t, 0, 1, 255, 23), map(t, 0, 1, 255, 85), map(t, 0, 1, 255, 166));
    rect(x, y, w, h, 14);
    textSize(20);
    fill(map(t, 0, 1, 154, 255), map(t, 0, 1, 35, 255), map(t, 0, 1, 35, 255));
    text(title, x, y + 3);
  }
  
  boolean mouseIn() {
    return abs(mouseX - x) < w / 2 && abs(mouseY - y) < h / 2;
  }
}


void cmd(String cmd) {   //USE THIS FUNCTION TO SEND MESSAGE TO ARDUINO
  if     (cmd == "reset") {port.write("EF");port.write('f');}
  else if(cmd == "pause") {port.write('P');}
  else if(cmd == "NORMAL") { myscreen.changemode("NORMAL");}
  else if(cmd == "PLAY") { myscreen.changemode("PLAY");}
  
  else if(cmd == "turnright") {port.write('A');}
  else if(cmd == "turnleft") {port.write('B');}
  else if(cmd == "up") {port.write('C');} 
  else if(cmd == "down") {port.write('D');}
  else if(cmd == "headback") {port.write('E');}
  else if(cmd == "bodyback") {port.write('F');}
  else if(cmd == "nod") {port.write('G');}
  else if(cmd == "rightshake") {port.write('H');}
  else if(cmd == "leftshake") {port.write('h');}
  else if(cmd == "sway") {port.write('I');}
  else if(cmd == "meet") {port.write('m');}
  
  else if(cmd == "a1play") {myaudio.change(1); myaudio.audio_play();}
  else if(cmd == "a2play") {myaudio.change(2); myaudio.audio_play();}
  else if(cmd == "a3play") {myaudio.change(3); myaudio.audio_play();}
  else if(cmd == "a4play") {myaudio.change(4); myaudio.audio_play();}
  else if(cmd == "a5play") {myaudio.change(5); myaudio.audio_play();}
  else if(cmd == "a6play") {myaudio.change(6); myaudio.audio_play();}
  else if(cmd == "a7play") {myaudio.change(7); myaudio.audio_play();}
  else if(cmd == "a8play") {myaudio.change(8); myaudio.audio_play();}
  else if(cmd == "a9play") {myaudio.change(9); myaudio.audio_play();}
  else if(cmd == "a10play") {myaudio.change(10); myaudio.audio_play();}
  
  else if(cmd == "v1play") {myvideo.change(1); myvideo.video_loop();}
  else if(cmd == "v2play") {myvideo.change(2); myvideo.video_play();}
  else if(cmd == "v3play") {myvideo.change(3); myvideo.video_play();}
  else if(cmd == "v4play") {myvideo.change(4); myvideo.video_play();}
  else if(cmd == "v5play") {myvideo.change(5); myvideo.video_play();}
  else if(cmd == "v6play") {myvideo.change(6); myvideo.video_play();}
  else if(cmd == "v7play") {myvideo.change(7); myvideo.video_play();}
  else if(cmd == "v8play") {myvideo.change(8); myvideo.video_play();}
  else if(cmd == "v9play") {myvideo.change(9); myvideo.video_play();}
  else if(cmd == "v10play") {myvideo.change(10); myvideo.video_play();}
  else if(cmd == "v11play") {myvideo.change(11); myvideo.video_play();}
  else if(cmd == "v12play") {myvideo.change(12); myvideo.video_play();}

  
  else if(cmd == "v1loop") {myvideo.change(1); myvideo.video_loop();}
  else if(cmd == "v2loop") {myvideo.change(2); myvideo.video_loop();}
  else if(cmd == "v3loop") {myvideo.change(3); myvideo.video_loop();}
  else if(cmd == "v4loop") {myvideo.change(4); myvideo.video_loop();}
  else if(cmd == "v5loop") {myvideo.change(5); myvideo.video_loop();}
  else if(cmd == "v6loop") {myvideo.change(6); myvideo.video_loop();}
  else if(cmd == "v7loop") {myvideo.change(7); myvideo.video_loop();}
  else if(cmd == "v8loop") {myvideo.change(8); myvideo.video_loop();}
  else if(cmd == "v9loop") {myvideo.change(9); myvideo.video_loop();}
  else if(cmd == "v10loop") {myvideo.change(10); myvideo.video_loop();}
  else if(cmd == "v11loop") {myvideo.change(11); myvideo.video_loop();}
  else if(cmd == "v12loop") {myvideo.change(12); myvideo.video_loop();}
   else if(cmd == "v13loop") {myvideo.change(13); myvideo.video_loop();}
   
  else if(cmd == "headstop") {port.write("j");}
  else if(cmd == "bodystop") {port.write("k");}
}

class TaskRunner {
  int t;  //t controls the time
  String mode;
  
  TaskRunner() {
    t = 0;
    mode = "reset";
  }
  
  void run(String _mode) {
    t = 0;
    mode = _mode;
  }
  
  void update() {
    t++;
    if(mode == "reset") {
      if(t == 1) {cmd("reset");mymessage.add_doing("reset");}
    }
    else if(mode == "pause") {
      if(t ==   1) {cmd("pause");mymessage.add_doing("pause");}
    }
    else if(mode == "NORMAL"){
      if(t==1) {cmd("NORMAL");mymessage.change_screen("NORMAL");}
    }
    else if(mode== "PLAY"){
      if(t==1) {cmd("PLAY");mymessage.change_screen("PLAY");}
    }
    else if(mode == "turnright") {
      if(t ==   1) {cmd("turnright");mymessage.add_doing("turnright");}
    }
    else if(mode == "turnleft") {
      if(t ==   1) {cmd("turnleft");mymessage.add_doing("turnleft");}
    }
    else if(mode == "up") {
      if(t ==   1) {cmd("up");mymessage.add_doing("up");}
    }
    else if(mode == "down") {
      if(t ==   1) {cmd("down");mymessage.add_doing("down");}
    }
    else if(mode == "headback") {
      if(t ==   1) {cmd("headback");mymessage.add_doing("headback");}
    }
    else if(mode == "bodyback") {
      if(t ==   1) {cmd("bodyback");mymessage.add_doing("bodyback");}
    }
    else if(mode == "nod") {
      if(t ==   1) {cmd("nod");mymessage.add_doing("nod");}
    }
    else if(mode == "rightshake") {
      if(t ==   1) {cmd("rightshake");mymessage.add_doing("rightshake");}
    }
    else if(mode == "leftshake") {
      if(t ==   1) {cmd("leftshake");mymessage.add_doing("leftshake");}
    }
    else if(mode == "sway") {
      if(t ==   1) {cmd("sway");mymessage.add_doing("sway");}
    }
    else if(mode == "v1") {
      if(t ==   1) {cmd("v1play");mymessage.add_doing("v1play");}
    }
    else if(mode == "v2") {
      if(t ==   1) {cmd("v2play");mymessage.add_doing("v2play");}
    }
    else if(mode == "v3") {
      if(t ==   1) {cmd("v3play");mymessage.add_doing("v3play");}
    }
    else if(mode == "v4") {
      if(t ==   1) {cmd("v4play");mymessage.add_doing("v4play");}
    }
    else if(mode == "v5") {
      if(t ==   1) {cmd("v5play");mymessage.add_doing("v5play");}
    }
    else if(mode == "v6") {
      if(t ==   1) {cmd("v6play");mymessage.add_doing("v6play");}
    }
      else if(mode == "v7") {
      if(t ==   1) {cmd("v7play");mymessage.add_doing("v7play");}
    }
      else if(mode == "v8") {
      if(t ==   1) {cmd("v8play");mymessage.add_doing("v8play");}
    }
      else if(mode == "v9") {
      if(t ==   1) {cmd("v9play");mymessage.add_doing("v9play");}
    }
      else if(mode == "v10") {
      if(t ==   1) {cmd("v10play");mymessage.add_doing("v10play");}
    }
      else if(mode == "v11") {
      if(t ==   1) {cmd("v11play");mymessage.add_doing("v11play");}
    }
      else if(mode == "v12") {
      if(t ==   1) {cmd("v12play");mymessage.add_doing("v12play");}
    }
     else if(mode == "v13") {
      if(t ==   1) {cmd("v13play");mymessage.add_doing("v13play");}
    }
    else if(mode == "a1") {
      if(t ==   1) {cmd("a1play");mymessage.add_doing("a1play");}
    }
    else if(mode == "a2") {
      if(t ==   1) {cmd("a2play");mymessage.add_doing("a2play");}
    }
    else if(mode == "a3") {
      if(t ==   1) {cmd("a3play");mymessage.add_doing("a3play");}
    }
    else if(mode == "a4") {
      if(t ==   1) {cmd("a4play");mymessage.add_doing("a4play");}
    }
    else if(mode == "a5") {
      if(t ==   1) {cmd("a5play");mymessage.add_doing("a5play");}
    }
    else if(mode == "a6") {
      if(t ==   1) {cmd("a6play");mymessage.add_doing("a6play");}
    }
    else if(mode == "a7") {
      if(t ==   1) {cmd("a7play");mymessage.add_doing("a7play");}
    }
    else if(mode == "a8") {
      if(t ==   1) {cmd("a8play");mymessage.add_doing("a8play");}
    }
     else if(mode == "a9") {
      if(t ==   1) {cmd("a9play");mymessage.add_doing("a9play");}
    }
    else if(mode == "a10") {
      if(t ==   1) {cmd("a10play");mymessage.add_doing("a10play");}
    }
    else if(mode == "headstop") {
      if(t ==   1) {cmd("headstop");mymessage.add_doing("head stop");}
    }
    else if(mode == "bodystop") {
      if(t ==   1) {cmd("bodystop");mymessage.add_doing("body stop");}
    }
    else if(mode == "meet"){
      if(t==1){cmd("meet");mymessage.add_doing("meet");}
    }
    //your groups
    /*else if(mode == "group 1") {
      if(t ==   1) {cmd("v1loop");cmd("turnright");cmd("up"); mymessage.add_doing("group 1");}
      if(t ==   30) {cmd("a1play");cmd("nod");}
      if(t ==   140) {cmd("pause");}
    }*/
    else if(mode=="group 1"){
      if(t == 1){mymessage.add_doing("group 1");}
      if(port.available()>0){
      if(watch_master(t)==false){t--;}
      }
      else{
        t--;
      }
    }
    else if(mode == "group 2") {
      if(t ==   1) {mymessage.add_doing("group 2");}
      meet(t);
    }
    else if(mode == "group 3") {
      if(t ==   1) {cmd("v8play");mymessage.add_doing("group 3");}
      if(t ==   20) {cmd("v12play");cmd("a10play");}
    }
    else if(mode == "group 4") {
      if(t ==   1) {cmd("v1loop");mymessage.add_doing("group 4");}
      if(t ==   10) {cmd("v10play");cmd("a7play");}
    }
    else if(mode == "group 5") {
      if(t ==   1) {cmd("v2play");mymessage.add_doing("group 5");}
      if(t ==   10) {myvideo.change(10);myvideo.video_anti();cmd("a8play");}
    }
  }
}
class position{
  PVector video_pos;
  PVector video_size;
  PVector pos1;
/*  PVector pos2;
  PVector pos3;
  PVector pos4;*/
  //int gapx=0.5;
  position(){
    video_pos=new PVector(unitx*3,unity*4.5);
    video_size=new PVector(videoWidth*0.8,videoHeight*0.8);
    pos1=new PVector(unitx*6.91,unity*3.22);
  }  
}
class robot_screen{
  int wid;
  int hei;
  float zoff;
  String Mode;
  PImage todraw_noise;
  
  robot_screen(){
  wid=videoWidth;
  hei=videoHeight;
  zoff=0.0;
  Mode="NORMAL";
  todraw_noise=createImage(wid/5,hei/5,RGB);
  }
  void draworigin(){
    pushMatrix();
    translate(screenWidth,0);
     rectMode(CORNER);
     rect(0,0,wid,hei);
    popMatrix();
  }
  void render(){
    switch(Mode){
      case "NORMAL":
      {
        pushMatrix();
        translate(screenWidth,0);
        float red=noise(zoff)*255;
        todraw_noise.loadPixels();
        float xoff=0.0;
        for(int x=0;x<todraw_noise.width;x++){
        float yoff=0.0;
        for(int y=0;y<todraw_noise.height;y++){
     //float bright=random(255);
        float bright = map(noise(xoff,yoff,zoff),0,1,0,255);
     //   float dis=sqrt((mouseX-width/2)*(mouseX-width/2)+(mouseY-height/2)*(mouseY-height/2));
     //   float center=map(dis,0,sqrt((width/2)*(width/2)+(height/2)*(height/2)),0,255);
        todraw_noise.pixels[x+y*todraw_noise.width]=color(red,bright,176);
        yoff+=0.01;
   }
        xoff+=0.01;
 }
        todraw_noise.updatePixels();
        zoff+=0.03;
        imageMode(CORNER);
        image(todraw_noise,0,0,wid,hei);
        popMatrix();
        break;
      }
    case "PLAY":
    {
      rectMode(CORNER);
      fill(0);
      rect(screenWidth,0,videoWidth,videoHeight);
      rectMode(CENTER);
      myvideo.show();
      break;
    }
    case "TEST":{
       pushMatrix();
       background=loadImage("222.png");
       imageMode(CORNERS);
       image(background,screenWidth,0);
       popMatrix();
    }
   }
  }
  void changemode(String change){
    Mode=change;
  }
}
class video_manager{
  String v1 = "v1.mov";
  String v2 = "v2.mov";
  String v3 = "v3.mp4";
  String v4 = "v4.mov";
  String v5 = "v5.mp4";
  String v6 = "v6.mp4";
  String v7 = "v7.mp4";
  String v8 = "v8.mp4";
  String v9 = "v9.mp4";
  String v10= "v10.mov";
  String v11= "v11.mp4";
  String v12= "v12.mov";
  String v13= "v13.mov";
  int current;
  Movie[] video=new Movie[20];
  PApplet app;
  
  video_manager(PApplet papp){
  app=papp;
  video[0]=new Movie(app,v1);
  video[1]=new Movie(app,v2);
  video[2]=new Movie(app,v3);
  video[3]=new Movie(app,v4);
  video[4]=new Movie(app,v5);
  video[5]=new Movie(app,v6);
  video[6]=new Movie(app,v7);
  video[7]=new Movie(app,v8);
  video[8]=new Movie(app,v9);
  video[9]=new Movie(app,v10);
  video[10]=new Movie(app,v11);
  video[11]=new Movie(app,v12);
  video[12]=new Movie(app,v13);
  current=1;
  }
  
  void video_play(){
    video[current].speed(1.0);
    video[current].stop();
    video[current].play();
  }
  
  void video_loop(){
    video[current].speed(1.0);
    video[current].loop();
  }
  void video_stop(){
    video[current].stop();
  }
  void video_anti(){
    video[current].speed(-1.0);
    video[current].play();
  }
  void change(int to){
    if(to<1){
    print("change video error");
    return;
    }
    current=to-1;
  }
  void show(){
     if (video[current].available()) {
       video[current].read();
     }
    imageMode(CENTER);
    image(video[current],mypos.video_pos.x,mypos.video_pos.y,mypos.video_size.x,mypos.video_size.y); 
   // imageMode(CORNERS);
    image(video[current],screenWidth+videoWidth/2,videoHeight/2,videoWidth,videoHeight);
  /* imageMode(CORNERS);
   image(video[current],screenWidth,0);*/
  }
}

class audio_manager{
  String a1 = "a1.mp3";
  String a2 = "a2.wav";
  String a3 = "a3.wav";
  String a4 = "a4.wav";
  String a5 = "a5.wav";
  String a6 = "a6.mp3";
  String a7 = "a7.mp3";
  String a8 = "a8.mp3";
  String a9 = "a9.mp3";
  String a10 = "a10.wav";
  PApplet app;
  int current=1;
  AudioPlayer[] audio=new AudioPlayer[15];
  Minim minim;
  
  audio_manager(PApplet papp){
    app=papp;
    minim=new Minim(papp);
    audio[0] = minim.loadFile(a1);
    audio[1] = minim.loadFile(a2);
    audio[2] = minim.loadFile(a3);
    audio[3] = minim.loadFile(a4);
    audio[4] = minim.loadFile(a5);
    audio[5] = minim.loadFile(a6);
    audio[6] = minim.loadFile(a7);
    audio[7] = minim.loadFile(a8);
    audio[8] = minim.loadFile(a9);
    audio[9] = minim.loadFile(a10);
    current=0;
  }
  
  void audio_play(){
    audio[current].rewind();
    audio[current].play();
  }
  
  void audio_loop(){
    audio[current].loop();
  }
  
   void change(int to){
     audio[current].pause();
    if(to<1){
    print("change audio error");
    return;
    }
    current=to-1;
  }
}
class message{
  String screenmode;
  ArrayList<String> doingnow;
  ArrayList<String> distances;
  message(){
    screenmode="Normal";
    doingnow=new ArrayList<String>();
    doingnow.add("Null");
    distances=new ArrayList<String>();
  }
void show_text(){
    textSize(32);
    text("Screen Mode: "+screenmode,1.18*unitx,0.5*unity,2.00*unitx,0.8*unity);
    if(doingnow.size()==1){
      text(doingnow.get(0),1.18*unitx,1.2*unity,2.00*unitx,1.5*unity);
    }
    else{
      float y1=1.2*unity;
      float y2=1.5*unity;
      for(int i=doingnow.size()-1;i>=0 && i>=doingnow.size()-4;i--){
        text(doingnow.get(i),1.18*unitx,y1,2.00*unitx,y2);
        y1+=0.5*unity;
        y2+=0.5*unity;
      }
    }
    if(distances.size()>0){
      float y1=1.2*unity;
      float y2=1.5*unity;
      for(int i=distances.size()-1;i>=0 && i>=distances.size()-4;i--){
        text(distances.get(i),3.68*unitx,y1,4.50*unitx,y2);
        y1+=0.5*unity;
        y2+=0.5*unity;
      }
    }
  }
  void change_screen(String in){
    screenmode=in;
  }
  void add_doing(String in){
    if(doingnow.size()>5){
      int gap=doingnow.size()-5;
      for(int i=0;i<gap;i++){
        doingnow.remove(i);
      }
    }
    doingnow.add(in);
  }
  void add_dis(String dis){
    if(distances.size()>5){
       int gap=distances.size()-5;
      for(int i=1;i<gap;i++){
        distances.remove(i);
      }
    }
    distances.add(dis);
  }
  void remove_doing(String in){
    for(int i=1;i<doingnow.size();i++){
      if(doingnow.get(i)==in){
        doingnow.remove(i);
        break;
      }
    }
  }
}
void mirror(){
  pushMatrix();
  textAlign(CENTER);
  fill(#3E3A39);
  rect(unitx * 3,unity * 4.5,videoWidth * 0.8,videoHeight * 0.8);
  textSize(20);
  fill(#E2E2E1);
  text("Video Mirror",unitx * 3,unity * 4.5);
  popMatrix();
}
boolean watch_master(int in){
  int dis=port.read();
  //println(dis+"and the in is"+in);
  mymessage.add_dis("the distance is"+dis);
  if(in==2){
    cmd("v7play");
    return true;
  }
  else if(in>2&&in<10){
  //  port.write('o');
  }
  else if(in==10){
    if(keyPressed==true){
      counter=0;
      port.write('f');
      cmd("turnleft");
      mymessage.add_doing("turnleft and touched");
      cmd("v4play");
      return true;
    }
    if(dis<10 && dis!=0){
      if(counter<2){
        counter++;
        return false;
      }
      else{
      counter=0;
   //   port.write('f');
      cmd("turnleft");
      mymessage.add_doing("turnleft and touched");
      cmd("v4play");
      return true;
      }
    }
    else{
      return false;
    }
  }
  else if(in==15){
    cmd("bodystop");
    cmd("nod");
    mymessage.add_doing("nod");
    return true;
  }
  else if(in==25){
  //  port.write('o');
  }
  else if(in>25 && (dis>10) ){
    if(keyPressed==true){
        counter=0;
    cmd("pause");
   // myvideo.video_stop();
    cmd("v9play");
    mymessage.add_doing("group1 over");
    tr.run("reset");
    return true;
    }
    if(counter<=1){
      counter++;
      return false;
    }
    else{
 //   port.write('f');
    counter=0;
    cmd("pause");
   // myvideo.video_stop();
    cmd("v9play");
    mymessage.add_doing("group1 over");
    tr.run("reset");
    return true;
    }
  }
  return true;
}
void meet(int t){
  if(t==1){
    cmd("v2play");
    mymessage.add_doing("v2 play");
  }
  else if(t==8){
    cmd("meet");
    cmd("a9play");
    mymessage.add_doing("meet");
  }
  else if(t==20){
    cmd("v5play");
    mymessage.add_doing("v5 play");
  }
 /* else if(t==23){
     cmd("a1play");
      mymessage.add_doing("a1 play");
  }
   else if(t==55){
    cmd("v6play");
    mymessage.add_doing("v6 play");
  }
   else if(t==90){
    cmd("v3play");
    mymessage.add_doing("v3 play");
  }*/
 
 else if(t==70){
    cmd("turnleft");
    mymessage.add_doing("turn left");
  }
  else if(t==75){
    cmd("up");
    mymessage.add_doing("head up");
  }
   else if(t==80){
    cmd("v11play");
    mymessage.add_doing("v11 play");
  }
  else if(t==115){
    cmd("down");
    mymessage.add_doing("head back");
  }
  else if(t==120){
    cmd("bodyback");
  }
  else if(t==125){
      cmd("v6play");
      cmd("headback");
  }
  else if(t==150){
    cmd("v13play");
    mymessage.add_doing("group2 over");
    tr.run("reset");
  }
}
/*class addballs{
  Minim minim;
  AudioInput in;
  PApplet app;
  addballs(PApplet papp){
    app=papp;
    minim=new Minim(app);
    in=minim.getLineIn();
  }
  
}
class ball{
  PVector location;
  int lifespan;
  float radd;
  float rorigin;
  float r;
  float vmax=5;
  PVector v;
  PVector a;
  boolean dead;
  ball(){
    location=new PVector(random(100,width-100),random(100,height-100));
    lifespan=255;
    rorigin=(float)random(10,30);
    v=new PVector(random(-5,5),random(-5,5));
    a=new PVector(random(-3,3),random(-3,3));
    dead=false;
  }
  void update(){
    radd=500*in.mix.get(0);
    r=radd+rorigin;
    checkedge();
    v.add(a);
    v.limit(vmax);
    location.add(v);
  }
  void checkedge(){
    if(location.x<10||location.x>width-10||location.y<10||location.y>height-10){
       v.x*=-0.8;
       v.y*=-0.8;
       a.x*=-0.8;
       a.y*=-0.8;
    }
  }
  void render(){
    update();
    noStroke();
    fill(50);
    ellipse(location.x,location.y,r,r);
  }
}*/