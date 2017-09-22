rm docs/UML/classes/*.*
rm docs/UML/diagrams/*.*

./uml_generate.sh -i {am_release} -r AM -o docs/UML computable/UML/openEHR_UML-AM.mdzip
./uml_generate.sh -o docs/UML computable/UML/ADL-examples.mdzip
