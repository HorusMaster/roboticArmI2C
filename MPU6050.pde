import processing.io.I2C;

int power_mgmt_1 = 0x6B;
int power_mgmt_2 = 0x6C;

int tempbyte = 0x41;

int accel_xout_byte = 0x3b;
int accel_yout_byte = 0x3d;
int accel_zout_byte = 0x3f;


class MPU6050 extends I2C {
  int address;
    MPU6050(String dev, int address) {
    super(dev);
    this.address = address;
    println("Adress Driver: "+ address);   
    init();    
  }

  protected void init() {    
    writeCommand(power_mgmt_1, 0x00);
  }
 // READ TEMPERATURE       
   float readTemp() {
     int tempraw = readWord((byte)tempbyte);
     float tempfinal = (tempraw / 340.0) + 36.53;   
   return tempfinal;
   }   

   
   float[] readRotation() {
     int accelxraw = readWord((byte)accel_xout_byte);
     int accelyraw = readWord((byte)accel_yout_byte);
     int accelzraw = readWord((byte)accel_zout_byte);     
     float accelxScaled = accelxraw / 16384.0;
     float accelyScaled = accelyraw / 16384.0; 
     float accelzScaled = accelzraw / 16384.0;
     float xrotation = get_x_rotation(accelxScaled, accelyScaled, accelzScaled);
     float yrotation = get_y_rotation(accelxScaled, accelyScaled, accelzScaled);
     //for (int i = 0; i<2; i++){
        float  xyVals[] = {xrotation, yrotation};
        return xyVals; 
       //}
     
   }  
   
//PROCESSS GET ROTATION   
   float get_y_rotation(float x, float y, float z){
    float radians = atan2(x, dist(y,z));
    return -degrees(radians);
}
 float get_x_rotation(float x, float y, float z){
    float radians = atan2(y, dist(x,z));
    return degrees(radians);
}
float dist(float a, float b){
    return sqrt((a*a)+(b*b));
  }
   
 //PROCESS TO READ WORD   
   int readWord(byte word) {
   byte[] word1 = readCommand(word); 
   int wordFinal = (word1[0] & 0xff) << 8 | (word1[1] & 0xff);
   if (wordFinal >= 0x8000){
        wordFinal = -((65535 - wordFinal) + 1);}
    else{
        wordFinal = wordFinal;
      }   
   return (wordFinal);      
   }   
  
    
  

  protected void writeCommand(int arg1) {
    super.beginTransmission(address);   
    super.write(arg1);
    super.endTransmission();
  }

  protected void writeCommand(int arg1, int arg2) {
    super.beginTransmission(address);  
    super.write(arg1);
    super.write(arg2);
    super.endTransmission();
  }

  protected void writeCommand(int arg1, int arg2, int arg3) {
    super.beginTransmission(address);    
    super.write(arg1);
    super.write(arg2);
    super.write(arg3);
    super.endTransmission();
  }
  
    byte[] readCommand(int arg1) {
    super.beginTransmission(address);    
    super.write(arg1);
    byte[] byteread = super.read(2);
    super.endTransmission();
    return byteread;
  }
  
}