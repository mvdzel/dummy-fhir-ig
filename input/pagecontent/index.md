
## Zulip Issues

* [Ignore unsupported Code Systems](https://chat.fhir.org/#narrow/stream/179252-IG-creation/topic/Unsupported.20code.20systems.20ignore)
* [SNOMED edition expectations / Parameters-expansion-params](https://chat.fhir.org/#narrow/channel/179252-IG-creation/topic/SNOMED.20edition.20expectations)
    * [Parameters-exp-params.json](Parameters-exp-params.html)
    * [ValueSet-SmokingStatus.json](ValueSet-SmokingStatus.html)
* [Relative link instead of absolute link in narrativeLink extension to originalText extension](https://github.com/HL7/fhir-ig-publisher/issues/898#issuecomment-2715782606)
    * See [Patient Profile](StructureDefinition-Patient-definitions.html#key_Patient.extension:originalText)

## Features

* [Guidance for FHIR IG Creation](https://build.fhir.org/ig/FHIR/ig-guidance/)

### History Bundle with Provenance for resources

Make sure you have **not** marked the Bundle as Example in the IG (in FSH use #definition).

[resource/HistoryBundle.json](Bundle-hx.json.html) has history Provenance for [StructureDefinition/Patient](StructureDefinition-Patient.html)
will enable [History tab](StructureDefinition-Patient.profile.history.html)

### Inserting a preprocess script (onLoad.extend)

The IG Publisher first runs sushi and then ant.
Have not found a good way to call something before sushi runs.
Added in my-template/config.json -> ant-my.xml that will exec script.sh after sushi runs.
N.B. This is NOT allowed on the HL7 CI Build server, so you have to run this in your own GH Action.

my-template/config.json:
```json
{
  "script": "scripts/ant-my.xml",
  "otherScripts" : []
}
```

ant-my.xml
```xml
<project name="MyExtension">
    <import file="ant.xml"/>
    <target name="onLoad.extend" depends="onLoad.updateIg">
        <exec executable="/bin/sh" osfamily="unix" dir="script" outputproperty="script.output">
        <arg value="hello.sh"/>
        </exec>

        <concat destfile="input/includes/hello.log" append="true">${script.output}</concat>
        <!-- <echo file="script/hello.log" message="${script.output}"/> -->
    </target>
</project>
```

Output from script:
```
{% include hello.log %}
```

### Model ConceptMap with links

The trick is adding the `?codesystem` to the source and target canonical URIs and use the FHIR Paths as codes.

```json
  "group": [
    {
      "source": "http://vdzi.nl/fhir/StructureDefinition/Patient2?codesystem",
      "target": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient?codesystem",
      "element": [
        {
          "code": "Patient.name",
          "target": [
            {
              "code": "Patient.name",
              "equivalence": "equivalent"
            }
          ]
        }
      ]
    }
  ]
```

### Translations

* IG-Guidance: https://build.fhir.org/ig/FHIR/ig-guidance/languages.html (outdated)
* Current Example: https://github.com/uzinfocom-org/digital-health-ig

And add the following to the ImplementationGuide resource:
```json
      {
        "code": "i18n-default-lang",
        "value": "en"
      },
      {
        "code": "i18n-lang",
        "value": "nl"
      },
      {
        "code": "translation-sources",
        "value": "input/translations/nl"
      }
```

The IG Publisher generates the empty translations files in the translations folder. 
You can use that to populate the input/translations/nl folder.

### OpenEHR

#### OpenEHR Profile Views

To get "OpenEHR View" and "ADL" tabs in "Formal Views of Profile Content" you need to use a template that is based on `fhir2.base.template`. N.B. conflicts with `compliesWithProfile`.

#### EViews of all Profiles

* See intro of [Patient EView](StructureDefinition-Patient.html)
* Now included as 'Formal Views of Profile Content' tab 'openEHR View'

#### OpenEHR ADL Import
 
<div class="dragon" markdown="1">
* You need IG Publisher 2.0.4 for OpenEHR ADL Support.
* Check out [OpenEHR Test IG](https://github.com/FHIR/openehr-test/).
</div>
<br/>

1. Download ADL 2.0 from [CKM](https://ckm.openehr.org/)
    * n.b. file-extensie `.adl`
    * and place in input/archetypes
2. ~~[9-apr-2025] Somewhere after FHIR IG Publisher Version 1.8.13 and before v1.8.23 ADL import was disabled~~
    * ~~Added output json in input/resources/StructureDefinition-openEHR-EHR-EVALUATION.problem-diagnosis.v1.4.1.json~~
    * ~~Resulting Logical Model: [StructureDefinition-openEHR-EHR-EVALUATION.problem-diagnosis.v1.4.1](StructureDefinition-openEHR-EHR-EVALUATION.problem-diagnosis.v1.4.1.html)~~
3. [3-jun-2025] During OpenEHR/HL7 Joint meeting IG Publisher Version 2.0.4 includes ADL support again.

And add the following to the ImplementationGuide resource:
```json
    "dependsOn": [
      {
        "id": "openEHRbase",
        "uri": "http://openehr.org/fhir/ImplementationGuide/openehr.base",
        "packageId": "openehr.base",
        "version": "dev"
      }
    ]
    ...
    "parameter": [
      {
        "code": "path-resource",
        "value": "input/archetypes"
      },
      {
        "code": "openehr",
        "value": "true"
      }
    ]
```

## compliesWithProfile (multiple versions of the same dependsOn IG)

Applied in [StructureDefinition-Patient.json](StructureDefinition-Patient.html).

### using ig-link-dependency

This makes the link work. Results in a QA error `Canonical URL 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|6.1.0' does not resolve`.
This was a work around for a version handling "bug" in the IG publisher. us-core6 has a profile for lab observation Specimen and us-core5 did not. But loading both resulted in us-core5 to also expect the Specimen profile. 

[Zulip:compliesWithProfile](https://chat.fhir.org/#narrow/channel/179252-IG-creation/topic/compliesWithProfile.20issue)

And add the following to the ImplementationGuide resource:
```json
"definition": {
  "extension": [
    {
        "url": "http://hl7.org/fhir/tools/StructureDefinition/ig-link-dependency",
        "valueCode": "hl7.fhir.us.core#6.1.0"
    },
    {
        "url": "http://hl7.org/fhir/tools/StructureDefinition/ig-link-dependency",
        "valueCode": "hl7.fhir.us.core#7.0.0"
    }
  ]
}
```

### using npm package aliasing

<div class="dragon" markdown="1">
* You need IG Publisher 2.0.? for npm package aliasing.
* Template should be `fhir.base.template` based. `fhir2.base.template` looks to not support package aliassing; throws Exception on packageId already defined.
</div>

This makes the compliesWithProfile links work and resolves the QA error.

[Zulip:NPM Aliases](https://chat.fhir.org/#narrow/channel/179239-tooling/topic/NPM.20Aliases/with/517985527)

And add the following to the ImplementationGuide resource:
```json
"dependsOn": [
  {
    "id": "uscore6",
    "uri": "http://hl7.org/fhir/us/core/ImplementationGuide/hl7.fhir.us.core",
    "packageId": "v610@npm:hl7.fhir.us.core",
    "version": "6.1.0"
  }
]
```

## Color/Grayscale toggle

Added to my-template:
* content/assets/css - the css file
* includes/_append.fragment-css.html - include css needed
* includes/_append.fragment-footer.html - the button (+script) to toggle

## QA Resolutions

**Terminology**

* `No definition could be found for URL value 'http://va.gov/terminology/`

    Resolve by creating a NameSystem resource (either kind=identifier or codesystem) for the URL.

* `Error from https://tx.fhir.org/r4: Unable to provide support for code system http://vdzi.nl/fhir/CodeSystem/120.85-14.5`

    Codesystem is not in tx-server, resolve by own tx-server or defining the CodeSystem in your IG.
    