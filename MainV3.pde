import processing.io.*;
PCA9685 pca9685;
MPU6050 mpu6050;

  int servo_min = 200;
  int servo_max = 650;
  

void setup() {
  size(640, 480);
  pca9685 = new PCA9685("i2c-1", 0x40);  
  pca9685.setServoPulse(15, 20);
  pca9685.setServoPulse(14, 20);
  pca9685.setPWMFreq(60);
  
  mpu6050 = new MPU6050("i2c-1", 0x68);
}

void draw() {  
  background(0);
  stroke(255);

  
  //int temp = mpu6050.readTemp();
  //float temp = mpu6050.readTemp();
  float temp = mpu6050.readTemp();
  float[] xyvals = mpu6050.readRotation();
  float xval = xyvals[0];
  println("Angulo Real: "+xval);
  //println(round(temp));
  
  float mapAngle = map(xval, -90, 90, servo_min, servo_max);
  println("Angulo Mapeado: "+mapAngle);
  pca9685.setPWM(15, 0, (int)mapAngle);
  pca9685.setPWM(14, 0, servo_min);
  line(width/2, height/2, width/2+sin(radians(xval))*width/2, height/2-cos(radians(xval))*height/2);
  delay(50);
  //pca9685.setPWM(15, 0, servo_max); 
}