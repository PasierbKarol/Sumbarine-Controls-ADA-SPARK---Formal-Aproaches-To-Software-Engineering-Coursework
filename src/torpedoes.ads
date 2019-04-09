with Airlock; use Airlock;
package Torpedoes with SPARK_Mode is

   --how many torpedoes can be stored on the boat
   type StoredTorpedoes is range 0..20;
   totalTorpedoes : StoredTorpedoes;

   type BayState is (Empty, Loaded); 
   
   --how many torpedoes can be loaded for firing
   type TorpedoesBayNumber is range 1..4;
   type TorpedoFiringBay is array (TorpedoesBayNumber) of BayState;
   
   type ReactorHeatLevel is range 0..1000;
   reactorHeating : ReactorHeatLevel;
   
   
    --to store a torpedo there has to be a place for it
   --after the fact a maximum number can be reached or not, allowing to add more
   procedure storeTorpedo with
     Global => (In_Out => totalTorpedoes, Input => airlockDoorsLocked ),
     Pre => totalTorpedoes < StoredTorpedoes'Last and then
            airlockDoorsLocked = True,
     Post => airlockDoorsLocked = True and  
             totalTorpedoes <= StoredTorpedoes'Last and 
             totalTorpedoes = totalTorpedoes'Old + 1;
   
   procedure loadTorpedo (torpedoBay : in out TorpedoFiringBay; bayNumber : in TorpedoesBayNumber) with
     Global => (In_Out => (totalTorpedoes), Input => airlockDoorsLocked),
     Pre => airlockDoorsLocked = True and 
            totalTorpedoes > StoredTorpedoes'First, 
     Post => airlockDoorsLocked = True and              
             totalTorpedoes = totalTorpedoes'Old - 1;
   
   procedure fireTorpedo (reactorHeating : in out ReactorHeatLevel;
                         torpedoBay : in out TorpedoFiringBay; 
                          bayNumber : in TorpedoesBayNumber) with
     Global => ( Input => airlockDoorsLocked),
     Pre => airlockDoorsLocked = True and then
     torpedoBay(bayNumber) /= Empty and then
     reactorHeating < ReactorHeatLevel'Last,
     Post => airlockDoorsLocked = True and  
             torpedoBay(bayNumber) = Empty and
                 (for all I in TorpedoFiringBay'Range =>
                 (if I /= bayNumber then torpedoBay(I) = torpedoBay'Old(I) )) and 
             reactorHeating = reactorHeating'Old + 1;

end Torpedoes;
