with Ada.Real_Time;
with MicroBit.Types;
with Eyes_And_Ears;
with Arms_And_Legs;

package body Brain is

   use type Ada.Real_Time.Time;

   protected Direction_State is
      procedure Write (Direction : Arms_And_Legs.Directions);
      function Read return Arms_And_Legs.Directions;
   private
      Current_Direction : Arms_And_Legs.Directions := Arms_And_Legs.Stop;
   end Direction_State;

   protected body Direction_State is
      procedure Write (Direction : Arms_And_Legs.Directions) is
      begin
         Current_Direction := Direction;
      end Write;

      function Read return Arms_And_Legs.Directions is
      begin
         return Current_Direction;
      end Read;
   end Direction_State;

   function Check_Distance
     (Distance : MicroBit.Types.Distance_cm) return Boolean is
      use type MicroBit.Types.Distance_cm;
   begin
      return Distance > 0 and Distance < 10;
   end Check_Distance;

   procedure Think is
      Direction : Arms_And_Legs.Directions;
      Front_Right_Collision : constant Boolean :=
        Check_Distance (Eyes_And_Ears.Front_Right_Distance);
      Front_Left_Collision : constant Boolean :=
        Check_Distance (Eyes_And_Ears.Front_Left_Distance);
      Right_Collision : constant Boolean :=
        Check_Distance (Eyes_And_Ears.Right_Distance);
      Left_Collision : constant Boolean :=
        Check_Distance (Eyes_And_Ears.Left_Distance);
   begin
      if Front_Right_Collision or Front_Left_Collision then
         if Front_Right_Collision then
            Direction := Arms_And_Legs.Rotate_Left;
         else
            Direction := Arms_And_Legs.Rotate_Right;
         end if;
      elsif Right_Collision then
         Direction := Arms_And_Legs.Left;
      elsif Left_Collision then
         Direction := Arms_And_Legs.Right;
      else
         Direction := Arms_And_Legs.Forward;
      end if;

      Direction_State.Write (Direction);
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
         Arms_And_Legs.Drive (Direction_State.Read);
         delay until My_Clock + Ada.Real_Time.Milliseconds (40);
      end loop;
   end Act_Task;

end Brain;
