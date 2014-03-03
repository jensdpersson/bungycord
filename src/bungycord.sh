#!/bin/sh
#
# The bungycord library
#

BC_HOME=${BC_HOME:-$(dirname $0)}

. ${BC_HOME}/sfutil-base.subr
. ${BC_HOME}/response-codes.sh

# Source in config
[ -f ${BC_HOME}/../etc/bungycord.sh ] && . ${BC_HOME}/../etc/bungycord.sh

# Log to file, and not to stdout/stderr
SFUTIL_LOG=${BC_LOG:-${BC_HOME}/../bungycord.log}
exec 3>/dev/null

BUNGYCORD_VERSION=0.1
# Probably bash centric...
SH_VERSION=$(sh --version | head -1)

BUNGYCORD_VERSIONSTRING="Bungycord/$BUNGYCORD_VERSION - $SH_VERSION"

bc_quote_html()
# Quote text to be HTML safe
{
    echo $1 | sed -e 's/&/&amp;/g' -e 's/</&lt;/g' -e 's/>/&gt;/g'
}

bc_status_message()
# Get text message for given status code
{
    eval 'echo $RESPONSE_SHORT_'$1
}

bc_status_explain()
# Get text message for given status code
{
    eval 'echo $RESPONSE_LONG_'$1
}

bc_send_response()
{
    local status="$1"; shift
    local message="$1"; shift

    if [ -z "${message}" ]; then
	message=$(bc_status_message $status)
    fi
    if [ "$REQUEST_VERSION" != 'HTTP/0.9' ]; then
	printf "HTTP/1.1 $status $message\r\n"
    fi
    bc_send_header 'Server' ${BUNGYCORD_VERSIONSTRING}
    bc_send_header 'Date' $(date -u)
}

bc_send_header()
# Write a header to the response
#
# If the header is 'Connection' and the value is 'close', close the
# connection after replying to the client. If it is 'keep-alive', do
# not close it.
#
{
    local header="$1"; shift
    local value="$@"; shift
    if [ "$REQUEST_VERSION" != 'HTTP/0.9' ]; then
	printf "$header: $value\r\n"
    fi
    case "$header" in
	[Cc][Oo][Nn][Nn][Ee][Cc][Tt][Ii][Oo][Nn])
	    case "$value" in
		[Cc][Ll][Oo][Ss][Ee])
		    BC_CLOSE_CONNECTION=true ;;
		[Kk][Ee][Ee][Pp]-[Aa][Ll][Ii][Vv][Ee])
		    BC_CLOSE_CONNECTION=false ;;
	    esac
    esac
}

bc_end_headers()
# Write an end-of-headers marker
{
    if [ "$REQUEST_VERSION" != 'HTTP/0.9' ]; then
	printf "\r\n"
    fi
}

bc_send_error()
# Send error response to server
#
# Parameters:
#   command
#   status code
#   error message
{
    local command status message content_type explain
    command="$1"; shift
    status="$1"; shift
    message="${1:-$(bc_status_message $status)}"; shift
    content_type="${1:text/html}"; shift
    bc_send_response $status "$message"
    bc_send_header 'Content-Type' $content_type
    bc_send_header 'Connection' 'close'
    bc_end_headers

    if [ "$command" != 'HEAD' -a "$status" -ge 200 -a "$status" != 204 -a "$status" != 304 ]; then
	explain=$(bc_status_explain $status)
	message=$(bc_quote_html $message)
	. ${BC_HOME}/templates/error.html.sh
    fi

}
