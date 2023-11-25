public with sharing class PokemonInsertHelper {
    
    public static Map<String, Object> insertPokemon(String name, String url, String id) {
 
        Map<String, Object> result = new Map<String, Object>();
    try{
        if(String.isEmpty(name) || String.isEmpty(url) || String.isEmpty(id)){
            throw new AuraHandledException('No pueden haber campos nulos');
        }
        Pokemon__c p = new Pokemon__c(Name__c=name, Url__c = url, External_id__c=id);
        Schema.SObjectField f = Pokemon__c.Fields.External_id__c;
        Database.UpsertResult saveResult = Database.upsert(p, f, false);
    
        result.put('success', saveResult.success);
        result.put('ids', saveResult.getId());
        result.put('isCreated', saveResult.isCreated());
    }catch(Exception e){
        result.put('success', false);
        result.put('errorMessage', e.getMessage());
    }
    return result;
        
    }

    public static Map<String, List<Object>> insertAbiity(List<Ability__c> abilities) {
 
        Map<String, List<Object>> result = new Map<String, List<Object>>();
        try{
            for (Ability__c ability : abilities) {
                if (String.isBlank(ability.External_id__c) || String.isBlank(ability.Name__c)
                || String.isBlank(ability.Url__c)) {
                    throw new AuraHandledException('No pueden haber campos nulos');
                }
            }
            Schema.SObjectField f = Ability__c.Fields.External_id__c;
            List<Database.UpsertResult> saveResult = Database.upsert(abilities, f, false);
            List<String> ids = new List<String>();
            for (Database.UpsertResult res : saveResult) {
                ids.add(res.getId());     
            }
            result.put('ids', ids);
        }catch(Exception e){
            result.put('errorMessage', new List<Object>{e.getMessage()});
        }
        return result;
        
    }

    public static Map<String, List<Object>> insertPokemonAbiity(List<String> idsAbility, String idPokemon) {
 
        Map<String, List<Object>> result = new Map<String, List<Object>>();
        try{
            if(String.isEmpty(idPokemon) || idsAbility.isEmpty()){
                throw new AuraHandledException('No pueden haber campos nulos');
            }
            List<Pokemon_Ability__c> pokemonAbilityToInsert = abilitiesToInsert(idPokemon, idsAbility);
            List<String> ids = new List<String>();
            List<Database.UpsertResult> saveResult = Database.upsert(pokemonAbilityToInsert, false);
            for (Database.UpsertResult res : saveResult) {
                ids.add(res.getId());     
            }
            result.put('ids', ids);
        }catch(Exception e){
            result.put('errorMessage', new List<Object>{e.getMessage()});
        }
        return result;
    }

    private static List<Pokemon_Ability__c> abilitiesToInsert(String idPokemon, List<String> idsAbility){

        List<Pokemon_Ability__c> pokemonAbilityToInsert= new List<Pokemon_Ability__c>();
        Set<Id> abilitieExist = new Set<Id>();
        for (Pokemon_Ability__c existeAbility : [
            SELECT Ability__c
            FROM Pokemon_Ability__c
            WHERE Pokemon__c = :idPokemon AND Ability__c IN :idsAbility
        ]) {
            abilitieExist.add(existeAbility.Ability__c);
        }
        for (Id abilityId : idsAbility) {
            if (!abilitieExist.contains(abilityId)) {
                Pokemon_Ability__c pokeAbility = new Pokemon_Ability__c(Pokemon__c = idPokemon, Ability__c = abilityId);
                pokemonAbilityToInsert.add(pokeAbility);
            }
        }
        return pokemonAbilityToInsert;
    }
}