set -e

exec 3>&1 # make stdout available as fd 3 for the result
exec 1>&2 # redirect all output to stderr for logging

# in_file_with_version() {
#   local artifacts_url=$1
#   local regex="(?<uri>$2)"
#   local version=$3
#
#   result=$(artifactory_files "$artifacts_url" "$regex")
#   echo $result | jq --arg v "$version" '[foreach .[] as $item ([]; $item ; if $item.version == $v then $item else empty end)]'
#
# }
#

# retrieve current file version
# e.g. curl -R -I $1
check_version() {
  # retrieves HTTP header of file URL response
  local httpHeader=$(curl -R -I $1 2>&1 | grep 'Last-Modified:')
  # Checks if field "Last-Modified" exists in HTTP header and transform it into timestamp string
  # if that field is not present, return current timestamp
  if [ -z "$httpHeader" ]
  then
        # echo "Last-Modified information not returned for targeted file. Using current date's timestamp as version number."
        local dateString=$(date)
  else
        # echo "$httpHeader"
        local dateString=$(echo "$httpHeader" | sed -e "s/Last-Modified: //" | cut -d',' -f 2)
  fi

  date +"%Y%m%d%H%S" -d "$dateString"
}
