public class AttachmentsManagerController 
{
	@remoteAction
	public static List<AttachmentWrapper> getFiles( string recordId )
	{
		try
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
						AttachmentWrapper newAttachmentWrapper = new AttachmentWrapper( attachment.Id, iCount, attachment.Name, attachment.Description, attachment.BodyLength, new AttachmentAction( 'sample link' ), 'Attachment' );
						lstReult.add( newAttachmentWrapper );
						iCount++;
					}
				}
				if( !lstFiles.isEmpty() )
				{
					integer iCount = 1;
					for( ContentDocumentLink document : lstFiles )
					{
						AttachmentWrapper newAttachmentWrapper = new AttachmentWrapper( document.ContentDocumentId, iCount, document.ContentDocument.Title, document.ContentDocument.Description, document.ContentDocument.ContentSize, new AttachmentAction( 'sample link' ), 'File' );
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
			{
				return null;
			}
		}
		catch( Exception ex )
		{
			return null;
		}
	}
	
	@remoteAction
	public static string deleteFile( string recordId )
	{
		try
		{
			ContentDocument document = new ContentDocument(Id=recordId);
			delete document;
			return document.Id;
		}
		catch( Exception ex )
		{
			return null;
		}
	}
	
	public class AttachmentWrapper
	{
		public integer serialNumber { get; set; }
		public string title { get; set; }
		public string description { get; set; }
		public integer fileSize { get; set; }
		public string attachmentType { get; set; }
		public AttachmentAction attachmentAction { get; set; }
		public string documentId { get; set; }
		public AttachmentWrapper( string documentId, integer serialNumber, string title, string description, integer fileSize, AttachmentAction attachmentAction, string attachmentType )
		{
			this.documentId = documentId;
			this.serialNumber = serialNumber;
			this.title = title;
			this.description = description;
			this.fileSize = fileSize;
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