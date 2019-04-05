package body Submarine_Controls with SPARK_Mode is

  
   procedure closeInnerAirlock is      
   begin
      if outerAirlockState = True then        
         innerAirlockState := True;      
      end if;      
   end closeInnerAirlock;
   
   procedure openInnerAirlock is      
   begin
      if outerAirlockState = True then
         innerAirlockState := False;     
      end if;      
   end openInnerAirlock;
   
   procedure closeOuterAirlock is      
   begin
      outerAirlockState := True;    
   end closeOuterAirlock;
   
   procedure openOuterAirlock is      
   begin
      if innerAirlockState = True then
         outerAirlockState := False;     
      end if;      
   end openOuterAirlock;
   
   
   
   
   
   
   
   function canOperateSubmarine (innerAirlockState : AirlockState; 
                                 outerAirlockState : AirlockState) 
                                 return AirlockState is
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
