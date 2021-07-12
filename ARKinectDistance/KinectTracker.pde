
class KinectTracker {

  // Depth threshold
  int threshold = 1032;
  int threshold1 =1036;


  // Raw location
  PVector loc;

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;

  // What we'll show the user
  PImage display;

  KinectTracker() {
    // This is an awkard use of a global variable here
    // But doing it this way for simplicity
    kinect.initDepth();
    kinect.initVideo();
    kinect.enableMirror(true);
    // Make a blank image
    display = createImage(kinect.width, kinect.height, RGB);
    // Set up the vectors
    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
  }

  void track() {
    // Get the raw depth as array of integers
    depth = kinect.getRawDepth();

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 1;
    float sumY = 1;
    float count = 1;

    for (int x = 320; x < 340; x++) {
      for (int y = 240; y < 247; y++) {

        int offset =  x + y*kinect.width;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold1 && rawDepth > threshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }

    avgX = sumX/count;
    avgY = sumY/count;

    avgX1 = map(avgX, 640, 0, 1280, 0);
    avgY1 = map(avgY, 0, 480, 0, 720);

    // As long as we found something
    if (count != 0) {
      loc = new PVector(sumX/count, sumY/count);
    }

    // Interpolating the location, doing it arbitrarily for now
    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
  }

  void printnew() {
    float a1 = avgX;
    println(a1);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
    PImage img = kinect.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 320; x < 340; x++) {
      for (int y = 240; y < 247; y++) {
        int offset = x + y * kinect.width;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y * display.width;
        if (rawDepth < threshold1 && rawDepth > threshold) {
          // A red color instead
          inThreshold = true;
          display.pixels[pix] = color(150, 50, 50);
        } else {
          display.pixels[pix] = color(255);//img.pixels[offset];
        }
      }
    }
    display.updatePixels();
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }

  int getThreshold1() {
    return threshold1;
  }

  void setThreshold1(int a) {
    threshold1 =  a;
  }
}
