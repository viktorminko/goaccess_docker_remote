#!/bin/bash

echo "Downloading and following remote log"
ssh -o "StrictHostKeyChecking no" $REMOTE_USER@$REMOTE_HOST tail -F -n +0 $REMOTE_LOG_FILE > /home/logs/data.log