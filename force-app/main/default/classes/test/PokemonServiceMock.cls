@isTest
global class PokemonServiceMock implements HttpCalloutMock{
    
    global HttpResponse respond(HttpRequest request){
        
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        String response = '{"results": [{"name": "bulbasaur","url": "https://pokeapi.co/api/v2/pokemon/1/"}]}';
        res.setBody(response);
        res.setStatusCode(200);
        return res;
    }

}