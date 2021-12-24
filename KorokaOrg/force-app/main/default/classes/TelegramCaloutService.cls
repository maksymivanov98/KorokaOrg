public class TelegramCaloutService {
    private HttpRequest request;
    private static String API_TOKEN = '5020465102:AAH7JoMaMXxUfKYJpq_ZeuoELi4Z4cenrq0';
    private String endpoint = 'https://api.telegram.org/bot' + API_TOKEN;
    private Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json'};

    public TelegramCaloutService(){
        this.request = new HttpRequest();
    }

    public void setHttpHeaders(Map<String, String> headers){
        if(headers != null && headers.isEmpty()){
            this.headers.putAll(headers);
        }
        for(String key : this.headers.keySet()){
            this.request.setHeader(key, this.headers.get(key));
        }
    }

    public void setBody(){

    }

    public HttpResponse getMe(){
        this.request.setMethod('GET');
        this.request.setEndpoint(endpoint + '/getMe');
        return sendRequest();
    }

    public HttpResponse sendMessage(){
        return sendRequest();
    }
    
    private HttpResponse sendRequest(){
        Http http = new Http();
        HttpResponse response = http.send(this.request);
        system.debug(response.getStatus());
        system.debug(response.getBody());
        return response;
    }
}