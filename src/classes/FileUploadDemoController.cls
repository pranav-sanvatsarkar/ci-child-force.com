public class FileUploadDemoController 
{
	public string ObjRecordId { get; set; }
	public List<ContentDocument> LstFiles {get;set;}
    public FileUploadDemoController()
    {
        ObjRecordId = ApexPages.currentPage().getParameters().get('id');
    }
    
    @remoteAction
	public static List<AttachmentWrapper> getFiles( string recordId )
	{
		if( recordId != null )
		{
			// code to fetch attachments
			List<Attachment> lstAttachments = [ SELECT Name, BodyLength, Description FROM Attachment WHERE ParentId =: recordId ];
			List<ContentDocument> lstFiles = [ SELECT Id, Title, ParentId, ContentSize, Description, FileType, FileExtension FROM ContentDocument ];
			LstFiles = new List<ContentDocument>();
			LstFiles = lstFiles;
			List<AttachmentWrapper> lstReult = new List<AttachmentWrapper>();
			if( !lstAttachments.isEmpty() )
			{
				integer iCount = 1;
				for( Attachment attachment : lstAttachments )
				{
					AttachmentWrapper newAttachmentWrapper = new AttachmentWrapper( iCount, attachment.Name, attachment.Description, attachment.BodyLength, new AttachmentAction( 'sample link' ) );
					lstReult.add( newAttachmentWrapper );
					iCount++;
				}
				return lstReult;
			}
			if( !lstFiles.isEmpty() )
			{
				integer iCount = 1;
				for( ContentDocument document : lstFiles )
				{
					AttachmentWrapper newAttachmentWrapper = new AttachmentWrapper( iCount, document.Title, document.Description, document.ContentSize, new AttachmentAction( 'sample link' ) );
					lstReult.add( newAttachmentWrapper );
					iCount++;
				}
			}
			if( !lstReult.isEmpty() )
				return lstReult;
			else
				return null;
		}
		else		
			return null;
	}
	public class AttachmentWrapper
	{
		public integer serialNumber {get;set;}
		public string title {get;set;}
		public string description {get;set;}
		public integer fileSize {get;set;}
		public AttachmentAction attachmentAction {get;set;}
		public AttachmentWrapper( integer serialNumber, string title, string description, integer fileSize, AttachmentAction attachmentAction )
		{
			this.serialNumber = serialNumber;
			this.title = title;
			this.description = description;
			this.fileSize = fileSize;
			this.attachmentAction = attachmentAction;
		}
	}
	public class AttachmentAction
	{
		public string downloadLink {get;set;}
		public AttachmentAction( string downloadLink )
		{
			this.downloadLink = downloadLink;
		}
	}
}