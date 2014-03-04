#!/bin/sh
#
# REST web server
#
# Builds on the basic web server in http-server.sh
#

BC_HOME=${BC_HOME:-$(dirname $0)}

. ${BC_HOME}/http-server.sh

WEB_HOME=${WEB_HOME:-${BC_HOME}/../html}

bc_handle_request()
# Handle a single request from a client.
#
# Redefining the function from http-server.sh
#
# Parameters:
#   command
#   path
{
    local command="$1"; shift
    local path="$1"; shift

    # Make sure we have a trailing slash on the path
    path=${path%/}/

    sfutil_info "Performing $command on $path"
    cd ${WEB_HOME}

    bc_rest_traverse_resources "$command" "$path"
}

bc_rest_traverse_resources()
# Traverse resource hierarchy
#
# Parameters:
#   command
#   path
{
    local command="$1"; shift
    local path="$1"; shift

    local head=${path%%/*}
    local tail=${path#*/}

    if [ -z "${head}" ]; then
	# This is the root, cd to the WEB_HOME directory
	cd ${WEB_HOME}
    else
	# First split query parameters from the path. They should only
	# appear on the leaf
	local path_nq=${head%%\?*}
	local querypart=${head#*\?}
	if [ "${querypart}" = "${head}" ]; then
	    querypart=""
	fi

	# Then split path segment into the actual path and matrix
	# parameters
	local segment=${path_nq%%;*}
	local matrix=${path_nq#*;}
	if [ "${matrix}" = "${path_nq}" ]; then
	    matrix=""
	fi

	sfutil_info "In resource $segment, tail is $tail, directory $(pwd)"
	# This is a subresource. We have two ways of obtaining this
	# resource.
	#
	#   1. There's a subdirectory or link in the current
	#      directory. We cd to it and continue traversing the
	#      resource tree.
	#
	#   2. There's a script named 'subresource'. Execute it
	#      to perform the rest of the traversal and execution
	#      of the method
	#
	
	if [ -d "${segment}" ]; then
	    sfutil_info "Found resource directory $segment"
	    cd "${segment}"

	elif [ -x subresource ]; then
	    . subresource
	    bc_traverse_resource "$segment" "$matrix" || {
		# Return code decides if we should generate response or not?
		bc_send_error "$command" 404 "$path is not found on this server"
		return
	    }

	elif [ -n "${tail}" ]; then
	    # Hmm, no directory, and no subresource command, but we
	    # have more resources to traverse. Must be an unknown
	    # resource.
	    bc_send_error "$command" 404 "$path is not found on this server"
	    return
	fi
    fi

    if [ -n "$tail" ]; then
	# Traverse to next subresource
	bc_rest_traverse_resources "$command" "$tail"
    else
	# We found the leaf resource, time to execute the
	# method
	if [ -x "${segment}" ]; then
	    sfutil_info "Found resource $segment as an executable"
	    # Export stuff using CGI spec
	    ./${segment}

	elif [ -r "${segment}" ]; then
	    sfutil_info "Found resource $segment as a static file"
	    bc_serve_static_file "${segment}"

	elif [ -x subresource ]; then
	    sfutil_info "Found subresource script for $segment"
	    . subresource
	    eval "bc_${command} ${querypart:+-q=${querypart}} ${matrix:+-m=${matrix}} ${segment}"

	else
	    bc_send_error "$command" 404 "$path is not found on this server"
	fi
    fi
}

if [ $(basename $0) = 'rest-server.sh' ]; then
    bc_handle
fi
