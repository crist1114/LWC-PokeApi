trigger PokemonCascadeDelete on Pokemon__c (before delete) {
    Set<Id> pokemonIds = new Set<Id>();
    for (Pokemon__c pokemon : Trigger.old) {
        pokemonIds.add(pokemon.Id);
    }

    List<Pokemon_Ability__c> pokemonAbilitiesToDelete = [SELECT Id,Ability__c FROM Pokemon_Ability__c WHERE Pokemon__c IN :pokemonIds];
     
    delete pokemonAbilitiesToDelete;
    
    // Set<Id> abilityIds = new Set<Id>();
    // for (Pokemon_Ability__c pokemonAbility : pokemonAbilitiesToDelete) {
    //     System.debug(pokemonAbility);
    //     abilityIds.add(pokemonAbility.Ability__c);
    // }
   
    // List<Ability__c> abilitiesToDelete = [SELECT Id FROM Ability__c WHERE Id IN :abilityIds];
    // delete abilitiesToDelete;
}