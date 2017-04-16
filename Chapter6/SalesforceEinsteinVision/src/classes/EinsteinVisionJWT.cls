public class EinsteinVisionJWT {

    public class JWTHeaderParameters{
        public String alg ;
        public JWTHeaderParameters(String alg){
           this.alg = alg;
        }
    }

    public class JWTBodyParameters{

       public String iss {get;set;}
       public String sub {get;set;}
       public String aud {get;set;}
       public Long exp {get;set;}
       public Long iat {get;set;}

       public JWTBodyParameters(String iss,String sub,String aud, Integer validFor){
          this.iss = iss;
          this.sub = sub;
          this.aud = aud;
          //Current Date Time In Integer
          Long rightNow = (dateTime.now().getTime()/1000)+1;
          this.iat = rightNow;
          this.exp = rightNow + validFor;
       }
    }
    
   
    public String issue(String accountId , Integer expirationTime,String privateKeyString) {
        String jwt = '';
        //Create Header Encoded String
        EinsteinVisionJWT.JWTHeaderParameters header = new EinsteinVisionJWT.JWTHeaderParameters('RS256');
        String encodedHeader = base64URLencode(Blob.valueOf(System.JSON.Serialize(header)));
        //Create Body Encoded String
        EinsteinVisionJWT.JWTBodyParameters body = new EinsteinVisionJWT.JWTBodyParameters('developer.salesforce.com',accountId,
                                                                                    'https://api.metamind.io/v1/oauth2/token'
                                                                                    ,expirationTime);
       jwt = encodedHeader + '.' + base64URLencode(Blob.valueOf(System.JSON.Serialize(body)));
       Blob signature = null;
       Blob privateKey = EncodingUtil.base64Decode(privateKeyString);
       signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);
       jwt += '.' + base64URLencode(signature);  
       return jwt;
    }

    public String base64URLencode(Blob input){ 
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        return output;
    }
    

}