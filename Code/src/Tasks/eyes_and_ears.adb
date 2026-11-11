with MicroBit;
with MicroBit.Console;
with MicroBit.Types;
with MicroBit.Ultrasonic;
with System;

with Ada.Real_Time; use Ada.Real_Time;

package body Eyes_And_Ears is

   package Sensor1 is new MicroBit.Ultrasonic (MicroBit.MB_P14, MicroBit.MB_P0);
   package Sensor2 is new MicroBit.Ultrasonic (MicroBit.MB_P15, MicroBit.MB_P12);
   package Sensor3 is new MicroBit.Ultrasonic (MicroBit.MB_P1, MicroBit.MB_P2);
   package Sensor4 is new MicroBit.Ultrasonic (MicroBit.MB_P16, MicroBit.MB_P13);

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

   -- checks if sensor readings update, keeps track of last time each sensor was updated
   protected Sensor_Timestamps is
      pragma
        Priority
          (System.Default_Priority
           + 4); --ceiling priority as its used in Safety task

      procedure Update_FR;
      procedure Update_FL;
      procedure Update_R;
      procedure Update_L;
      function Too_Old return Boolean;

   private
      Last_FR : Time := Clock;
      Last_FL : Time := Clock;
      Last_R  : Time := Clock;
      Last_L  : Time := Clock;

      FR_Updated : Boolean := False;
      FL_Updated : Boolean := False;
      R_Updated  : Boolean := False;
      L_Updated  : Boolean := False;
   end Sensor_Timestamps;

   protected body Sensor_Timestamps is

      procedure Update_FR is
      begin
         Last_FR := Clock;
         FR_Updated := True;
      end Update_FR;

      procedure Update_FL is
      begin
         Last_FL := Clock;
         FL_Updated := True;
      end Update_FL;

      procedure Update_R is
      begin
         Last_R := Clock;
         R_Updated := True;
      end Update_R;

      procedure Update_L is
      begin
         Last_L := Clock;
         L_Updated := True;
      end Update_L;

      function Too_Old return Boolean is
         Now     : constant Time := Clock;
         Max_Age : constant Time_Span := Milliseconds (300);
      begin
         return
           --Checks if updated ever
           not FR_Updated
           or else not FL_Updated
           or else not R_Updated
           or else not L_Updated

           or else (Now - Last_FR > Max_Age)
           or else (Now - Last_FL > Max_Age)
           or else (Now - Last_R > Max_Age)
           or else (Now - Last_L > Max_Age);
      end Too_Old;

   end Sensor_Timestamps;

   function Sensors_Too_Old return Boolean is
   begin
      return Sensor_Timestamps.Too_Old;
   end Sensors_Too_Old;

      task body Sense_Task is
      Next_Release : Time := Clock;
      Period       : constant Time_Span := Milliseconds (100);
   begin
      loop
         begin
            Distance_FR := Sensor1.Read;
            Sensor_Timestamps.Update_FR;
            Distance_FL := Sensor2.Read;
            Sensor_Timestamps.Update_FL;
        
            Distance_R := Sensor3.Read;
            Sensor_Timestamps.Update_R;
        
            Distance_L := Sensor4.Read;
            Sensor_Timestamps.Update_L;
         exception
            when others =>
               MicroBit.Console.Put_Line ("Sense exception!");
         end;
         
         Next_Release := Next_Release + Period;
         delay until Next_Release;
      end loop;
   end Sense_Task;

end Eyes_And_Ears;
