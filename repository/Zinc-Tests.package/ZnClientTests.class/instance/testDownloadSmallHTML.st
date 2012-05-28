testing
testDownloadSmallHTML
	| client |
	(FileDirectory default fileExists: 'small.html')
		ifTrue: [ FileDirectory default deleteFileNamed: 'small.html' ].
	"First download to a directory"

	(client := ZnClient new)
		url: 'http://zn.stfx.eu/zn/small.html';
		downloadTo: FileDirectory default fullName.
	self assert: client isSuccess.
	self assert: client response contentType = ZnMimeType textHtml.
	FileStream 
		oldFileNamed: (FileDirectory default fullPathFor: 'small.html') 
		do: [ :stream | self assert: (stream contents includesSubString: 'Small') ].
	(FileDirectory default fileExists: 'small.html')
		ifTrue: [ FileDirectory default deleteFileNamed: 'small.html' ].
	"Second download to an explicitly named file"
	client 
		url: 'http://zn.stfx.eu/zn/small.html';
		downloadTo: 'small.html'.
	self assert: client isSuccess.
	self assert: client response contentType = ZnMimeType textHtml.
	FileStream 
		oldFileNamed: 'small.html' 
		do: [ :stream | self assert: (stream contents includesSubString: 'Small') ].	
	client close.
	(FileDirectory default fileExists: 'small.html')
		ifTrue: [ FileDirectory default deleteFileNamed: 'small.html' ]