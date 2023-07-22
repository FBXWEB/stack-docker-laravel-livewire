#!/bin/bash
echo "api_key:$ULTRAHOOK_API_KEY" > ~/.ultrahook
ultrahook -k $ULTRAHOOK_API_KEY asaas https://webserver:443