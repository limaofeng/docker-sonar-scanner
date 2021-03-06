#!/bin/bash

set -e

VERSION=${CI_BUILD_TAG} || ${CI_BUILD_ID}
PROJECT_KEY=${SONAR_PROJECT_KEY} || ${CI_PROJECT_NAMESPACE}:${CI_PROJECT_NAME}
PROJECT_NAME=${SONAR_PROJECT_NAME} || ${CI_PROJECT_NAME}

OPTS="-Dsonar.gitlab.project_id=${CI_PROJECT_ID} -Dsonar.gitlab.commit_sha=${CI_BUILD_REF} -Dsonar.gitlab.ref_name=${CI_BUILD_REF_NAME} -Dsonar.analysis.mode=preview -Dsonar.issuesReport.console.enable=true -Dsonar.verbose=true"

# TODO: Improve entrypoint to support gitlab-runner
cd ${CI_PROJECT_DIR}
if [[ ! -z $SONAR_TOKEN ]]; then
  ${SONAR_SCANNER_HOME}/bin/sonar-scanner -X -Dsonar.host.url=${SONAR_HOST} -Dsonar.login=${SONAR_TOKEN} -Dsonar.projectKey=${PROJECT_KEY} -Dsonar.projectName=${PROJECT_NAME} -Dsonar.projectVersion=${VERSION} -Dsonar.sources=${CI_PROJECT_DIR}
else
  ${SONAR_SCANNER_HOME}/bin/sonar-scanner -X ${OPTS}
fi
