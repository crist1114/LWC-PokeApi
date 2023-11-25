public with sharing class PokemonController {

private static final String URL_ENDPOINT = 'https://pokeapi.co/api/v2/pokemon/';

@AuraEnabled(cacheable=true)
    public static List<Object> getPokemons() {
    Map<String, Object> responseMap = PokemonService.getBodyRes(URL_ENDPOINT);
    List<Object> results = (List<Object>)responseMap.get('results');
    return results;
}

@AuraEnabled(cacheable=true)
public static Map<String, Object> getDescripcion(String url) {
    Map<String, Object> responseMap = PokemonService.getBodyRes(url);
    return responseMap;
}

@AuraEnabled
public static Map<String, Object> insertPokemon(String name, String url, String id) {
    return PokemonInsertHelper.insertPokemon(name, url, id);
}

@AuraEnabled
public static Map<String, List<Object>> insertAbiity(List<Ability__c> abilities) {
    return PokemonInsertHelper.insertAbiity(abilities);
}

@AuraEnabled
public static Map<String, List<Object>> insertPokemonAbiity(List<String> idsAbility, String idPokemon) {
    return PokemonInsertHelper.insertPokemonAbiity(idsAbility, idPokemon);
    
}

@AuraEnabled(cacheable=true)
public static List<Pokemon__c> existePokemon(String id, String random) {
    List<Pokemon__c> p = [select id from Pokemon__c where External_id__c =:id];
    return p;
}

@AuraEnabled
public static Map<String,Object> eliminarPokemon(String id) {
    Map<String,Object> res = new Map<String,Object>();
    Pokemon__c p = [select id from Pokemon__c where id=:id]; 
    Database.DeleteResult deleteResult = Database.delete(p, false);
    res.put('success', deleteResult.isSuccess());
    
    return res;
}


}