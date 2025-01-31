
# Zulip Issues

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

# Features

## History Bundle with Provenance for resources

Make sure you have **not** marked the Bundle as Example in the IG (in FSH use #definition).

[resource/HistoryBundle.json](Bundle-hx.json.html) has history Provenance for [StructureDefinition/Patient](StructureDefinition-Patient.html)
will enable [History tab](StructureDefinition-Patient.profile.history.html)

## Inserting a preprocess (onLoad.extend) script

Added in my-template/config.json -> ant-my.xml that will exec script.sh after sushi runs.
Have not found a way to call something before sushi runs.
Seems like IG Publisher first runs sushi and then ant.
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
