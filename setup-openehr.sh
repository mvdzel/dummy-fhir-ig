#!/bin/bash
curl -L https://build.fhir.org/ig/FHIR/openehr-base-ig/package.tgz -o input-cache/openehr.base.package.tgz
mkdir -p ~/.fhir/packages/openehr.base#0.1.0
tar -zxvf input-cache/openehr.base.package.tgz -C ~/.fhir/packages/openehr.base#0.1.0