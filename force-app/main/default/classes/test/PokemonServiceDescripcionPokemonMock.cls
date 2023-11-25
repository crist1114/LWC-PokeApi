global class PokemonServiceDescripcionPokemonMock implements HttpCalloutMock{
    
    global static HttpResponse respond(HttpRequest req){
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String response = '{"abilities": [{"ability": {"name": "limber","url": "https://pokeapi.co/api/v2/ability/7/"}}]}';
        res.setBody(response);
        res.setStatusCode(200);
        return res;
    }
}