with System;

package Brain is

   task Think_Task is
      pragma Priority (System.Default_Priority + 2);
   end Think_Task;

end Brain;
