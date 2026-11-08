with arms_and_legs;
with System;

package body readers_writers is

   protected control is
      pragma Priority (System.Default_Priority + 4); --ceiling priority

      entry Start_Read;
      procedure stop_Read;
      entry Start_Write;
      procedure stop_Write;
      procedure Read_Value (Value : out Arms_And_Legs.Directions);
      procedure Write_Value (Value : Arms_And_Legs.Directions);
   private
      readers           : Natural := 0;
      writers           : Boolean := False;
      Current_Direction : Arms_And_Legs.Directions := Arms_And_Legs.Forward;
   end control;

   procedure Read (Value : out Arms_And_Legs.Directions) is
   begin
      control.Start_Read;
      control.Read_Value (Value);
      control.stop_Read;
   end Read;

   procedure Write (Value : Arms_And_Legs.Directions) is
   begin
      control.Start_Write;
      control.Write_Value (Value);
      control.stop_Write;
   end Write;

   protected body control is
      procedure Read_Value (Value : out Arms_And_Legs.Directions) is
      begin
         Value := Current_Direction;
      end Read_Value;
      procedure Write_Value (Value : Arms_And_Legs.Directions) is
      begin
         Current_Direction := Value;
      end Write_Value;

      entry Start_Read when not Writers and Start_Write'Count = 0 is
      begin
         Readers := Readers + 1;
      end Start_Read;
      procedure stop_Read is
      begin
         Readers := Readers - 1;
      end stop_Read;
      entry Start_Write when not Writers and Readers = 0 is
      begin
         Writers := True;
      end Start_Write;
      procedure stop_Write is
      begin
         Writers := False;
      end stop_Write;
   end control;
end readers_writers;
