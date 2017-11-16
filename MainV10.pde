import processing.io.*;
import controlP5.*;


ControlP5 cp5;
Slider2D s;
Slider sz;

int zaxis;
boolean toggleValue = false;

PCA9685 pca9685;
MPU6050 mpu6050;
IK ik;

  int speed =  30;
  int servo0 = 0;
  int servo1 = 1;
  int servo2 = 2;
  int servo3 = 3;
  int servo4 = 4;
  int servo5 = 5;   
 
  float AngGiro, AngBrazo, AngAntBr, AngMunec;  
  float AngBrazoAux;
  float[] angles;
  
  
void setup() {   
  size(800,480);
  
  cp5 = new ControlP5(this);
     s = cp5.addSlider2D("Eje_X_Y")
         .setPosition(200,100)
         .setSize(300,240)
         .setMinMax(-100,100,100,0)
         .setValue(0,50);
         //.disableCrosshair() 
         
       sz= cp5.addSlider("Eje_Z")
         .setPosition(600,100)
         .setSize(50,240)
         .setRange(0,100)
         .setValue(50);
         
         cp5.addToggle("Gripper")
         .setPosition(50,250)
         .setSize(50,20)
         .setValue(true)
         .setMode(ControlP5.SWITCH)
         ;
      
        cp5.addBang("Enviar").setPosition(500,400).setSize(100,50); 
  
  pca9685 = new PCA9685("i2c-1", 0x40);
  pca9685.setPWMFreq(60);    
  mpu6050 = new MPU6050("i2c-1", 0x68);
  ik = new IK();       
  
  //HOMEEEE  
  setNewCoordinates(0, 60, 80);    
  delay(50);
  abrirEF();    
}

  void draw() {    
    background(0);
    stroke(255); 
   // line(width/2, height/2, width/2+cos(radians(AngBrazo))*width/2, height/2-sin(radians(AngBrazo))*height/2); 
    
  }

void Enviar() { 
   println("Valor de X: "+s.getArrayValue()[0]);
   println("Valor de Y: "+s.getArrayValue()[1]);
   println("Valor de Z: "+sz.getValue());
   setNewCoordinates((int)s.getArrayValue()[0], (int)s.getArrayValue()[1], (int)sz.getValue()); 
}

void Gripper(boolean theFlag) {
  if(theFlag==true) {
     println("Abrir Gripper");
     abrirEF(); 
  } else {
     println("Cerrar Gripper");
     cerrarEF(); 
  } 
}


  private void setNewCoordinates(int X, int Y, int Z){    
    angles = ik.calculateAngles(X, Y, Z);
    AngGiro = angles[0]; 
    println("Angulo Giro: "+AngGiro);
    AngBrazo = angles[1]; 
    AngBrazoAux = AngBrazo;
    println("Angulo Brazo: "+AngBrazo);
    AngAntBr = angles[2];  
    println("Angulo AntBrazo: "+AngAntBr);
    AngMunec = angles[3];  
    println("Angulo Munec: "+AngMunec);   
  
    setAngleServo0 (servo0, AngGiro);
    delay(50);
    setAngleServo1 (servo1, AngBrazo);
    delay(50);
    setAngleServo2 (servo2, AngAntBr);
    delay(50);
    setAngleServo3 (servo3, AngMunec);
    delay(50);
    pca9685.setPWM(4, 0, 500); //Rotatorio no se usa 
    delay(50);
  }


  private void setAngleServo0(int servoID, float angle){
     float mapAngle = map(angle, 0, 180, 170, 620);      
      pca9685.setPWM(servoID, 0, (int)mapAngle);     
  }
  private void setAngleServo1(int servoID, float angle){
      float mapAngle = map(angle, 0, 180, 190, 620); 
      pca9685.setPWM(servoID, 0, (int)mapAngle);
  }
   private void setAngleServo2(int servoID, float angle){
      float mapAngle = map(angle, 0, 180, 840, 360); 
      pca9685.setPWM(servoID, 0, (int)mapAngle);
  }
  private void setAngleServo3(int servoID, float angle){
      float mapAngle = map(angle, 0, 180, 100, 440); 
      pca9685.setPWM(servoID, 0, (int)mapAngle);
  }
  
   private void abrirEF(){     
     pca9685.setPWM(5, 0, 150); //Efector Final 
 }
   private void cerrarEF(){     
     pca9685.setPWM(5, 0, 250); //Efector Final 
 }
  