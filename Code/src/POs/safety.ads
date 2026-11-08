with System;

package body safety is

   task Safety_task is
      pragma Priority (System.Default_Priority + 4);
   end Safety_task;