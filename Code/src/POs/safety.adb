with Ada.Real_Time; use Ada.Real_Time;
with eyes_and_ears;
with Readers_Writers;
with MicroBit.Console;

package body Safety is
   --Checks if all sensor readings update every 300ms, if not: stop car

   task body Safety_task is
      Next_Release : Time := Clock;
      Period       : constant Time_Span := Milliseconds (20);

   begin
      loop
         Readers_Writers.Set_Safety_Stop (Eyes_And_Ears.Sensors_Too_Old);

         Next_Release := Next_Release + Period;
         delay until Next_Release;
      end loop;
   end Safety_task;

end Safety;
