with Ada.Real_Time;
with MicroBit.Types;
with Eyes_And_Ears;
with Arms_And_Legs;
with Readers_Writers;


package body Brain is

   use type Ada.Real_Time.Time;

   function Check_Distance
     (Distance : MicroBit.Types.Distance_cm) return Boolean is
      use type MicroBit.Types.Distance_cm;
   begin
      return Distance > 0 and Distance < 10;
   end Check_Distance;

   procedure Think is
      Direction : Arms_And_Legs.Directions;
      Front_Right_Collision : constant Boolean := Check_Distance (Eyes_And_Ears.Front_Right_Distance);
      Front_Left_Collision : constant Boolean := Check_Distance (Eyes_And_Ears.Front_Left_Distance);
      Right_Collision : constant Boolean := Check_Distance (Eyes_And_Ears.Right_Distance);
      Left_Collision : constant Boolean := Check_Distance (Eyes_And_Ears.Left_Distance);
   begin
      if Front_Left_Collision and Front_Right_Collision then
         if not Left_Collision and Right_Collision then
            Direction := Arms_And_Legs.Rotate_Left;
         elsif not Right_Collision and Left_Collision then
            Direction := Arms_And_Legs.Rotate_Right;
         elsif not Left_Collision and not Right_Collision then
            Direction := Arms_And_Legs.Rotate_Right;
         else
         -- Boxed in
            Direction := Arms_And_Legs.Backward;
      end if;
      elsif Front_Right_Collision then
         Direction := Arms_And_Legs.Rotate_Left;
      elsif Front_Left_Collision then
         Direction := Arms_And_Legs.Rotate_Right;
      elsif Right_Collision then
         Direction := Arms_And_Legs.Left;
      elsif Left_Collision then
         Direction := Arms_And_Legs.Right;
      else
         Direction := Arms_And_Legs.Forward;
      end if;
         Readers_Writers.Write (Direction);
   end Think;

   task body Think_Task is
      My_Clock : Ada.Real_Time.Time;
   begin
      loop
         My_Clock := Ada.Real_Time.Clock;
         Think;
         delay until My_Clock + Ada.Real_Time.Milliseconds (100);
      end loop;
   end Think_Task;

   task body Act_Task is
      My_Clock : Ada.Real_Time.Time;
   begin
      loop
         My_Clock := Ada.Real_Time.Clock;
         declare
            Direction : Arms_And_Legs.Directions;
            begin
               Readers_Writers.Read (Direction);
               Arms_And_Legs.Drive (Direction);
            end;
         delay until My_Clock + Ada.Real_Time.Milliseconds (40);
      end loop;
   end Act_Task;

end Brain;
