public with sharing class PokemonService {
    
    public static Map<String, Object> getBodyRes(String url) {

        Map<String, Object> responseMap = new Map<String, Object>();
    
        try {
            HttpRequest req = new HttpRequest();        
            req.setEndpoint('callout:pokeapi'+url.substringAfter('https://pokeapi.co'));
            req.setMethod('GET');
    
            Http http = new Http();
            HTTPresponse res= http.send(req);
    
            if (res.getStatusCode() == 200) {
                responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            } else {
            responseMap.put('error', 'Error en la llamada externa: ' + res.getStatusCode() + ' ' + res.getStatus());
            }
        } catch (Exception e) {
            responseMap.put('error', 'Error en la llamada externa: ' + e.getMessage());
        }
            return responseMap;
    }
}