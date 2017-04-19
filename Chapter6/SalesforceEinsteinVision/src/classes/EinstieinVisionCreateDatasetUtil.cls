public with sharing class EinstieinVisionCreateDatasetUtil{

    public static final String endpoint = 'https://api.metamind.io/v1/vision/datasets/upload';

    public static EinsteinVisionDatasetResult createDatasetFromURLAsync(String publicURL){
        EinsteinVisionDatasetResult dataset = new EinsteinVisionDatasetResult();
        String body = '';
        body += EinsteinVisionUtility.WriteBoundary();
        body += EinsteinVisionUtility.WriteBodyParameter('path', publicURL);
        body += EinsteinVisionUtility.WriteBoundary(EinsteinVisionUtility.EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        //Invoke AccessTokenManager To Get accessToken
        EinsteinVisionAccessTokenManager.AccessToken accessTokenObject = EinsteinVisionAccessTokenManager.getcurrentAccessToken();
        HttpResponse result = EinsteinVisionHttpUtility.makeCallout(bodyBlob,EinsteinVisionUtility.getContentType(),endpoint,'POST',accessTokenObject.accessToken);
        if(result.getStatusCode() == 200){
           String responseString = result.getBody();
           responseString = responseString.replaceAll('object','object_x');
           dataset = EinsteinVisionDatasetResult.parse(responseString);
           //Check if token needs commit and if yes commit it 
           if(accessTokenObject.isChanged){
               EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
           }
        }else{
           if(result.getBody()== '{"message":"Invalid access token"}'){
              //retry with new token
               HttpResponse retryresult = EinsteinVisionHttpUtility.makeCallout(bodyBlob,EinsteinVisionUtility.getContentType(),
                                                                                endpoint,'POST',
                                                                                EinsteinVisionAccessTokenManager.getNewToken(EinsteinVision__c.getOrgDefaults()).accessToken
                                                                                );
               String responseString = result.getBody();
               responseString = responseString.replaceAll('object','object_x');
               dataset = EinsteinVisionDatasetResult.parse(responseString);
               //Commit the new token
               EinsteinVisionAccessTokenManager.updateAccessToken(accessTokenObject.accessToken);
            }else{
              throw new EinstieinVisionException(result.getBody());
           }
        }
        return dataset;
    }

    private class EinstieinVisionException extends Exception {}

}