#!/bin/bash

AppList="App1"
EnvList="Env1"
releaseDeploy="1912.0.0"
Group="grp"


for AppName in $(echo $AppList | sed -n 1'p' | tr ',' '\n')
do
    for Env in $(echo $EnvList | sed -n 1'p' | tr ',' '\n')
    do
	AppEnv=$AppName"_"$Env
        sed -i 's/'$AppEnv': \(.*\)/'$AppEnv': \"'$releaseDeploy'\"/' /srv/pillar/set_app_version_id_$AppEnv.sls
	if [ $? -eq 0 ]; then
	 	echo "Release Version # set successfully on $AppEnv. See the summary report for more details"
                logger -p local7.info "Execution Successful $AppName"
	else
		echo "Failed to set release version on $AppEnv"
	fi
        salt '*' saltutil.refresh_pillar
    done
done
