import processing.video.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;

//Gif loopingGif;
Capture cam;
Movie mov, leftMov, centerMov, rightMov;
PImage img1, img2, img3, img4, img5, img6;
PImage hand;
int time = 10;
float avgX, avgX1;
float avgY, avgY1;

int timer = 0;
int currTimer = millis() + 1000;
int se = 0;

boolean firstImage, secondImage, thirdImage, fourthImage, fifthImage, sixthImage, firstTime, secondTime, thirdTime;
boolean firstTimer, secondTimer, thirdTimer;
boolean show1, show2, show3, leftMov1, centerMov1, rightMov1;
boolean mov1, mov2, mov3, normalVid, back = true;
int index;
boolean trackSensor, inThreshold;

void setup() {
  size(1280, 720, P3D);
  cam = new Capture(this, 640, 480);
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  hand = loadImage("hand.png");

  mov = new Movie(this, "../../AR_Render_Final/Industries.mov");
  cam.start(); 
  firstTime = false;
  trackSensor = true;
  inThreshold = false;


void captureEvent(Capture cam) {
  cam.read();
}

void movieEvent(Movie mov) {
  mov.read();
}

void draw() {
  background(0);
  surface.setTitle((int)frameRate + " fps");

  // Run the tracking analysis

  if (trackSensor == true) {
    tracker.track();
    // Show the image
    tracker.printnew();
   // tracker.display();
  }


  pushMatrix();
  scale(-1, 1);
  translate(-1280, 0);
  image(cam, 0, 0, 1280, 720);
  popMatrix();

  //image(kinect.getVideoImage(), 0, 0, 1280, 720);
  if (firstTime == true) {
    image(mov, 0, 0);
  }

  textSize(40);
  fill(255, 0, 0);
  text("Track Sensor : " + trackSensor, 100, 100);
  text("In Threshold : " + inThreshold, 100, 200);
  //text(mouseX + "   " + mouseY, 100, 300);
  rect(540, 450, 200, 150);

  // Let's draw the raw location
  PVector v11 = tracker.getPos();
  float v1_x = map(v11.x, 640, 0, 1280, 0);
  float v1_y = map(v11.y, 0, 480, 0, 720);
  fill(50, 100, 250, 200);
  noStroke();
  ellipse(v11.x, v11.y, 20, 20);

  // Let's draw the "lerped" location
  PVector v22 = tracker.getLerpedPos();
  float v2_x = map(v22.x, 640, 0, 1280, 0);
  float v2_y = map(v22.y, 0, 480, 0, 720);
  fill(100, 250, 50, 200);
  noStroke();

     if (mov.time() >= mov.duration()-2) {
      //mov.stop();
      mov.jump(1);
      mov.pause();
      mov1 = false;
      firstTime = false;
      trackSensor = true;
      inThreshold = false;
    }

    else if (avgX >= 250) {

      firstTime = true;
      trackSensor = false;
      mov.play();
      println("avgX : " + avgX);

  }




  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
    "UP increase threshold, DOWN decrease threshold", 10, 500);
}

// Adjust the threshold with key presses
void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
}
