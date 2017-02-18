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
  local dateVersionFormat="%Y%m%d%H%S"
  local dateString=$(date +"$dateVersionFormat")

  if [ ! -z "$httpHeader" ]
  then
        # echo "Last-Modified information returned for targeted file. Extract date, removing day of the week string
        local tmpDateString=$(echo "$httpHeader" | sed -e "s/Last-Modified: //" | cut -d',' -f 2)
        # rfc1123Format="%d\ %b\ %Y\ %H:%M:%S\ GMT" - in order to work in boot2docker, it has to be outside of quotes in the command below
        local dateString=$(date +"$dateVersionFormat" -D %d\ %b\ %Y\ %H:%M:%S\ GMT -d "$tmpDateString")
  fi

  echo "[{\"ref\":\"$dateString\"}]" | jq .
}
