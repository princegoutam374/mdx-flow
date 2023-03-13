public class skedResourceLoginController {
    public String url{get;set;}
    public skedResourceLoginController(){}
    
    public String Change_Pass_URL  = '/_ui/system/security/ChangePassword?fromFrontdoor=1&retURL=%2Fsecur%2Flogout.jsp&setupid=ChangePassword';
    
    public PageReference next(){
        List<String> allowedList = new List<String>{
            'RemoteAccess', //Mobile redirect page
            'ChangePassword' //Change password page
        };
        url = Apexpages.currentPage().getUrl();
        
        boolean allowLogin = false;
        boolean isChangePassword = false;
        for (String s : allowedList) {
            if (url.contains(s)) {
                allowLogin = true;
            }
            if (url.contains('ChangePassword')) {
                isChangePassword = true;
            }
        }
        if (isChangePassword && !url.contains(Change_Pass_URL)) {
            return Auth.SessionManagement.finishLoginFlow(Change_Pass_URL);
        } else if (allowLogin) {
            return Auth.SessionManagement.finishLoginFlow();
        }
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Web browser login is disabled.');
        ApexPages.addMessage(myMsg);
        return null;
    }
}