class PCA9685 extends I2C {  
    
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
           
    int address;
    
    PCA9685(String dev, int address) {
    super(dev);    
    this.address = address;
    println("Adress Driver PCA9685: "+ address);   
    writeCommand(MODE1, (byte)0x00); 
    init();    
    }   
    
    public void init(){
    writeCommand((byte)ALL_LED_ON_L,  (byte)(0 & 0xFF));
    writeCommand((byte)ALL_LED_ON_H,  (byte)(0 >> 8));
    writeCommand((byte)ALL_LED_OFF_L, (byte)(0 & 0xFF));
    writeCommand((byte)ALL_LED_OFF_H, (byte)(0 >> 8));  
    //println("INICIO ALL PWM");
      }
  
  public void setPWMFreq(int freq){
    
    float preScaleVal = 25000000.0;
    preScaleVal /= 4096.0;
    preScaleVal /= (float)freq;
    preScaleVal -=1.0;
    int preScale = (int)Math.floor(preScaleVal +0.5);    
    int oldmode = (byte) readCommand(MODE1);    
    int newmode = (byte) ((oldmode & 0x7F) | 0x10);       
    writeCommand(MODE1, newmode);   
    writeCommand(PRESCALE, (byte)(Math.floor(preScale)));
    writeCommand(MODE1, oldmode);
    delay(5);
    writeCommand(MODE1, (byte) (oldmode | 0x80));        
  }
  
    
   public void setPWM(int channel, int on, int off) {     
    writeCommand(LED0_ON_L  + 4 * channel, (byte)(on & 0xFF));
    writeCommand(LED0_ON_H  + 4 * channel, (byte)(on >> 8));
    writeCommand(LED0_OFF_L + 4 * channel, (byte)(off & 0xFF));
    writeCommand(LED0_OFF_H + 4 * channel, (byte)(off >> 8));
  }
    
    

  protected void writeCommand(int arg1) {
    super.beginTransmission(this.address);    
    super.write(arg1);
    super.endTransmission();
  }

  protected void writeCommand(int arg1, int arg2) {
    super.beginTransmission(this.address); 
    super.write(arg1);
    super.write(arg2);
    super.endTransmission();
  }
 
    byte readCommand(int arg1) {
    super.beginTransmission(this.address);    
    super.write(arg1);
    byte byteread = super.read(1)[0];
    super.endTransmission();
    return byteread;
  }
  
}