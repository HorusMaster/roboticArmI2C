
 float Hipotenusa, Afx, Afy, LadoA, LadoB, Alfa, Beta, Gamma, Modulo;
  
 int AlturaH=90, LongBrazo=103, LongAntBr=97, LongMunec=158, Cabeceo=-90;
  

class IK {
     
  
   float[] calculateAngles(float x, float y, float z) {
     float AngGiro=degrees(atan2(y, x));     
     Modulo=sqrt(abs(pow(x, 2))+abs(pow(y,2)));
     float XPrima=Modulo;
     float YPrima=z;      
     Afx=cos(radians(Cabeceo))*LongMunec;    
     LadoB=XPrima-Afx;     
     Afy=sin(radians(Cabeceo))*LongMunec;
     LadoA=YPrima-Afy-AlturaH;     
     float Hipotenusa=sqrt(abs(pow(LadoA, 2))+abs(pow(LadoB,2)));     
     Alfa=atan2(LadoA, LadoB);     
     Beta=acos ((pow(LongBrazo, 2)-pow(LongAntBr,2)+pow(Hipotenusa,2))/(2*LongBrazo*Hipotenusa));
     float AngBrazo = degrees(Alfa+Beta);     
     Gamma=degrees(acos ((pow(LongBrazo, 2)+pow(LongAntBr,2)-pow(Hipotenusa,2))/(2*LongBrazo*LongAntBr)));
     println("Gama: "+ Gamma);     
     float AngAntBr=((180)-Gamma);      
     float AngMunecA=(Cabeceo-AngBrazo-(-1*AngAntBr))*-1;           
     float  xyzVals[] = {AngGiro, AngBrazo, Gamma, AngMunecA};
     return xyzVals;      
   }  
  
}