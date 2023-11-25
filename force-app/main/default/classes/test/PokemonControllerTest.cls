@isTest
public class PokemonControllerTest {
    
    @isTest
    static void getPokemonsTest(){
        
        Test.setMock(HttpCalloutMock.class, new PokemonServiceMock());
        List<Object> pokemones = PokemonController.getPokemons();
        String name = 'bulbasaur';
        Map<String, Object> obj = (Map<String, Object>)pokemones[0];
        System.assertEquals(name, obj.get('name'));
    }
    
    @isTest
    static void getDescripcionTest(){
        Test.setMock(HttpCalloutMock.class, new PokemonServiceDescripcionPokemonMock());
        Map<String, Object> res = PokemonController.getDescripcion('https://pokeapi.co/api/v2/pokemon/1/');
        System.assertEquals(1, res.size());
        System.assert(res.containsKey('abilities'));
    }
    
    @isTest
    static void insertPokemonTest(){
        Map<String, Object> result = PokemonController.insertPokemon('bolbasour', 'https://pokeapi.co/api/v2/pokemon/1/', '1');
        Id pokemonId = (Id)result.get('ids');
        
        Pokemon__c insertedPokemon = [SELECT Id, Name__c, Url__c, External_id__c FROM Pokemon__c WHERE Id = :pokemonId];
        System.assertEquals('bolbasour', insertedPokemon.Name__c);
        System.assertEquals('https://pokeapi.co/api/v2/pokemon/1/', insertedPokemon.Url__c);
        System.assertEquals('1', insertedPokemon.External_id__c);
    }
    
     @isTest
    static void existePokemonTest(){
        Pokemon__c insertedPokemon = new Pokemon__c(Name__c='bolbasor', Url__c='https://pokeapi.co/api/v2/pokemon/1/', External_id__c='1');
        insert insertedPokemon;
        
        List<Pokemon__c> p = PokemonController.existePokemon(insertedPokemon.External_id__c, '2');
        System.assertEquals(1, p.size());
        
        Pokemon__c pokemon = p[0];
        System.assertEquals(insertedPokemon.id, pokemon.id);
    }
    
     @isTest
    static void eliminarPokemonTest(){
        Pokemon__c insertedPokemon = new Pokemon__c(Name__c='bolbasor', Url__c='https://pokeapi.co/api/v2/pokemon/1/', External_id__c='1');
        insert insertedPokemon;
        
        Map<String,Object> res = PokemonController.eliminarPokemon(insertedPokemon.id);
        System.assertEquals(true, res.get('success'));
    }
    
     @isTest
    static void insertAbiityTest(){
        List<Ability__c> abilities = new List<Ability__c>();
        abilities.add(new Ability__c(Name__c = 'Thunderbolt', Url__c='https://pokeapi.co/api/v2/ability/34/', External_id__c = '34'));
        abilities.add(new Ability__c(Name__c = 'Quick Attack', Url__c='https://pokeapi.co/api/v2/ability/42/', External_id__c = '42'));
        Map<String, List<Object>> result = PokemonController.insertAbiity(abilities);
        List<String> ids = (List<String>)result.get('ids');
        System.assert(ids!=null);
        System.assertEquals(2, ids.size());
        
        List<Ability__c> insertedAbilities = [SELECT Id FROM Ability__c where id in:ids];
        System.assertEquals(2, insertedAbilities.size());
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
        Map<String, List<Object>> result = PokemonController.insertPokemonAbiity(idsInserted, (String)p.Id);
        
        List<String> ids = (List<String>)result.get('ids');
        System.assert(ids!=null);
        System.assertEquals(2, ids.size());
        
        List<Pokemon_Ability__c> insertedPokemonAbilities = [SELECT Id FROM Pokemon_Ability__c where id in:ids];
        System.assertEquals(2, insertedPokemonAbilities.size());
    }

}