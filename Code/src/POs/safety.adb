with Ada.Real_Time; use Ada.Real_Time;
with eyes_and_ears;
with Readers_Writers;
with MicroBit.Console;

package body Safety is
   --Checks if all sensor readings update every 300ms, if not: stop car

   task body Safety_task is
      Next_Release : Time := Clock;
      Period       : constant Time_Span := Milliseconds (20);

      Start_Time       : Time; --RTA test
      End_Time         : Time; --RTA test
      Elapsed          : Time_Span; --RTA test
      Max_Elapsed      : Time_Span := Milliseconds (0); --RTA test
      Missed_Deadlines : Integer := 0; --RTA test
      it               : Integer := 0; --RTA test
   begin
      loop
         Start_Time := Clock; --RTA test
         Readers_Writers.Set_Safety_Stop (Eyes_And_Ears.Sensors_Too_Old);
         End_Time := Clock; --RTA test
         Elapsed := End_Time - Start_Time; --RTA test

         Next_Release := Next_Release + Period;

         if End_time > Next_Release then
            Missed_Deadlines := Missed_Deadlines + 1;
         end if;
         if Elapsed > Max_Elapsed then
            Max_Elapsed := Elapsed;
         end if;
         it := it + 1;
         if it = 100 then
            MicroBit.Console.Put_Line
              ("Max Elapsed Time: " & Time_Span'Image (Max_Elapsed));
            MicroBit.Console.Put_Line
              ("Missed Deadlines: " & Integer'Image (Missed_Deadlines));
            it := 0;
         end if;

         delay until Next_Release;
      end loop;
   end Safety_task;

end Safety;
