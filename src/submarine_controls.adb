package body Submarine_Controls is

  --airlock1Locked : Boolean := False;
  --airlock2Locked  : Boolean := False;
   
   
   function isAtLeastOneAirlockLocked (airlock1Locked : Boolean; airlock2Locked : Boolean) return Boolean is
   begin
      if airlock1Locked = True or airlock2Locked = True then      
        return True;
      end if;
      return False;              
   end isAtLeastOneAirlockLocked;
   
   function canOperateSubmarine (airlock1Locked : Boolean; airlock2Locked : Boolean) return Boolean is
   begin
      if airlock1Locked = True and airlock2Locked = True then      
        return True;
      end if;
      return False;  
   end canOperateSubmarine;
   
   function isOxygenLevelSafe(Oxygen : Integer) return Boolean
   begin
      if Oxygen > 0 then
           return True;
      end if;
      return False;
   end isOxygenLevelSafe;
   



end Submarine_Controls;
