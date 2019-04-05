package Submarine_Controls with SPARK_Mode is

   innerAirlockState : Boolean; --True closed, False open
   outerAirlockState : Boolean; --True closed, False open
   airlockDoorsLocked : Boolean; --True no doors can be opened
   
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
   
   
   
   
   
   
   
   
   function canOperateSubmarine (innerAirlockState : in Boolean; 
                                 outerAirlockState : in Boolean) 
                                 return Boolean with
     Pre => innerAirlockState = True and outerAirlockState = True,
     Post => canOperateSubmarine'Result = True or canOperateSubmarine'Result = False;
   
   function isOxygenLevelSafe(Oxygen : Integer) return Boolean with
     Pre => Oxygen > Integer'First;


   
end Submarine_Controls;
