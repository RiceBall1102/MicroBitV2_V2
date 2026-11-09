with Ada.Real_Time; use Ada.Real_Time;
with eyes_and_ears;
with Readers_Writers;

package body Safety is
--Checks if all sensor readings update every 300ms, if not: stop car

task Safety_task is 
   Next_Release : Time := Clock;
   Period       : constant Time_Span := Milliseconds (20);
begin
   loop
      if eyes_and_ears.Sensors_Too_Old then
         Readers_Writers.Write (Arms_And_Legs.Stop);
      else Readers_Writers.Write (Arms_And_Legs.Forward);
      end if;

      Next_Release := Next_Release + Period;
      delay until Next_Release;
   end loop;
end Safety_task;

end Safety;