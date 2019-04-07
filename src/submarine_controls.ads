package Submarine_Controls with SPARK_Mode is

   --Variables ======================================================
   innerAirlockState : Boolean; --True closed, False open
   outerAirlockState : Boolean; --True closed, False open
   airlockDoorsLocked : Boolean; --True no doors can be opened
   
--maximum possible level of oxygen, 0 is depleted
   maximumOxygen : constant Integer := 10000; 
--current oxygen level, each operation consumes oxygen
   oxygenLevel : Integer; 
   
   currentDepth : Integer; 
   --maximum possible depth, 0 is on surface
   maximumDepth : constant Integer := 5000; 
   
   --reactorOverheatThreshold : constant Integer := 12000;
   isReactorOverheated : Boolean := False;
   
   --how many torpedoes can be stored on the boat
   maximumTorpedoes : constant Integer := 20; 
   storedTorpedoes : Integer; --currently stored torpedoes, except loaded ones
   --how many torpedoes can be loaded for firing
   maximumLoadedTorpedoes : constant Integer := 6;
   loadedTorpedoes : Integer;
   
   
   --Contracts =======================================================
   
   --at least one airlock door closed at all times
   --procedures below ensure that at least one airlock door is closed at all times
   procedure closeInnerAirlock  with
     Global => (In_Out => innerAirlockState, Input => outerAirlockState),
     Pre => outerAirlockState = True,
     Post => innerAirlockState = True and then outerAirlockState = True;
   
   procedure openInnerAirlock  with
     Global => (In_Out => innerAirlockState, 
                Input => (outerAirlockState, airlockDoorsLocked)),
     Pre => airlockDoorsLocked = False and then 
            outerAirlockState = True and then innerAirlockState = True,
     Post => innerAirlockState = False and then outerAirlockState = True;
   
   procedure closeOuterAirlock  with
     Global => (In_Out => outerAirlockState, Input => innerAirlockState),
     Pre => innerAirlockState = True,
     Post => outerAirlockState = True and then innerAirlockState = True;

   procedure openOuterAirlock  with
     Global => (In_Out => outerAirlockState, 
                Input => (innerAirlockState, airlockDoorsLocked)),
     Pre => airlockDoorsLocked = False and then 
            outerAirlockState = True and then innerAirlockState = True,
     Post => innerAirlockState = True and then outerAirlockState = False;
   
   procedure lockAirlockDoors with
     Global => (Input => (innerAirlockState, outerAirlockState), 
                In_Out => airlockDoorsLocked),
     Pre => innerAirlockState = True and then outerAirlockState = True,
     Post => innerAirlockState = True and then outerAirlockState = True 
     and then airlockDoorsLocked = True;
   
   
   
   
   --oxygen is decreased 100 points while the submarine is submerged
   --it can happen only if the airlock is locked and there is still any oxygen left
   --decreasing oxygen below 500 points shows a warning
   procedure decreaseOxygen with
     Global => (Input => airlockDoorsLocked, In_Out => oxygenLevel),
     Pre => oxygenLevel >= 100 and then 
            airlockDoorsLocked = True,
     Post => oxygenLevel >= 0;
   
 
   procedure checkOxygenStatus with 
     Global => (Input => airlockDoorsLocked, In_Out => (oxygenLevel, currentDepth)),
     Pre =>  oxygenLevel >= 0,
     Post =>  oxygenLevel >= 0;
    
   procedure checkReactorStatus;
   
--     procedure diveDeeper;
   
   --submerge submarine
   --cannot be done if there is no oxygen left
   --diving or surfacing reduces oxygen
   procedure increaseDepth with
     Global =>(Input => (airlockDoorsLocked,oxygenLevel), 
               In_Out => ( currentDepth )),
     Pre => currentDepth < maximumDepth and then
            oxygenLevel >= 100 and then 
            airlockDoorsLocked = True,
     Post => 
       airlockDoorsLocked = True and then
       currentDepth <= maximumDepth and then 
       currentDepth >= 0 and then
       oxygenLevel >= 0;
   
   --the same purpose as above, just opposite
   procedure decreaseDepth with
     Global =>(Input => (airlockDoorsLocked,oxygenLevel), 
               In_Out => ( currentDepth )),
     Pre => currentDepth < maximumDepth and then
            oxygenLevel >= 100 and then 
            airlockDoorsLocked = True,
     Post => 
       airlockDoorsLocked = True and then
       currentDepth <= maximumDepth and then 
       currentDepth >= 0 and then
       oxygenLevel >= 0;

   --to store a torpedo there has to be a place for it
   --after the fact a maximum number can be reached or not, allowing to add more
   procedure storeTorpedo with
     Global => (In_Out => storedTorpedoes ),
     Pre => storedTorpedoes < maximumTorpedoes,
     Post => storedTorpedoes <= maximumTorpedoes and then
             storedTorpedoes = storedTorpedoes'Old + 1;
   
   procedure loadTorpedo with
     Global => (In_Out => (storedTorpedoes, loadedTorpedoes), Input => airlockDoorsLocked),
     Pre => storedTorpedoes >= 1 and then
     loadedTorpedoes < maximumLoadedTorpedoes and then
     airlockDoorsLocked = True,
     Post => storedTorpedoes >= 0 and then 
             loadedTorpedoes <= maximumLoadedTorpedoes and then
     loadedTorpedoes = loadedTorpedoes'Old + 1 and then 
     storedTorpedoes = storedTorpedoes'Old - 1 and then
     airlockDoorsLocked = True;
   
   
   
   
   
end Submarine_Controls;
