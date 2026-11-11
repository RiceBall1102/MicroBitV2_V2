with MicroBit.MotorDriver;
with Readers_Writers;
with Ada.Real_Time; use Ada.Real_Time;

package body Arms_And_Legs is

   Motor_Speed : constant := 2000;

   procedure Move_Forward is
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Forward,
         (Motor_Speed, Motor_Speed, Motor_Speed, Motor_Speed));
   end Move_Forward;

   procedure Move_Backward is
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Backward,
         (Motor_Speed, Motor_Speed, Motor_Speed, Motor_Speed));
   end Move_Backward;

   procedure Move_Right is
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Right,
         (Motor_Speed, Motor_Speed, Motor_Speed, Motor_Speed));
   end Move_Right;

   procedure Move_Left is
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Left,
         (Motor_Speed, Motor_Speed, Motor_Speed, Motor_Speed));
   end Move_Left;

   procedure Move_Rotate_Right is
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Rotating_Right,
         (Motor_Speed, Motor_Speed, Motor_Speed, Motor_Speed));
   end Move_Rotate_Right;

   procedure Move_Rotate_Left is
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Rotating_Left,
         (Motor_Speed, Motor_Speed, Motor_Speed, Motor_Speed));
   end Move_Rotate_Left;

   procedure Move_Stop is
   begin
      MicroBit.MotorDriver.Drive (MicroBit.MotorDriver.Stop);
   end Move_Stop;

   procedure Drive (Direction : Directions) is
   begin
      case Direction is
         when Forward      =>
            Move_Forward;

         when Backward     =>
            Move_Backward;

         when Right        =>
            Move_Right;

         when Left         =>
            Move_Left;

         when Rotate_Right =>
            Move_Rotate_Right;

         when Rotate_Left  =>
            Move_Rotate_Left;

         when Stop         =>
            Move_Stop;
      end case;
   end Drive;

   task body Act_Task is
      Next_Release : Time := Clock;
      Period       : constant Time_Span := Milliseconds (40);

   begin
      loop

         declare
            Direction : Directions;
         begin
            Readers_Writers.Read (Direction);
            Drive (Direction);
         end;

         Next_Release := Next_Release + Period;
         delay until Next_Release;
      end loop;
   end Act_Task;

end Arms_And_Legs;
