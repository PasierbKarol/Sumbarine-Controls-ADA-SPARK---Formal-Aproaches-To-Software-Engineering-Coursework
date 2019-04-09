with Airlock; use Airlock;
package body Torpedoes with SPARK_Mode is

   --======== Torpedoes ======
   --torpedoes can be stored while on surface
   procedure storeTorpedo is begin
      if storedTorpedoes < Torpedoes'Last
        and airlockDoorsLocked = True 
      then
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
   procedure fireTorpedo (reactorHeating : in out ReactorHeatLevel) is begin
      if loadedTorpedoes > TorpedoesLoaded'First
        and airlockDoorsLocked = True 
        and reactorHeating < ReactorHeatLevel'Last          
      then
         loadedTorpedoes := loadedTorpedoes - 1;
         reactorHeating := reactorHeating + 1;
      end if;
   end fireTorpedo;

end Torpedoes;
