package Arms_And_Legs is

   type Directions is
     (Forward, Backward, Right, Left, Rotate_Right, Rotate_Left, Stop);

   procedure Drive (Direction : Directions);

end Arms_And_Legs;
