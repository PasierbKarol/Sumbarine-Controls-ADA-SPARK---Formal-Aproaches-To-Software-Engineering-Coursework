with Airlock; use Airlock;
package body Torpedoes with SPARK_Mode is

   --======== Torpedoes ======
   --torpedoes can be stored while on surface
   procedure storeTorpedo is begin
      if totalTorpedoes < StoredTorpedoes'Last
        and airlockDoorsLocked = True 
      then
         totalTorpedoes := totalTorpedoes + 1;
      end if;
   end storeTorpedo;   
   
   --cannot load torpedo if submarine doors are unlocked
   procedure loadTorpedo (torpedoBay : in out TorpedoFiringBay; bayNumber : in TorpedoesBayNumber) is begin
      if totalTorpedoes > StoredTorpedoes'First
        and airlockDoorsLocked = True then
         torpedoBay(bayNumber) := Loaded;
         totalTorpedoes := totalTorpedoes - 1;
      end if;
   end loadTorpedo;
   
   --cannot fire torpedo if submarine doors are unlocked
   procedure fireTorpedo (reactorHeating : in out ReactorHeatLevel;
                          torpedoBay : in out TorpedoFiringBay; 
                          bayNumber : in TorpedoesBayNumber) is begin
      if torpedoBay(bayNumber) /= Empty and 
          airlockDoorsLocked = True 
        and reactorHeating < ReactorHeatLevel'Last          
      then
         -- loadedTorpedoes := loadedTorpedoes - 1;
         torpedoBay(bayNumber) := Empty; 
         reactorHeating := reactorHeating + 1;
      end if;
   end fireTorpedo;

end Torpedoes;
