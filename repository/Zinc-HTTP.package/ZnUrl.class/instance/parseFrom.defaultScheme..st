parsing
parseFrom: string defaultScheme: defaultScheme
	| start end index |
	start := 1.
	end := string size.
	(index := string indexOf: $#) > 0
		ifTrue: [ 
			self fragment: (ZnUtils decodePercent: (string copyFrom: index + 1 to: end)).
			end := index - 1 ].
	(index := string indexOf: $?) > 0
		ifTrue: [
			self query: (ZnUtils parseQueryFrom: (AnsiReadStream on: string from: index + 1 to: end)).
			end := index - 1 ].
	(index := string indexOfSubCollection: '://') > 0
		ifTrue: [
			self scheme: (string copyFrom: 1 to: index - 1).
			start := index + 3 ]
		ifFalse: [ 
			defaultScheme ifNotNil: [ self scheme: defaultScheme ] ].
	self hasScheme 
		ifTrue: [  
			(index := string indexOf: $/ startingAt: start) > 0
				ifTrue: [
					self parseAuthority: (AnsiReadStream on: string from: start to: index - 1).
					start := index ]
				ifFalse: [ 
					^ self parseAuthority: (AnsiReadStream on: string from: start to: end) ] ].
	self parsePath: (AnsiReadStream on: string from: start to: end)