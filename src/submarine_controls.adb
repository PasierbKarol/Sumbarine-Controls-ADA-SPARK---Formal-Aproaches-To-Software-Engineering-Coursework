package body Submarine_Controls with SPARK_Mode is

  
   procedure closeInnerAirlock is begin
      if outerAirlockState = True then        
         innerAirlockState := True;      
      end if;      
   end closeInnerAirlock;
   
   procedure openInnerAirlock is begin
      if outerAirlockState = True and airlockDoorsLocked = False then
         innerAirlockState := False;     
      end if;      
   end openInnerAirlock;
   
   procedure closeOuterAirlock is begin
      if innerAirlockState = True then
         outerAirlockState := True;    
      end if;      
   end closeOuterAirlock;
   
   procedure openOuterAirlock is begin
      if innerAirlockState = True and airlockDoorsLocked = False then
         outerAirlockState := False;     
      end if;      
   end openOuterAirlock;
   
   procedure lockAirlockDoors is begin
      if innerAirlockState = True and outerAirlockState = True then
         airlockDoorsLocked := True;
      end if;      
   end lockAirlockDoors;
     
   
   
   
   
   
   function canOperateSubmarine (innerAirlockState : Boolean; 
                                 outerAirlockState : Boolean) 
                                 return Boolean is
   begin
      if innerAirlockState = True and outerAirlockState = True then      
        return True;
      end if;
      return False;  
   end canOperateSubmarine;
   
   function isOxygenLevelSafe(Oxygen : Integer) return Boolean is
   begin
      if Oxygen > 0 then
           return True;
      end if;
      return False;
   end isOxygenLevelSafe;
   



end Submarine_Controls;
