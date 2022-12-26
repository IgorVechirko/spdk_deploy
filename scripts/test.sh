#!/bin/bash

vars=$(sudo cat ./template_vars.json)

devNum=$(echo $vars|jq 'length')
echo "$devNum"

exit 0