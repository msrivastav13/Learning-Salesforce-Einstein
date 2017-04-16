public class EinsteinVisionJWTBearerTokenExchange {

    public static String getAccessToken(String accountId ,Integer expirationTime,String privateKeyString ) {
        String access_token = null;
        String body = 'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=';
        body = body + EinsteinVisionJWT.issue(accountId,expirationTime,privateKeyString);
        HttpRequest req = new HttpRequest();                            
        req.setMethod('POST');
        req.setEndpoint(EinsteinVisionJWT.tokenEndpoint);
        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        req.setBody(body);
        Http http = new Http();               
        HTTPResponse res = http.send(req);
        
        if ( res.getStatusCode() == 200 ) {
            System.JSONParser parser = System.JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    access_token = parser.getText();
                    break;
                }
            }
        }
        return access_token; 
    }

}