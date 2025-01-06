
# Zulip Issues

## Ignore unsupported Code Systems
https://chat.fhir.org/#narrow/stream/179252-IG-creation/topic/Unsupported.20code.20systems.20ignore

## SNOMED edition expectations / Parameters-expansion-params
https://chat.fhir.org/#narrow/channel/179252-IG-creation/topic/SNOMED.20edition.20expectations
+ input/resources/Parameters-exp-params.json
+ input/resources/ValueSet-Smoking-sct.json

## compliesWithProfile
https://chat.fhir.org/#narrow/channel/179252-IG-creation/topic/compliesWithProfile.20issue
+ input/resources/StructureDefinition-Patient.json

# Build this IG
docker run --rm -it -v $(pwd):/home/publisher/ig hl7fhir/ig-publisher-base:latest

