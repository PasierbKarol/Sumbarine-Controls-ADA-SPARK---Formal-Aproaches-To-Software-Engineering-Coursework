with Airlock; use Airlock;
package Torpedoes with SPARK_Mode is

   --how many torpedoes can be stored on the boat
   type Torpedoes is range 0..20;
   storedTorpedoes : Torpedoes;

   --how many torpedoes can be loaded for firing
   type TorpedoesLoaded is range 0..6;
   loadedTorpedoes : TorpedoesLoaded;
   
      type ReactorHeatLevel is range 0..1000;
   reactorHeating : ReactorHeatLevel;
   
   
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
   
   procedure fireTorpedo (reactorHeating : in out ReactorHeatLevel) with
     Global => (In_Out => (loadedTorpedoes), Input => airlockDoorsLocked),
     Pre => airlockDoorsLocked = True and then
     loadedTorpedoes > TorpedoesLoaded'First and then
     reactorHeating < ReactorHeatLevel'Last,
     Post => airlockDoorsLocked = True and  
             loadedTorpedoes = loadedTorpedoes'Old - 1 and
             reactorHeating = reactorHeating'Old + 1;

end Torpedoes;
