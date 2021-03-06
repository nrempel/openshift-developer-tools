#!/bin/bash

OCTOOLSBIN=$(dirname $0)

usage() { #Usage function
  cat <<-EOF
  Tool to load data from the APISpec/TestData folder into the app

  Usage: ./loadData.sh [ -h -x -e <DataLoadEnv> ]

  OPTIONS:
  ========
    -h prints the usage for the script
    -x run the script in debug mode to see what's happening
    -e <server> load data into the specified server (default: ${LOAD_DATA_SERVER}, Options: local/dev/test/prod/<URL>)
    -p <profile> load a specific settings profile; setting.<profile>.sh
    -P Use the default settings profile; settings.sh.  Use this flag to ignore all but the default 
       settings profile when there is more than one settings profile defined for a project.    

  Update settings.sh and settings.local.sh files to set defaults

EOF
exit
}

# In case you wanted to check what variables were passed
# echo "flags = $*"
while getopts p:Pe:gh FLAG; do
  case $FLAG in
    e ) LOAD_DATA_SERVER=$OPTARG ;;
    p ) export PROFILE=$OPTARG ;;
    P ) export IGNORE_PROFILES=1 ;;
    x ) export DEBUG=1 ;;
    h ) usage ;;
    \? ) #unrecognized option - show help
      echo -e \\n"Invalid script option: -${OPTARG}"\\n
      usage
      ;;
  esac
done

# Shift the parameters in case there any more to be used
shift $((OPTIND-1))
# echo Remaining arguments: $@

if [ -f ${OCTOOLSBIN}/settings.sh ]; then
  . ${OCTOOLSBIN}/settings.sh
fi

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

# Load Test Data
echo -e "Loading data into TheOrgBook Server: ${LOAD_DATA_SERVER}"
pushd ../APISpec/TestData >/dev/null
./load-all.sh ${LOAD_DATA_SERVER}
popd >/dev/null
