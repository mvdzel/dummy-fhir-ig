# Build this IG

```
> docker run --rm -it -v $(pwd):/home/publisher/ig hl7fhir/ig-publisher-base:latest
@> _updatePublisher.sh
@> _genonce.sh
```

# Build this IG in GitHub Codespaces

Requires "4 cores, 16 GB RAM" machine.

```
@> sudo apt-get update
@> sudo apt-get install jekyll graphviz wget

@> curl -L https://build.fhir.org/ig/FHIR/openehr-base-ig/package.tgz -o input-cache/openehr.base.tgz
@> mkdir ~/.fhir/packages/openehr.base#0.1.0
@> tar -zxvf input-cache/openehr.base.tgz -C ~/.fhir/packages/openehr.base#0.1.0

@> curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o input-cache/publisher.jar
@> java -jar input-cache/publisher.jar -ig ig.ini
```