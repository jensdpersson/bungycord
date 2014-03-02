STATUS_OK=200
STATUS_CREATED=201
STATUS_ACCEPTED=202
STATUS_NO_CONTENT=204
STATUS_PARTIAL_CONTENT=206

STATUS_FOUND=302
STATUS_SEE_OTHER=303
STATUS_NOT_MODIFIED=304

STATUS_BAD_REQUEST=400
STATUS_UNAUTHORIZED=401
STATUS_FORBIDDEN=403
STATUS_NOT_FOUND=404

STATUS_INTERNAL_ERROR=500
STATUS_NOT_IMPLEMENTED=501
STATUS_HTTP_VERSION_NOT_SUPPORTED=505

RESPONSE_SHORT_100='Continue'
RESPONSE_SHORT_101='Switching Protocols'

RESPONSE_SHORT_200='OK'
RESPONSE_SHORT_201='Created'
RESPONSE_SHORT_202='Accepted'
RESPONSE_SHORT_203='Non-Authoritative Information'
RESPONSE_SHORT_204='No Content'
RESPONSE_SHORT_205='Reset Content'
RESPONSE_SHORT_206='Partial Content'

RESPONSE_SHORT_300='Multiple Choices'
RESPONSE_SHORT_301='Moved Permanently'
RESPONSE_SHORT_302='Found'
RESPONSE_SHORT_303='See Other'
RESPONSE_SHORT_304='Not Modified'
RESPONSE_SHORT_305='Use Proxy'
RESPONSE_SHORT_307='Temporary Redirect'

RESPONSE_SHORT_400='Bad Request'
RESPONSE_SHORT_401='Unauthorized'
RESPONSE_SHORT_402='Payment Required'
RESPONSE_SHORT_403='Forbidden'
RESPONSE_SHORT_404='Not Found'
RESPONSE_SHORT_405='Method Not Allowed'
RESPONSE_SHORT_406='Not Acceptable'
RESPONSE_SHORT_407='Proxy Authentication Required'
RESPONSE_SHORT_408='Request Timeout'
RESPONSE_SHORT_409='Conflict'
RESPONSE_SHORT_410='Gone'
RESPONSE_SHORT_411='Length Required'
RESPONSE_SHORT_412='Precondition Failed'
RESPONSE_SHORT_413='Request Entity Too Large'
RESPONSE_SHORT_414='Request-URI Too Long'
RESPONSE_SHORT_415='Unsupported Media Type'
RESPONSE_SHORT_416='Requested Range Not Satisfiable'
RESPONSE_SHORT_417='Expectation Failed'

RESPONSE_SHORT_500='Internal Server Error'
RESPONSE_SHORT_501='Not Implemented'
RESPONSE_SHORT_502='Bad Gateway'
RESPONSE_SHORT_503='Service Unavailable'
RESPONSE_SHORT_504='Gateway Timeout'
RESPONSE_SHORT_505='HTTP Version Not Supported'

RESPONSE_LONG_100='Request received, please continue'
RESPONSE_LONG_101='Switching to new protocol; obey Upgrade header'

RESPONSE_LONG_200='Request fulfilled, document follows'
RESPONSE_LONG_201='Document created, URL follows'
RESPONSE_LONG_202='Request accepted, processing continues off-line'
RESPONSE_LONG_203='Request fulfilled from cache'
RESPONSE_LONG_204='Request fulfilled, nothing follows'
RESPONSE_LONG_205='Clear input form for further input.'
RESPONSE_LONG_206='Partial content follows.'

RESPONSE_LONG_300='Object has several resources -- see URI list'
RESPONSE_LONG_301='Object moved permanently -- see URI list'
RESPONSE_LONG_302='Object moved temporarily -- see URI list'
RESPONSE_LONG_303='Object moved -- see Method and URL list'
RESPONSE_LONG_304='Document has not changed since given time'
RESPONSE_LONG_305='You must use proxy specified in Location to access this resource.'
RESPONSE_LONG_307='Object moved temporarily -- see URI list'

RESPONSE_LONG_400='Bad request syntax or unsupported method'
RESPONSE_LONG_401='No permission -- see authorization schemes'
RESPONSE_LONG_402='No payment -- see charging schemes'
RESPONSE_LONG_403='Request forbidden -- authorization will not help'
RESPONSE_LONG_404='Nothing matches the given URI'
RESPONSE_LONG_405='Specified method is invalid for this resource.'
RESPONSE_LONG_406='URI not available in preferred format.'
RESPONSE_LONG_407='You must authenticate with this proxy before proceeding.'
RESPONSE_LONG_408='Request timed out; try again later.'
RESPONSE_LONG_409='Request conflict.'
RESPONSE_LONG_410='URI no longer exists and has been permanently removed.'
RESPONSE_LONG_411='Client must specify Content-Length.'
RESPONSE_LONG_412='Precondition in headers is false.'
RESPONSE_LONG_413='Entity is too large.'
RESPONSE_LONG_414='URI is too long.'
RESPONSE_LONG_415='Entity body in unsupported format.'
RESPONSE_LONG_416='Cannot satisfy request range.'
RESPONSE_LONG_417='Expect condition could not be satisfied.'

RESPONSE_LONG_500='Server got itself in trouble'
RESPONSE_LONG_501='Server does not support this operation'
RESPONSE_LONG_502='Invalid responses from another server/proxy.'
RESPONSE_LONG_503='The server cannot process the request due to a high load'
RESPONSE_LONG_504='The gateway server did not receive a timely response'
RESPONSE_LONG_505='Cannot fulfill request.'
