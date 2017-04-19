public class EinsteinVisionHttpUtility{

    public static HttpResponse makeCallout(blob body,String contentType,String endPoint,String requestType,String accessToken){
        // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer '+accessToken);
        req.setHeader('Content-Type', contentType);
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(endPoint);
        req.setBodyAsBlob(body);
        req.setMethod(requestType);
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        return res;
    }
}