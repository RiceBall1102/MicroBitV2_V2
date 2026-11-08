with System;

package Brain is

   task Think_Task is
      pragma Priority (System.Default_Priority + 2);
   end Think_Task;

   task Act_Task is
      pragma Priority (System.Default_Priority + 3);
   end Act_Task;

end Brain;
