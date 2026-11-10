with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Types;
with Eyes_And_Ears;
with Arms_And_Legs;
with Readers_Writers;

package body Brain is

   use type Ada.Real_Time.Time;

   function Check_Distance
     (Distance : MicroBit.Types.Distance_cm) return Boolean
   is
      use type MicroBit.Types.Distance_cm;
   begin
      return Distance > 0 and Distance < 10;
   end Check_Distance;

   procedure Think is
      Direction             : Arms_And_Legs.Directions;
      Front_Right_Collision : constant Boolean :=
        Check_Distance (Eyes_And_Ears.Front_Right_Distance);
      Front_Left_Collision  : constant Boolean :=
        Check_Distance (Eyes_And_Ears.Front_Left_Distance);
      Right_Collision       : constant Boolean :=
        Check_Distance (Eyes_And_Ears.Right_Distance);
      Left_Collision        : constant Boolean :=
        Check_Distance (Eyes_And_Ears.Left_Distance);
   begin
      if Front_Left_Collision and Front_Right_Collision then
         if Left_Collision and Right_Collision then
            Direction := Arms_And_Legs.Backward;
         elsif Left_Collision then
            Direction := Arms_And_Legs.Rotate_Right;
         elsif Right_Collision then
            Direction := Arms_And_Legs.Rotate_Left;
         else
            Direction := Arms_And_Legs.Rotate_Right;
         end if;
      elsif Left_Collision and Right_Collision then
         Direction := Arms_And_Legs.Forward;
      elsif Front_Left_Collision then
         Direction := Arms_And_Legs.Rotate_Right;
      elsif Front_Right_Collision then
         Direction := Arms_And_Legs.Rotate_Left;
      elsif Left_Collision then
         Direction := Arms_And_Legs.Right;
      elsif Right_Collision then
         Direction := Arms_And_Legs.Left;
      else
         Direction := Arms_And_Legs.Forward;
      end if;
      Readers_Writers.Write (Direction);
   end Think;

   task body Think_Task is
      Next_Release : Time := Clock;
      Period       : constant Time_Span := Milliseconds (50);
   begin
      loop
         Think;

         Next_Release := Next_Release + Period;
         delay until Next_Release;
      end loop;
   end Think_Task;

   task body Act_Task is
      Next_Release : Time := Clock;
      Period       : constant Time_Span := Milliseconds (40);

      --RTA test
      Start_Time       : Time;
      End_Time         : Time;
      Elapsed          : Time_Span;
      Max_Elapsed      : Time_Span := Milliseconds (0);
      Missed_Deadlines : Integer := 0;
      it               : Integer := 0;

   begin
      loop

         declare
            Direction : Arms_And_Legs.Directions;
            Start_Time := Clock; --RTA test
         begin

            Readers_Writers.Read (Direction);
            Arms_And_Legs.Drive (Direction);
            End_Time := Clock; --RTA test
         end;


         Next_Release := Next_Release + Period;
         
         Elapsed := End_Time - Start_Time; --RTA test

   

         if End_time > Next_Release then
            --RTA test
            Missed_Deadlines := Missed_Deadlines + 1; --RTA test

         end if; --RTA test

         if Elapsed > Max_Elapsed then
            --RTA test
            Max_Elapsed := Elapsed; --RTA test

         end if; --RTA test

         it := it + 1; --RTA test
         if it = 100 then
            --RTA test
            MicroBit.Console.Put_Line
              ("Max Elapsed Time: " & Time_Span'Image (Max_Elapsed));
            MicroBit.Console.Put_Line
              ("Missed Deadlines: " & Integer'Image (Missed_Deadlines));
            it := 0; --RTA test

         end if; --RTA test
         delay until Next_Release;
      end loop;
   end Act_Task;

end Brain;
