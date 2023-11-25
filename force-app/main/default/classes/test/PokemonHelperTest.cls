@isTest
public class PokemonHelperTest {
	
    @isTest
    static void insertarPokemonTest(){
        Map<String, Object> result = PokemonInsertHelper.insertPokemon('bolbasor','https://pokeapi.co/api/v2/pokemon/1','1');
        
        System.assertEquals(true, result.get('success'));
        System.assertEquals(true, result.get('isCreated'));
        Id pokemonId = (Id)result.get('ids');
        
        Pokemon__c insertedPokemon = [SELECT Id, Name__c, Url__c, External_id__c FROM Pokemon__c WHERE Id = :pokemonId];
        System.assertEquals('bolbasor', insertedPokemon.Name__c);
        System.assertEquals('https://pokeapi.co/api/v2/pokemon/1', insertedPokemon.Url__c);
        System.assertEquals('1', insertedPokemon.External_id__c);
        Map<String, Object> resultN = PokemonInsertHelper.insertPokemon('bolbasor','https://pokeapi.co/api/v2/pokemon/1','');
        System.assertEquals(false, resultN.get('success'));
        System.assert(resultN.containsKey('errorMessage'));
    }
    
    @isTest
    static void insertAbilityTest(){
        List<Ability__c> abilities = new List<Ability__c>();
        abilities.add(new Ability__c(Name__c = 'Thunderbolt', Url__c='https://pokeapi.co/api/v2/ability/34/', External_id__c = '34'));
        abilities.add(new Ability__c(Name__c = 'Quick Attack', Url__c='https://pokeapi.co/api/v2/ability/42/', External_id__c = '42'));
        Map<String, List<Object>> result = PokemonInsertHelper.insertAbiity(abilities);
        List<String> ids = (List<String>)result.get('ids');
        System.assert(ids!=null);
        System.assertEquals(2, ids.size());
        
        List<Ability__c> insertedAbilities = [SELECT Id FROM Ability__c where id in:ids];
        System.assertEquals(2, insertedAbilities.size());
        
    }
    @isTest
    static void testInsertAbilityWithException() {
        
        List<Ability__c> abilities = new List<Ability__c>();
        abilities.add(new Ability__c(Name = 'Thunderbolt', External_id__c = null));

        Test.startTest();
        Map<String, List<Object>> result = PokemonInsertHelper.insertAbiity(abilities);
        Test.stopTest();
        System.assert(result.containsKey('errorMessage'));
    }
    
    @isTest
    static void insertPokemonAbiityTest(){
        List<Ability__c> abilities = new List<Ability__c>();
        abilities.add(new Ability__c(Name__c = 'Thunderbolt', Url__c='https://pokeapi.co/api/v2/ability/34/', External_id__c = '34'));
        abilities.add(new Ability__c(Name__c = 'Quick Attack', Url__c='https://pokeapi.co/api/v2/ability/42/', External_id__c = '42'));
        insert abilities;
        List<String> idsInserted = new List<String>();
        for (Ability__c ability : abilities) {
            idsInserted.add(ability.Id);     
        }
        Pokemon__c p = new Pokemon__c(Name__c = 'bolbasour', Url__c='https://pokeapi.co/api/v2/pokemon/1', External_id__c = '1');
        insert p;
        Map<String, List<Object>> result = PokemonInsertHelper.insertPokemonAbiity(idsInserted, (String)p.Id);
        
        List<String> ids = (List<String>)result.get('ids');
        System.assert(ids!=null);
        System.assertEquals(2, ids.size());
        
        List<Pokemon_Ability__c> insertedPokemonAbilities = [SELECT Id FROM Pokemon_Ability__c where id in:ids];
        System.assertEquals(2, insertedPokemonAbilities.size());
        //caso negativo
        Map<String, List<Object>> resultN = PokemonInsertHelper.insertPokemonAbiity(idsInserted, '');
        System.assert(resultN.containsKey('errorMessage'));
        
    }
}