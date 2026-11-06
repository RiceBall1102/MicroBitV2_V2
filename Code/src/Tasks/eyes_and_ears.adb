with MicroBit;
with MicroBit.Console;
with MicroBit.Types;
with MicroBit.Ultrasonic;

package body Eyes_And_Ears is

   package Sensor1 is new MicroBit.Ultrasonic
     (MicroBit.MB_P14, MicroBit.MB_P0);
   package Sensor2 is new MicroBit.Ultrasonic
     (MicroBit.MB_P15, MicroBit.MB_P12);
   package Sensor3 is new MicroBit.Ultrasonic
     (MicroBit.MB_P1, MicroBit.MB_P2);
   package Sensor4 is new MicroBit.Ultrasonic
     (MicroBit.MB_P16, MicroBit.MB_P13);

   Distance_FR : MicroBit.Types.Distance_cm := 0;
   Distance_FL : MicroBit.Types.Distance_cm := 0;
   Distance_R  : MicroBit.Types.Distance_cm := 0;
   Distance_L  : MicroBit.Types.Distance_cm := 0;
 

function Front_Right_Distance return MicroBit.Types.Distance_cm is
   begin
      return Distance_FR;
   end Front_Right_Distance;

   function Front_Left_Distance return MicroBit.Types.Distance_cm is
   begin
      return Distance_FL;
   end Front_Left_Distance;

   function Right_Distance return MicroBit.Types.Distance_cm is
   begin
      return Distance_R;
   end Right_Distance;

   function Left_Distance return MicroBit.Types.Distance_cm is
   begin
      return Distance_L;
   end Left_Distance;


task body Sense_Task is
   begin
      loop
         MicroBit.Console.Put_Line ("");

         Distance_FR := Sensor1.Read;
         MicroBit.Console.Put_Line ("FR: " & Distance_FR'Image);

         Distance_FL := Sensor2.Read;
         MicroBit.Console.Put_Line ("FL: " & Distance_FL'Image);
         
         Distance_R := Sensor3.Read;
         MicroBit.Console.Put_Line ("R: " & Distance_R'Image);
         
         Distance_L := Sensor4.Read;
         MicroBit.Console.Put_Line ("L: " & Distance_L'Image);

         delay 0.05;
      end loop;
   end Sense_Task;

   
end Eyes_And_Ears;