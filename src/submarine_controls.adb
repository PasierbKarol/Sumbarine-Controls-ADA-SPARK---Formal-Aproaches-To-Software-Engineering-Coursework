     with Ada.Text_IO; use Ada.Text_IO;
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
     
   procedure decreaseOxygen is begin
      --if oxygen is running low the warning is shown
      if oxygenLevel <= 500 then
         Put_Line("WARNING! Oxygen level is low!");
      end if;
      
      if oxygenLevel >= 100 and airlockDoorsLocked = True and submarineSubmerged = True then
         oxygenLevel := oxygenLevel - 100;
      end if;      
   end decreaseOxygen;
   
   
   
   
   
   function canOperateSubmarine (innerAirlockState : Boolean; 
                                 outerAirlockState : Boolean) 
                                 return Boolean is
   begin
      if innerAirlockState = True and outerAirlockState = True then      
        return True;
      end if;
      return False;  
   end canOperateSubmarine;
   
   



end Submarine_Controls;
