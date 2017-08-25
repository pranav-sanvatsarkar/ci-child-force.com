public class AttachmentsManagerSetting 
{
    public boolean IsAttachmentsEnabled { get; set; }
    public boolean IsDeleteEnabled { get; set; }
    public boolean IsDownloadEnabled { get; set; }
    public boolean ShowDeleteLink { get; set; }
    public boolean ShowDownloadLink { get; set; }
    public AttachmentsManagerSetting( boolean IsAttachmentsEnabled, boolean IsDeleteEnabled, boolean IsDownloadEnabled, boolean ShowDeleteLink, boolean ShowDownloadLink )
    {
        this.IsAttachmentsEnabled = IsAttachmentsEnabled;
        this.IsDeleteEnabled = IsDeleteEnabled;
        this.IsDownloadEnabled = IsDownloadEnabled;
        this.ShowDeleteLink = ShowDeleteLink;
        this.ShowDownloadLink = ShowDownloadLink;
    }
}