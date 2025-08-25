# Build this IG

```
> docker run --name dummy-ig -it -v $(pwd):/home/publisher/ig -v $(pwd)/.fhir:/home/publisher/.fhir hl7fhir/ig-publisher-base:latest
@> _updatePublisher.sh
@> _genonce.sh
```

# Build this IG in GitHub Codespaces

## Setup

* Requires "4 cores, 16 GB RAM" machine.
* First 2 apt-get required because CodeSpace uses plain Ubuntu.

```
@> sudo apt-get update
@> sudo apt-get install jekyll graphviz wget
@> npm install -g http-server
@> ./_updatePublisher.sh
@> ./setup-openehr.sh
```

## Build

```
@> ./_genonce.sh
```
or
```
@> curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o input-cache/publisher.jar
(ADL) @> curl -L https://github.com/HL7/fhir-ig-publisher/releases/download/1.8.13/publisher.jar -o input-cache/publisher.jar
@> java -jar input-cache/publisher.jar -ig ig.ini
```

## View output

```
@> http-server output -s
```
