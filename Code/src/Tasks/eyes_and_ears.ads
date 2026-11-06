with MicroBit.Types;

package Eyes_And_Ears is

   task Sense_Task;

   function Front_Right_Distance return MicroBit.Types.Distance_cm;
   function Front_Left_Distance return MicroBit.Types.Distance_cm;
   function Right_Distance return MicroBit.Types.Distance_cm;
   function Left_Distance return MicroBit.Types.Distance_cm;

end Eyes_And_Ears;