#!/bin/bash

IMAGE_TAG=$(../tools/image-tag)

NS=meetup-demo-${IMAGE_TAG}
NS=$(tr "[A-Z]" "[a-z]" <<<$NS)

oc project ${NS}

helm uninstall vtodos
oc adm policy remove-scc-from-user privileged -z vtodos-vue-todos
oc delete project ${NS}
