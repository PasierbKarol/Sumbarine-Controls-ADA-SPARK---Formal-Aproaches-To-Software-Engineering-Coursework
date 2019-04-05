package Submarine_Controls with SPARK_Mode is

   type AirlockState is new Boolean;
   innerAirlockState : AirlockState; --True closed, False open
   outerAirlockState : AirlockState; --True closed, False open
   
   --at least one airlock door closed at all times
   procedure closeInnerAirlock  with
     Pre => outerAirlockState = True,
     Post => innerAirlockState = True and then outerAirlockState = True;
   
   procedure openInnerAirlock  with
     Pre => outerAirlockState = True and then innerAirlockState = True,
     Post => innerAirlockState = False and then outerAirlockState = True;
   
   procedure closeOuterAirlock  with
     Pre => innerAirlockState = True,
     Post => outerAirlockState = True and then innerAirlockState = True;

   procedure openOuterAirlock  with
     Pre => outerAirlockState = True and then innerAirlockState = True,
     Post => innerAirlockState = True and then outerAirlockState = False;
   
   
   
   
   
   
   
   function canOperateSubmarine (innerAirlockState : in AirlockState; 
                                 outerAirlockState : in AirlockState) 
                                 return AirlockState with
     Pre => innerAirlockState = True and outerAirlockState = True,
     Post => canOperateSubmarine'Result = True or canOperateSubmarine'Result = False;
   
   function isOxygenLevelSafe(Oxygen : Integer) return Boolean with
     Pre => Oxygen > Integer'First;


   
end Submarine_Controls;
