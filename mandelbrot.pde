float range = 2, x = 0, y = 0, k = 1, factor = 0.9;

void setup() {
  size(800, 800);
  pixelDensity(1);
  drawMandelbrot();
  stroke(255, 0, 0);
  noFill();
}

void drawMandelbrot() {
  loadPixels();
  int limit = 1000;

  float real, imagine, cReal, cImagine, realTemp;
  int[] palette = initPalette(limit + 1);
  for (int px = 0; px < width; px++) {
    for (int py = 0; py < height; py++) {
      cReal = map(px, 0, width, x - range, x + range);
      cImagine = map(py, 0, height, y - range, y + range);
      real = 0;
      imagine = 0;
      int iterations = 0;
      while (real*real + imagine*imagine < 2*2 && iterations < limit) {
        realTemp = real*real - imagine*imagine + cReal;
        imagine = 2*real*imagine + cImagine;
        real = realTemp;
        iterations++;
      }
      pixels[px + py * width] = palette[iterations];
    }
  }
  updatePixels();
}

void draw() {
  updatePixels();
  int pxrange = (int) (width * k) / 2;
  int pyrange = (int) (height * k) / 2;
  rect(mouseX - pxrange, mouseY - pyrange, width * k, height * k); // preview
}

void mousePressed() {
  if (mouseButton == LEFT) {
    x = map(mouseX, 0, width, x - range, x + range);
    y = map(mouseY, 0, height, y - range, y + range);
    range *= k;
    k = 1;
    drawMandelbrot();
  }
}

int[] initPalette(int n) {
  int[] palette = new int[n];
  for (float i = 0; i < n; i++) {
    int range = (int) map(pow(i/n, 1./3), 0, 1, 0, 255);
    palette[(int)i] = color(range);
  }
  return palette;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e < 0) {
    k *= factor;
  } else {
    k /= factor;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) { // same as mouseWheel
      k *= factor;
    } else if (keyCode == DOWN) {
      k /= factor;
    } else if (keyCode == LEFT) { // reset
      range = 2;
      x = 0;
      y = 0;
      k = 1;
      drawMandelbrot();
    }
  }
}
