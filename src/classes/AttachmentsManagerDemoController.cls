public class AttachmentsManagerDemoController 
{
    public AttachmentsManagerSetting AttachmentSetting { get; set; }
    public List<Account> LstAccounts { get; set; }
    public AttachmentsManagerDemoController()
    {
        AttachmentSetting = new AttachmentsManagerSetting(false,true,true,true,true);
        LstAccounts = [ SELECT Name FROM Account ];
    }
}