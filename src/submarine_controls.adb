with Ada.Text_IO; use Ada.Text_IO;
with Airlock; use Airlock;
with Torpedoes; use Torpedoes;
package body Submarine_Controls with SPARK_Mode is

   --==== Description ===--
   --each operation on the sea decreases the oxygen
   procedure decreaseOxygen is begin
      --if oxygen runs low warning must be shown
      if oxygenLevel <=  50 
      then 
         pragma Warnings (Off, "Put_Line");
        Put_Line("WARNING! Oxygen level is low!");
      end if;
      
      if oxygenLevel > Oxygen'First and airlockDoorsLocked = True 
      then
         oxygenLevel := oxygenLevel - 1;   
      else
         oxygenLevel := oxygenLevel;
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
      if reactorHeating = ReactorHeatLevel'Last 
      then
         currentDepth := 0; --submarine resurfaced
         oxygenLevel := Oxygen'Last; --oxygen is refilled
         reactorHeating := ReactorHeatLevel'First;
      else
         oxygenLevel := oxygenLevel;
         currentDepth := currentDepth;
      end if;      
   end checkReactorStatus;   
   
   
   procedure checkPressure is begin
      if airlockDoorsLocked = True 
        and
          currentPressure < Pressure'Last - 300
      then
         case currentDepth is
            when 0 .. 50 =>
               currentPressure := currentPressure + 10;
            when 51..300 =>
               currentPressure := currentPressure + 100;
            when 301..500 =>
                 currentPressure := currentPressure + 300;
            when others =>
                 currentPressure := Pressure'First;
         end case;                          
      end if;
   end checkPressure;
   
      
   
   
   procedure diveDeeper is begin
      if currentDepth < DepthLevel'Last
        and oxygenLevel > Oxygen'First 
        and airlockDoorsLocked = True 
        and reactorHeating < ReactorHeatLevel'Last 
        and currentPressure <= Pressure'Last - 10  
        and currentPressure < Pressure'Last - 300          
      then
         increaseDepth; 
         decreaseOxygen;--whether submarine can go deeper or not it will consume oxygen
         checkPressure;
      end if;
      checkOxygenStatus; --if oxygen run out sub will resurface
      checkReactorStatus; -- reactor overheated sub will resurface
   end diveDeeper;
   
   procedure riseUp is begin
      if currentDepth > DepthLevel'First  
        and oxygenLevel > Oxygen'First 
        and airlockDoorsLocked = True 
        and reactorHeating < ReactorHeatLevel'Last      
        and currentPressure < Pressure'Last - 300          
      then
         decreaseDepth;
         if currentDepth = DepthLevel'First --if rising up was to the surface oxygen is refilled
         then
            oxygenLevel := Oxygen'Last;
         else
            decreaseOxygen; --whether submarine can riseup or not it will consume oxygen
         end if;
         checkPressure;
      end if;
      checkOxygenStatus; --if oxygen run out sub will resurface
      checkReactorStatus; -- reactor overheated sub will resurface
   end riseUp;
   
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
        and reactorHeating < ReactorHeatLevel'Last   
      then
         currentDepth := currentDepth + 1;
         reactorHeating := reactorHeating + 1;
      end if;
      --checking oxygen and reactor status after each operation       
   end increaseDepth;
   
    procedure decreaseDepth is begin
      
      if currentDepth > DepthLevel'First  
        and oxygenLevel > Oxygen'First 
        and airlockDoorsLocked = True 
        and reactorHeating < ReactorHeatLevel'Last          
      then
         currentDepth := currentDepth - 1;  
         reactorHeating := reactorHeating + 1;
      else
         currentDepth := currentDepth;
      end if;
      --checking oxygen and reactor status after each operation       
   end decreaseDepth;
   
   
   
   

   --==== EXTENSIONS =====--
   --focusing on reactor overloading
   --increasing speed impacts reactor heating
   --firing torpedoes consumes reactor heating points
   -- cloacking impacts heating

   procedure increaseSpeed is begin
      if airlockDoorsLocked 
        and reactorHeating <= ReactorHeatLevel'Last -  10
        and currentSpeed < Speed'Last          
      then
         currentSpeed := currentSpeed + 1;
         reactorHeating := reactorHeating + 10;
      end if;
   end increaseSpeed;
   
   procedure decreaseSpeed is begin
      if airlockDoorsLocked 
        and reactorHeating < ReactorHeatLevel'Last
        and currentSpeed > Speed'First          
      then
         currentSpeed := currentSpeed - 1;
         reactorHeating := reactorHeating + 1;
      end if;
   end decreaseSpeed;
   
end Submarine_Controls;
