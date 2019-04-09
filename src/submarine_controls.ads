package Submarine_Controls with SPARK_Mode is

   --Variables ======================================================
   innerAirlockState : Boolean; --True closed, False open
   outerAirlockState : Boolean; --True closed, False open
   airlockDoorsLocked : Boolean; --True no doors can be opened
   
   --maximum possible level of oxygen, 0 is depleted
   type Oxygen is range 0..1000;
   oxygenLevel : Oxygen; 
   
   type DepthLevel is range 0..500;
   currentDepth : DepthLevel; 
   
   --reactorOverheatThreshold : constant Integer := 12000;
   type ReactorHeatLevel is range 0..1000;
   reactorHeating : ReactorHeatLevel;
   type Speed is range 0..100;
   currentSpeed : Speed;
   
   --how many torpedoes can be stored on the boat
   type Torpedoes is range 0..20;
   storedTorpedoes : Torpedoes;

   --how many torpedoes can be loaded for firing
   type TorpedoesLoaded is range 0..6;
   loadedTorpedoes : TorpedoesLoaded;
   
   
   --Contracts =======================================================
   
   --at least one airlock door closed at all times
   --procedures below ensure that at least one airlock door is closed at all times
   procedure closeInnerAirlock  with
     Global => (In_Out => innerAirlockState, Input => outerAirlockState),
     Pre => outerAirlockState = True,
     Post => innerAirlockState = True and outerAirlockState = True;
   
   procedure openInnerAirlock  with
     Global => (In_Out => innerAirlockState, 
                Input => (outerAirlockState, airlockDoorsLocked)),
     Pre => airlockDoorsLocked = False and 
            outerAirlockState = True and innerAirlockState = True,
     Post => innerAirlockState = False and outerAirlockState = True;
   
   procedure closeOuterAirlock  with
     Global => (In_Out => outerAirlockState, Input => innerAirlockState),
     Pre => innerAirlockState = True,
     Post => outerAirlockState = True and innerAirlockState = True;

   procedure openOuterAirlock  with
     Global => (In_Out => outerAirlockState, 
                Input => (innerAirlockState, airlockDoorsLocked)),
     Pre => airlockDoorsLocked = False and 
            outerAirlockState = True and innerAirlockState = True,
     Post => innerAirlockState = True and outerAirlockState = False;
   
   procedure lockAirlockDoors with
     Global => (Input => (innerAirlockState, outerAirlockState), 
                In_Out => airlockDoorsLocked),
     Pre => innerAirlockState = True and 
            outerAirlockState = True,
     Post => airlockDoorsLocked = True and then
             innerAirlockState = True and then
             outerAirlockState = True;
   
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

   --to store a torpedo there has to be a place for it
   --after the fact a maximum number can be reached or not, allowing to add more
   procedure storeTorpedo with
     Global => (In_Out => storedTorpedoes, Input => airlockDoorsLocked ),
     Pre => storedTorpedoes < Torpedoes'Last and then
            airlockDoorsLocked = True,
     Post => airlockDoorsLocked = True and  
             storedTorpedoes <= Torpedoes'Last and 
             storedTorpedoes = storedTorpedoes'Old + 1;
   
   procedure loadTorpedo with
     Global => (In_Out => (storedTorpedoes, loadedTorpedoes), Input => airlockDoorsLocked),
     Pre => airlockDoorsLocked = True and 
            storedTorpedoes > Torpedoes'First and 
            loadedTorpedoes < TorpedoesLoaded'Last,
     Post => airlockDoorsLocked = True and 
             loadedTorpedoes = loadedTorpedoes'Old + 1 and  
             storedTorpedoes = storedTorpedoes'Old - 1;
   
   procedure fireTorpedo with
     Global => (In_Out => (loadedTorpedoes, reactorHeating), Input => airlockDoorsLocked),
     Pre => airlockDoorsLocked = True and then
     loadedTorpedoes > TorpedoesLoaded'First and then
     reactorHeating < ReactorHeatLevel'Last,
     Post => airlockDoorsLocked = True and  
             loadedTorpedoes = loadedTorpedoes'Old - 1 and
             reactorHeating = reactorHeating'Old + 1;
     
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
