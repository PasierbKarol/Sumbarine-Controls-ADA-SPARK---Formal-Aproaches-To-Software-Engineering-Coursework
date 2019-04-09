with Airlock; use Airlock;
with Torpedoes; use Torpedoes;
package Submarine_Controls with SPARK_Mode is

   --Variables ======================================================
   --maximum possible level of oxygen, 0 is depleted
   type Oxygen is range 0..1000;
   oxygenLevel : Oxygen; 
   
   type DepthLevel is range 0..500;
   currentDepth : DepthLevel; 
   
   type ReactorHeatLevel is range 0..1000;
   reactorHeating : ReactorHeatLevel;

   type Speed is range 0..100;
   currentSpeed : Speed;
   
   type Pressure is range 0..1000;
   currentPressure : Pressure;
      
   --Contracts =======================================================

   --oxygen is decreased 1 point while the submarine is submerged
   --it can happen only if the airlock is locked and there is still any oxygen left
   --decreasing oxygen below 50 points shows a warning
   procedure decreaseOxygen with
     Global => (Input => airlockDoorsLocked, In_Out => oxygenLevel),
     Pre => airlockDoorsLocked = True and then
            oxygenLevel > Oxygen'First,
     Post => oxygenLevel = oxygenLevel'Old - 1 or 
             oxygenLevel = oxygenLevel'Old;
   
 
   procedure checkOxygenStatus with 
     Global => (Input => airlockDoorsLocked, 
                In_Out => (oxygenLevel, currentDepth)),
     Pre =>  oxygenLevel >= Oxygen'First,
     Post =>  oxygenLevel = oxygenLevel'Old or 
              oxygenLevel = Oxygen'Last;
    
   procedure checkReactorStatus;
   
   
   procedure checkPressure with
     Global => (Input => (currentDepth, airlockDoorsLocked), In_Out => currentPressure),
     Pre => airlockDoorsLocked = True and
            currentPressure < Pressure'Last - 300,
     Post => airlockDoorsLocked = True and 
             currentPressure /= currentPressure'Old;
   
   procedure diveDeeper;
   
   procedure riseUp;
   
   --submerge submarine
   --cannot be done if there is no oxygen left
   --diving or surfacing reduces oxygen
   procedure increaseDepth with
     Global =>(Input => (airlockDoorsLocked, oxygenLevel), 
               In_Out => (currentDepth, reactorHeating)),
     Pre => airlockDoorsLocked = True and then 
            oxygenLevel > Oxygen'First and then
            currentDepth < DepthLevel'Last and then
            reactorHeating < ReactorHeatLevel'Last,
     Post => 
       airlockDoorsLocked = True and 
       (currentDepth = currentDepth'Old + 1 or  
       currentDepth = currentDepth'Old) and 
       reactorHeating = reactorHeating'Old + 1;
   
   --the same purpose as above, just opposite
   procedure decreaseDepth with
     Global =>(Input => (airlockDoorsLocked, oxygenLevel), 
               In_Out => (currentDepth, reactorHeating)),
     Pre => airlockDoorsLocked = True and 
            currentDepth > DepthLevel'First and 
            oxygenLevel > Oxygen'First and
            reactorHeating < ReactorHeatLevel'Last,
     Post => 
       airlockDoorsLocked = True and  
       (currentDepth = currentDepth'Old - 1 or  
       currentDepth = currentDepth'Old);

  
     
   procedure increaseSpeed with
     Global => (In_Out => (reactorHeating, currentSpeed), Input => airlockDoorsLocked),
     Pre => airlockDoorsLocked = True and 
            reactorHeating <= ReactorHeatLevel'Last - 10 and
            currentSpeed < Speed'Last,
     Post => airlockDoorsLocked = True and
             reactorHeating = reactorHeating'Old + 10 and
             currentSpeed = currentSpeed'Old + 1;
   
   procedure decreaseSpeed with
     Global => (In_Out => (reactorHeating, currentSpeed), Input => airlockDoorsLocked),
     Pre => airlockDoorsLocked = True and
            reactorHeating < ReactorHeatLevel'Last and 
            currentSpeed > Speed'First,
     Post => airlockDoorsLocked = True and
            currentSpeed = currentSpeed'Old - 1 and 
            reactorHeating = reactorHeating'Old + 1;
   
   
     
end Submarine_Controls;
