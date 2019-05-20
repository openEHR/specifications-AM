rm -f docs/UML/classes/*.*
rm -f docs/UML/diagrams/*.*

../specifications-AA_GLOBAL/bin/uml_generate.sh -i {am_release} -r AM -o docs/UML computable/UML/openEHR_UML-AM.mdzip
../specifications-AA_GLOBAL/bin/uml_generate.sh -r AM -o docs/UML computable/UML/ADL-examples.mdzip

# the following generates the same files, but with Cambria font, used for ISO 13606 publication.
#rm docs/UML_13606/classes/*.*
#rm docs/UML_13606/diagrams/*.*
#./uml_generate.sh -i {am_release} -r AM -o docs/UML_13606 computable/UML/openEHR_UML-AM-ISO13606fontchange.mdzip 
#./uml_generate.sh -o docs/UML_13606 computable/UML/ADL-examples-ISO13606fontchange.mdzip
