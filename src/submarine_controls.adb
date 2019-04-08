     with Ada.Text_IO; use Ada.Text_IO;
package body Submarine_Controls with SPARK_Mode is

   --Airlock procedures ===============================================================
   --==== Description ===--
   --following procedures ensure that at least one airlock door must be closed at all times
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
   
   --==== Description ===--
   --this procedure ensures that airlock can be locked only when both airlock doors are closed
   --every sea operation is checked against this status
   procedure lockAirlockDoors is begin
      if innerAirlockState = True and outerAirlockState = True then
         airlockDoorsLocked := True;
      end if;      
   end lockAirlockDoors;
    
   --==== Description ===--
   --each operation on the sea decreases the oxygen
   procedure decreaseOxygen is begin
      --if oxygen is running low the warning is shown
--        if oxygenLevel <= 500 then
--           displayOxygenWarning;
--        end if;
      
      if oxygenLevel > Oxygen'First and airlockDoorsLocked = True 
      then
         oxygenLevel := oxygenLevel - 1;   
      else
         oxygenLevel := oxygenLevel;
      end if;    
      
      --if oxygen runs low warning must be shown
      if oxygenLevel <=  50 
      then 
         pragma Warnings (Off, "Put_Line");
        Put_Line("WARNING! Oxygen level is low!");
      end if;
   end decreaseOxygen;

   
   --==== Description ===--
   --if decreasing oxygen lead to the point when it's 0 submarine has to resurface
   --therefore depth goes back to initial level
   procedure checkOxygenStatus is begin      
      --if oxygenLevel = 0 and currentDepth <= maximumDepth and currentDepth >= 0 then
      if oxygenLevel = 0 and airlockDoorsLocked = True 
      then
         --if oxygen runs out submarine has to resurface
         currentDepth := DepthLevel'First; --submarine resurfaced
         oxygenLevel := Oxygen'Last; --oxygen is refilled
      else
         oxygenLevel := oxygenLevel;
         currentDepth := currentDepth;
      end if;   
   end checkOxygenStatus;
     
   --==== Description ===--
   --if reactor is overheating submarine has to resurface
   procedure checkReactorStatus is begin
      if isReactorOverheated = True 
      then
         currentDepth := 0; --submarine resurfaced
         oxygenLevel := Oxygen'Last; --oxygen is refilled
      else
         oxygenLevel := oxygenLevel;
      end if;      
   end checkReactorStatus;   
   
   

   
--     procedure diveDeeper is begin
--        increaseDepth;
--        checkOxygenAndReactorStatus;
--     end diveDeeper;
   
   --Depth procedures ========================================================
   --==== Description ===--
   --increasing depth by 100 point at each operation, 0 is on surface, 5000 is maximum
   --altering depth consumes oxygen
   --submarine can go deeper only if current depth is at least 100 points less than maximum
   --if submarine reaches maximum depth it cannot go lower
   --therefore current depth must be always at least 100 point less than the maximum
   procedure increaseDepth is begin
      
      if currentDepth < DepthLevel'Last
        and oxygenLevel > Oxygen'First 
        and airlockDoorsLocked = True 
      then
         currentDepth := currentDepth + 1;
         --decreaseOxygen; --calling decrease oxygen
      else
         currentDepth := currentDepth;
      end if;
      --checking oxygen and reactor status after each operation       
   end increaseDepth;
   
    procedure decreaseDepth is begin
      
      if currentDepth < DepthLevel'Last  
        and oxygenLevel > Oxygen'First 
        and airlockDoorsLocked = True 
      then
         currentDepth := currentDepth - 1;
         --decreaseOxygen; --calling decrease oxygen
      else
         currentDepth := currentDepth;
      end if;
      --checking oxygen and reactor status after each operation       
   end decreaseDepth;
   
   
   --======== Torpedoes ======
   --torpedoes can be stored while on surface
   procedure storeTorpedo is begin
      if storedTorpedoes < Torpedoes'Last then
         storedTorpedoes := storedTorpedoes + 1;
      end if;
   end storeTorpedo;   
   
   --cannot load torpedo if submarine doors are unlocked
   procedure loadTorpedo is begin
      if loadedTorpedoes < TorpedoesLoaded'Last 
        and storedTorpedoes > Torpedoes'First
        and airlockDoorsLocked = True then
         loadedTorpedoes := loadedTorpedoes + 1;
         storedTorpedoes := storedTorpedoes - 1;
      end if;
   end loadTorpedo;
   
   --cannot fire torpedo if submarine doors are unlocked
   procedure fireTorpedo is begin
      if loadedTorpedoes > TorpedoesLoaded'First
        and airlockDoorsLocked = True 
      then
         loadedTorpedoes := loadedTorpedoes - 1;
      end if;
   end fireTorpedo;
   



end Submarine_Controls;
