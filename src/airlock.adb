package body Airlock with SPARK_Mode is 

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

end Airlock;
