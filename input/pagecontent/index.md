
## Zulip Issues

* [Ignore unsupported Code Systems](https://chat.fhir.org/#narrow/stream/179252-IG-creation/topic/Unsupported.20code.20systems.20ignore)
* [SNOMED edition expectations / Parameters-expansion-params](https://chat.fhir.org/#narrow/channel/179252-IG-creation/topic/SNOMED.20edition.20expectations)
    * [Parameters-exp-params.json](Parameters-exp-params.html)
    * [ValueSet-SmokingStatus.json](ValueSet-SmokingStatus.html)
* [compliesWithProfile](https://chat.fhir.org/#narrow/channel/179252-IG-creation/topic/compliesWithProfile.20issue)
    * [StructureDefinition-Patient.json](StructureDefinition-Patient.html)
    * And add the following to the ImplementationGuide resource
        ```json
        "definition": {
            "extension": [
                {
                    "url": "http://hl7.org/fhir/tools/StructureDefinition/ig-link-dependency",
                    "valueCode": "hl7.fhir.us.core#6.1.0"
                }
            ]
        }
        ```
* [Relative link instead of absolute link in narrativeLink extension to originalText extension](https://github.com/HL7/fhir-ig-publisher/issues/898#issuecomment-2715782606)
    * See [Patient Profile](StructureDefinition-Patient-definitions.html#key_Patient.extension:originalText)

## Features

* [Guidance for FHIR IG Creation](https://build.fhir.org/ig/FHIR/ig-guidance/)

### History Bundle with Provenance for resources

Make sure you have **not** marked the Bundle as Example in the IG (in FSH use #definition).

[resource/HistoryBundle.json](Bundle-hx.json.html) has history Provenance for [StructureDefinition/Patient](StructureDefinition-Patient.html)
will enable [History tab](StructureDefinition-Patient.profile.history.html)

### Inserting a preprocess (onLoad.extend) script

The IG Publisher first runs sushi and then ant.
Have not found a good way to call something before sushi runs.
Added in my-template/config.json -> ant-my.xml that will exec script.sh after sushi runs.
And this is probably NOT allowed on the HL7 CI Build.

config.json:
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

### EView

* See intro of [Patient EView](StructureDefinition-Patient.html)

### OpenEHR ADL Import
 
<div class="dragon" markdown="1">
* You need IG Publisher 2.0.4 for OpenEHR ADL Support.
* Check out [OpenEHR Test IG](https://github.com/FHIR/openehr-test/).
</div>
<br/>

1. Download package.tgz from https://build.fhir.org/ig/FHIR/openehr-base-ig/index.html
2. Extract in ~/.fhir/packages/openehr.base#0.1.0
3. DependOn http://openehr.org/fhir/ImplementationGuide/openehr.base
4. Download ADL 2.0 from [CKM](https://ckm.openehr.org/)
    * n.b. file-extensie `.adl`
    * and place in input/archetypes
5. ~~[9-apr-2025] Somewhere after FHIR IG Publisher Version 1.8.13 and before v1.8.23 ADL import was disabled~~
    * ~~Added output json in input/resources/StructureDefinition-openEHR-EHR-EVALUATION.problem-diagnosis.v1.4.1.json~~
    * ~~Resulting Logical Model: [StructureDefinition-openEHR-EHR-EVALUATION.problem-diagnosis.v1.4.1](StructureDefinition-openEHR-EHR-EVALUATION.problem-diagnosis.v1.4.1.html)~~
6. [3-jun-2025] During OpenEHR/HL7 Joint meeting IG Publisher Version 2.0.4 includes ADL support again.
7. Set http://hl7.org/fhir/tools/CodeSystem/ig-parameters#openehr to true - *not getting the OpenEHR tabs yet; maybe because we do R4*
```xml
    <parameter>
      <code value="openehr"/>
      <value value="true"/>
    </parameter>
```

## Color/Grayscale toggle

Added to my-template:
* content/assets/css - the css file
* includes/_append.fragment-css.html - include css needed
* includes/_append.fragment-footer.html - the button (+script) to toggle