@isTest
public class PokemonServiceTest {
    
    @isTest
    static void getBodyResTest(){
        
        Test.setMock(HttpCalloutMock.class, new PokemonServiceMock());
        
        Map<String, Object> res = PokemonService.getBodyRes('https://pokeapi.co/api/v2/pokemon/');
        List<Object> results = (List<Object>)res.get('results'); 
        Map<String, Object> mapa = (Map<String, Object>)results[0];
        System.assertEquals('bulbasaur', mapa.get('name'));
        System.assertEquals('https://pokeapi.co/api/v2/pokemon/1/', mapa.get('url'));
        
    }

}