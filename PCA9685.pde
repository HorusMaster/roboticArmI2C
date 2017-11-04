import processing.io.I2C;

int MODE1              = 0x00;
int MODE2              = 0x01;

int PRESCALE           = 0xFE;

int LED0_ON_L          = 0x06;
int LED0_ON_H          = 0x07;
int LED0_OFF_L         = 0x08;
int LED0_OFF_H         = 0x09;

int ALL_LED_ON_L       = 0xFA;
int ALL_LED_ON_H       = 0xFB;
int ALL_LED_OFF_L      = 0xFC;
int ALL_LED_OFF_H      = 0xFD;

//# Bits:
int  RESTART            = 0x80;
int SLEEP              = 0x10;
int ALLCALL            = 0x01;
int INVRT              = 0x10;
int OUTDRV             = 0x04;

int SERVO_ADDRESS = 0x40;


class PCA9685 extends I2C {
  int address;
    PCA9685(String dev, int address) {
    super(dev);
    this.address = address;
    println("Adress Driver: "+ address);
   
    init();    
  }

  protected void init() {
    
    setAllPWM((byte)0, (byte)0);
    writeCommand(MODE2, OUTDRV);   
    writeCommand(MODE1, ALLCALL);
    delay(5);
    int mode1 = readCommand(MODE1);
    println("mode1 read: "+mode1);
    mode1 = mode1 & ~SLEEP;
    println("mode1 mas sleep: "+mode1);
    writeCommand(MODE1, (byte)mode1);
    delay(5); 
  }
  
  public void setPWMFreq(int freq){
    float preScaleVal = 25000000.0;
    preScaleVal /=4096.0;
    preScaleVal /=(float)freq;
    preScaleVal -=1.0;
    int preScale = (int)Math.floor(preScaleVal +0.5);
    println("Prescale: Final "+preScale);
    int oldmode = (byte) readCommand(MODE1);
    println("Old Mode: "+oldmode);
    int newmode = (byte) ((oldmode & 0x7F) | 0x10);
    println("New Mode: "+newmode);    
    writeCommand(MODE1, newmode);   
    writeCommand(PRESCALE, (byte)(preScale));
    writeCommand(MODE1, oldmode);
    delay(5);
    writeCommand(MODE1, (byte) (oldmode | 0x80));        
  }
  
   public void setServoPulse(int channel, float pulseMS){
     double pulseLength = 1000000;
     pulseLength /=60;
     pulseLength /=4096;
     int pulse = (int)(pulseMS * 1000);
     pulse /= pulseLength;
     this.setPWM(channel, 0, pulse);       
  }
    
    
   public void setPWM(int channel, int on, int off) {
    writeCommand(LED0_ON_L  + 4 * channel, (byte)(on & 0xFF));
    writeCommand(LED0_ON_H  + 4 * channel, (byte)(on >> 8));
    writeCommand(LED0_OFF_L + 4 * channel, (byte)(off & 0xFF));
    writeCommand(LED0_OFF_H + 4 * channel, (byte)(off >> 8));
  }
    
  
  protected void setAllPWM(byte on, byte off) {
    writeCommand(ALL_LED_ON_L,  (byte)(on & 0xFF));
    writeCommand(ALL_LED_ON_H,  (byte)(on >> 8));
    writeCommand(ALL_LED_OFF_L, (byte)(off & 0xFF));
    writeCommand(ALL_LED_OFF_H, (byte)(off >> 8));
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
  
    byte readCommand(int arg1) {
    super.beginTransmission(address);    
    super.write(arg1);
    byte byteread = super.read(1)[0];
    super.endTransmission();
    return byteread;
  }
  
}