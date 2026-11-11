with System;

package Arms_And_Legs is

   type Directions is
     (Forward, Backward, Right, Left, Rotate_Right, Rotate_Left, Stop);

   procedure Drive (Direction : Directions);

   task Act_Task is
      pragma Priority (System.Default_Priority + 3);
   end Act_Task;

end Arms_And_Legs;
