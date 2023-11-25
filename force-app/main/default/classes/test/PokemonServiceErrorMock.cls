global class PokemonServiceErrorMock implements HttpCalloutMock{
    
    global static HttpResponse respond(HttpRequest req){
        
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        String response = '{"results": [{"name": "bulbasaur","url": "https://pokeapi.co/api/v2/pokemon/1/"}]}';
        res.setBody(response);
        res.setStatusCode(500);
        res.setStatus('error');
        return res;
    }

}