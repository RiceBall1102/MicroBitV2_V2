with MicroBit.Types;
with System;

package Eyes_And_Ears is

   task Sense_Task is
      pragma Priority (System.Default_Priority + 1);
   end Sense_Task;

   function Front_Right_Distance return MicroBit.Types.Distance_cm;
   function Front_Left_Distance return MicroBit.Types.Distance_cm;
   function Right_Distance return MicroBit.Types.Distance_cm;
   function Left_Distance return MicroBit.Types.Distance_cm;
   function Sensors_Too_Old return Boolean;

end Eyes_And_Ears;
