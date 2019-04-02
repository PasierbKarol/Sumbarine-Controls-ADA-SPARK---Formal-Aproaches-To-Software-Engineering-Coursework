package Submarine_Controls is

   function isAtLeastOneAirlockLocked (airlock1Locked : Boolean; 
                                       airlock2Locked : Boolean) 
                                       return Boolean with
     Pre => airlock1Locked = True or airlock1Locked = True,
   Post => airlock1Locked = True or airlock1Locked = True;

   function canOperateSubmarine (airlock1Locked : Boolean; 
                                 airlock2Locked : Boolean) 
                                 return Boolean with
     Pre => airlock1Locked = True and airlock1Locked = True,
     Post => airlock1Locked = True and airlock1Locked = True;
   
   function isOxygenLevelSafe(Oxygen : Integer) return Boolean with
     Pre => Oxygen > Integer'First,
       Post => Oxygen > 0;

   
end Submarine_Controls;
