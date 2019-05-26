import processing.serial.*;
import ddf.minim.*;
import processing.video.*;
//PImage background;
Movie video;
AudioPlayer audio;
import processing.serial.*;
import ddf.minim.*;
import processing.video.*;
PImage background;


Serial port;
robot_screen myscreen;

int screenWidth = 1920;//your PC screenWidth
int screenHeight = 1080;//your PC screenHeight
int videoWidth = 1280;//your LCD screenWidth
int videoHeight = 720;//your LCD screenWidth

int unitx;
int unity;

ArrayList<Button> buttons;
ArrayList<PlanButton> planbuttons;
TaskRunner tr;
position mypos;
video_manager myvideo;
audio_manager myaudio;

boolean success;

void setup() {
  fullScreen(SPAN);
  unity = screenHeight / 10;  //the 1/10 of screen height
  unitx = screenWidth / 10;   //the 1/10 of screen width
  mypos=new position();
  myscreen=new robot_screen();
  myvideo=new video_manager(this);
  myaudio=new audio_manager(this);
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
  
}

void mouseClicked() {
  for(int i = 0; i < buttons.size(); i++) {
    Button b = buttons.get(i);
    if(b.mouseIn()) {
      tr.run(b.title);
      break;
    }
  }
  for(int i = 0; i < planbuttons.size(); i++) {
    PlanButton b = planbuttons.get(i);
    if(b.mouseIn()) {
      tr.run(b.title);
      break;
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
 
  buttons.add(new Button(unitx * 6.91, unity * 6.78, "v1"));
  buttons.add(new Button(unitx * 7.42, unity * 6.78, "v2"));
  buttons.add(new Button(unitx * 7.92, unity * 6.78, "v3"));
  buttons.add(new Button(unitx * 8.43, unity * 6.78, "v4"));
  buttons.add(new Button(unitx * 8.94, unity * 6.78, "v5"));
  
  buttons.add(new Button(unitx * 6.91, unity * 8.74, "a1"));
  buttons.add(new Button(unitx * 7.42, unity * 8.74, "a2"));
  buttons.add(new Button(unitx * 7.92, unity * 8.74, "a3"));
  buttons.add(new Button(unitx * 8.43, unity * 8.74, "a4"));
  buttons.add(new Button(unitx * 8.94, unity * 8.74, "a5"));
  
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
  if     (cmd == "reset") {port.write("EF");myvideo.video_stop();}
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
  
  else if(cmd == "a1play") {myaudio.change(1); myaudio.audio_play();}
  else if(cmd == "a2play") {myaudio.change(2); myaudio.audio_play();}
  else if(cmd == "a3play") {myaudio.change(3); myaudio.audio_play();}
  else if(cmd == "a4play") {myaudio.change(4); myaudio.audio_play();}
  else if(cmd == "a5play") {myaudio.change(5); myaudio.audio_play();}
  
  else if(cmd == "v1play") {myvideo.change(1); myvideo.video_play();}
  else if(cmd == "v2play") {myvideo.change(2); myvideo.video_play();}
  else if(cmd == "v3play") {myvideo.change(3); myvideo.video_play();}
  else if(cmd == "v4play") {myvideo.change(4); myvideo.video_play();}
  else if(cmd == "v5play") {myvideo.change(5); myvideo.video_play();}
  
  else if(cmd == "v1loop") {myvideo.change(1); myvideo.video_loop();}
  else if(cmd == "v2loop") {myvideo.change(2); myvideo.video_loop();}
  else if(cmd == "v3loop") {myvideo.change(3); myvideo.video_loop();}
  else if(cmd == "v4loop") {myvideo.change(4); myvideo.video_loop();}
  else if(cmd == "v5loop") {myvideo.change(5); myvideo.video_loop();}
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
      if(t == 1) {cmd("reset");}
    }
    else if(mode == "pause") {
      if(t ==   1) {cmd("pause");}
    }
    else if(mode == "NORMAL"){
      if(t==1) cmd("NORMAL");
    }
    else if(mode== "PLAY"){
      if(t==1) cmd("PLAY");
    }
    else if(mode == "turnright") {
      if(t ==   1) {cmd("turnright");}
    }
    else if(mode == "turnleft") {
      if(t ==   1) {cmd("turnleft");}
    }
    else if(mode == "up") {
      if(t ==   1) {cmd("up");}
    }
    else if(mode == "down") {
      if(t ==   1) {cmd("down");}
    }
    else if(mode == "headback") {
      if(t ==   1) {cmd("headback");}
    }
    else if(mode == "bodyback") {
      if(t ==   1) {cmd("bodyback");}
    }
    else if(mode == "nod") {
      if(t ==   1) {cmd("nod");}
    }
    else if(mode == "rightshake") {
      if(t ==   1) {cmd("rightshake");}
    }
    else if(mode == "leftshake") {
      if(t ==   1) {cmd("leftshake");}
    }
    else if(mode == "sway") {
      if(t ==   1) {cmd("sway");}
    }
    else if(mode == "v1") {
      if(t ==   1) {cmd("v1play");}
    }
    else if(mode == "v2") {
      if(t ==   1) {cmd("v2play");}
    }
    else if(mode == "v3") {
      if(t ==   1) {cmd("v3play");}
    }
    else if(mode == "v4") {
      if(t ==   1) {cmd("v4play");}
    }
    else if(mode == "v5") {
      if(t ==   1) {cmd("v5play");}
    }
    else if(mode == "a1") {
      if(t ==   1) {cmd("a1play");}
    }
    else if(mode == "a2") {
      if(t ==   1) {cmd("a2play");}
    }
    else if(mode == "a3") {
      if(t ==   1) {cmd("a3play");}
    }
    else if(mode == "a4") {
      if(t ==   1) {cmd("a4play");}
    }
    else if(mode == "a5") {
      if(t ==   1) {cmd("a5play");}
    }
    
    //your groups
    else if(mode == "group 1") {
      if(t ==   1) {cmd("v1loop");cmd("turnright");cmd("up");}
      if(t ==   30) {cmd("a1play");cmd("nod");}
      if(t ==   140) {cmd("pause");}
    }
    else if(mode == "group 2") {
      if(t ==   1) {cmd("v2loop");cmd("up");cmd("turnright");}
      if(t ==   60) {cmd("a2play");}
      if(t ==   90) {cmd("pause");}
    }
    else if(mode == "group 3") {
      if(t ==   1) {cmd("v3play");cmd("up");}
      if(t ==   30) {cmd("a3play");}
    }
    else if(mode == "group 4") {
      if(t ==   1) {cmd("v4play");cmd("sway");}
      if(t ==   30) {cmd("a4play");}
    }
    else if(mode == "group 5") {
      if(t ==   1) {cmd("v5play");cmd("turnright");cmd("up");cmd("bodyback");}
      if(t ==   30) {cmd("rightshake");}
      if(t ==   60) {cmd("a5play");}
    }
  }
}
class position{
  PVector video_pos;
  PVector video_size;
  PVector pos1;
  PVector pos2;
  PVector pos3;
  PVector pos4;
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
  String v1 = "video_1.mp4";
  String v2 = "video_2.mp4";
  String v3 = "video_3.mp4";
  String v4 = "video_4.mp4";
  String v5 = "video_5.mp4";
  int current;
  Movie[] video=new Movie[10];
  PApplet app;
  
  video_manager(PApplet papp){
  app=papp;
  video[0]=new Movie(app,v1);
  video[1]=new Movie(app,v2);
  video[2]=new Movie(app,v3);
  video[3]=new Movie(app,v4);
  video[4]=new Movie(app,v5);
  current=1;
  }
  
  void video_play(){
    video[current].stop();
    video[current].play();
  }
  
  void video_loop(){
    video[current].loop();
  }
  void video_stop(){
    video[current].stop();
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
    imageMode(CORNERS);
    image(video[current],screenWidth,0);
  }
}

class audio_manager{
  String a1 = "audio_1.mp3";
  String a2 = "audio_2.mp3";
  String a3 = "audio_3.mp3";
  String a4 = "audio_4.mp3";
  String a5 = "audio_5.mp3";
  PApplet app;
  int current=1;
  AudioPlayer[] audio=new AudioPlayer[10];
  Minim minim;
  
  audio_manager(PApplet papp){
    app=papp;
    minim=new Minim(papp);
    audio[0] = minim.loadFile(a1);
    audio[1] = minim.loadFile(a2);
    audio[2] = minim.loadFile(a3);
    audio[3] = minim.loadFile(a4);
    audio[4] = minim.loadFile(a5);
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