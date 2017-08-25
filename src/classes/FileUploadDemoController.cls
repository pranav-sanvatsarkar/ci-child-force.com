public class FileUploadDemoController 
{
	public string ObjRecordId { get; set; }
	public List<ContentDocumentLink> LstFiles {get;set;}
	//public static Attachment attachmentRecord;
    public FileUploadDemoController()
    {
        ObjRecordId = ApexPages.currentPage().getParameters().get('id');
        LstFiles = [ SELECT ContentDocument.Title, ContentDocument.ContentSize, ContentDocument.Description FROM ContentDocumentLink WHERE LinkedEntityId =: ObjRecordId ];
    }
    @remoteAction
    public static string deleteAllAttachments( string recordId )
    {
    	try
    	{
    		List<Attachment> lstAttachments = [ SELECT Name, BodyLength, Description FROM Attachment WHERE ParentId =: recordId ];
    		delete lstAttachments;
    		return 'Deletion successful';
    	}
    	catch( Exception ex )
    	{
    		return ex.getMessage();
    	}
    }
    @remoteAction
    public static string insertAttachment( string fileName, string description, string parentId, string chunk, string attachmentId )
    {
    	try
    	{
    		Attachment attachmentRecord = [ SELECT Body FROM Attachment WHERE Id =: attachmentId  LIMIT 1][0];
    		system.debug('Body:'+attachmentRecord.Body);
    		String body = EncodingUtil.base64Encode(attachmentRecord.Body);
    		body += chunk;
    		attachmentRecord.Body = EncodingUtil.base64Decode(body);
    		
    		update attachmentRecord;
    		return attachmentRecord.id;
    	}
    	catch( Exception ex )
    	{
    		return ex.getMessage();
    	}
    }
    @remoteAction
    public static string uploadChunk( string fileName, string description, string parentId, string chunk, string attachmentId )
    {
    	try
    	{
    		Attachment attachmentRecord;
    		if( attachmentId == null )
    		{
	    		attachmentRecord = new Attachment();
	    		attachmentRecord.Name = fileName;
	    		attachmentRecord.Description = description;
	    		attachmentRecord.Body = EncodingUtil.base64Decode(chunk);
	    		attachmentRecord.ParentId = parentId;
	    		insert attachmentRecord;
	    	}
	    	else
	    	{
	    		attachmentRecord = [ SELECT Body FROM Attachment WHERE Id =: attachmentId LIMIT 1][0];
	    		//system.debug('Body:'+attachmentRecord.Body);
	    		String body = EncodingUtil.base64Encode(attachmentRecord.Body);
	    		body += chunk;
	    		attachmentRecord.Body = EncodingUtil.base64Decode(body);
	    		update attachmentRecord;
	    	}
	    	return attachmentRecord.id;
    	}
    	catch( Exception ex )
    	{
    		return ex.getMessage();
    	}
    }
    
    @remoteAction
	public static List<AttachmentWrapper> getFiles( string recordId )
	{
		if( recordId != null )
		{
			// code to fetch attachments
			List<Attachment> lstAttachments = [ SELECT Name, BodyLength, Description FROM Attachment WHERE ParentId =: recordId ];
			// code to fetch files
			List<ContentDocumentLink> lstFiles = [ SELECT ContentDocument.Title, ContentDocument.ContentSize, ContentDocument.Description FROM ContentDocumentLink WHERE LinkedEntityId =: recordId ];
			// code to create attachment wrapper to display in view
			List<AttachmentWrapper> lstReult = new List<AttachmentWrapper>();
			if( !lstAttachments.isEmpty() )
			{
				integer iCount = 1;
				for( Attachment attachment : lstAttachments )
				{
					AttachmentWrapper newAttachmentWrapper = new AttachmentWrapper( iCount, attachment.Name, attachment.Description, attachment.BodyLength, new AttachmentAction( 'sample link' ), 'Attachment' );
					lstReult.add( newAttachmentWrapper );
					iCount++;
				}
			}
			if( !lstFiles.isEmpty() )
			{
				integer iCount = 1;
				for( ContentDocumentLink document : lstFiles )
				{
					AttachmentWrapper newAttachmentWrapper = new AttachmentWrapper( iCount, document.ContentDocument.Title, document.ContentDocument.Description, document.ContentDocument.ContentSize, new AttachmentAction( 'sample link' ), 'File' );
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
		public integer serialNumber { get; set; }
		public string title { get; set; }
		public string description { get; set; }
		public string fileSize { get; set; }
		public string attachmentType { get; set; }
		public AttachmentAction attachmentAction { get; set; }
		public AttachmentWrapper( integer serialNumber, string title, string description, integer fileSize, AttachmentAction attachmentAction, string attachmentType )
		{
			this.serialNumber = serialNumber;
			this.title = title;
			this.description = description;
			if( fileSize > (1024*1024) )
				this.fileSize = (fileSize / (1024*1024)) + ' MB';
			else if( fileSize > 1024 )
				this.fileSize = (fileSize / 1024) + ' KB';
			else
				this.fileSize = fileSize + ' Bytes';
			//this.fileSize = fileSize;
			this.attachmentAction = attachmentAction;
			this.attachmentType = attachmentType;
		}
	}
	public class AttachmentAction
	{
		public string downloadLink { get; set; }
		public AttachmentAction( string downloadLink )
		{
			this.downloadLink = downloadLink;
		}
	}
}