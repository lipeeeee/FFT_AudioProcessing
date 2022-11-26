import processing.pdf. * ;

import ddf.minim. * ;
import ddf.minim.analysis. * ;

import processing.pdf. * ;

Minim minim;
AudioPlayer player;
AudioMetaData meta;
BeatDetect beat;
FFT fft;
int r = 0; //100
float rad = 50; //50
void setup() {

  size(375, 667);
  minim = new Minim(this);
  player = minim.loadFile("musica.mp3");
  meta = player.getMetaData();
  beat = new BeatDetect();
  fft = new FFT(player.bufferSize(), player.sampleRate());
  player.loop();
  //player.play();
  background( - 1);
  noCursor();
  beginRecord(PDF, "Ikeda_IDM.pdf");
}

void draw() {
  fft.forward(player.mix);
  beat.detect(player.mix);
  fill(#000000, 20);
  

  int freq = int(fft.getFreq(fft.getBandWidth()));
  int[] cor = calcularCor(freq);
  stroke(cor[0], cor[1], cor[2]);
  for(int i = 0; i < fft.specSize(); i++)
  {
    line( i, height, i, height - fft.getBand(i)*6);
  }
  
  if (r < 100) r++;

  //noStroke();

  rect(0, 0, width, height);

  translate(width / 2, height / 2);

  noFill();

  fill( - 1, 10);

  if (beat.isOnset()) rad = rad * 0.9; //.9
  else {
    rad = 70;
  }  /*/70*/

  int bsize = player.bufferSize();
  for (int i = 0; i < bsize - 1; i += 5) {
    float x = (r) * cos(i * 2 * PI / bsize);
    float y = (r) * sin(i * 2 * PI / bsize);
    float x2 = (r + player.left.get(i) * 65) * cos(i * 2 * PI / bsize);
    float y2 = (r + player.left.get(i) * 65) * sin(i * 2 * PI / bsize);
    line(x, y, x2, y2);
  }
  beginShape();
  noFill();
  stroke(25, 50);
  for (int i = 0; i < bsize; i += 30) {
    float x2 = (r + player.left.get(i) * 20) * cos(i * 0 * PI / bsize); //(r + player.left.get(i) * 100) * cos(i * 2 * PI / bsize)
    float y2 = (r + player.left.get(i) * 20) * sin(i * 0 * PI / bsize);
    vertex(x2, y2);
    pushStyle();
    stroke(-1);
    strokeWeight(3);
    point(x2, y2);
    popStyle();
  }
  endShape();
  if (flag) showMeta();
}

/*
  Frequencias baixas = cores frias
  Frequencias altas = cores quentes
*/
// Devolve Hexadecimal
// (depois de testar foi notado que freq vai, no máximo, até 450
int[] calcularCor(int freq){  
  if (freq < 5) return new int[] {0, 0, 0};
  else if (freq < 10) return new int[] {8, 9, 10};
  else if (freq < 20) return new int[] {22, 23, 27};
  else if (freq < 30) return new int[] {39, 41, 48};
  else if (freq < 40) return new int[] {86, 69, 69};
  else if (freq < 50) return new int[] {120, 90, 90};
  else if (freq < 100) return new int[] {150, 104, 90};
  else if (freq < 200) return new int[] {191, 135, 105};
  else if (freq < 300) return new int[] {117, 248, 137}; 
  else if (freq < 400) return new int[] {117, 191, 254};
  else return new int[] {255, 0, 0};
}

void showMeta() {
  int time = meta.length();
  textSize(50);
  textAlign(CENTER);
  text((int)(time / 1000 - millis() / 1000) / 60 + ":" + (time / 1000 - millis() / 1000) % 60, 0, -250);
}

boolean flag = false;
void mousePressed() {
  if (dist(mouseX, mouseY, width / 2, height / 2) < 150) flag = !flag;
}

void keyPressed() {
  if (key == ' ') exit();
  if (key == 's') saveFrame("imagens/###.jpeg");
  if (key == 'q') {
    endRecord();
    exit();
  }
}
