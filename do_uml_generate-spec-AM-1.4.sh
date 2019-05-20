rm -f docs/UML/AOM1.4/classes/*.*
rm -f docs/UML/AOM1.4/diagrams/*.*

../specifications-AA_GLOBAL/bin/uml_generate.sh -i 1.4 -r AM -o docs/UML/AOM1.4 computable/UML/openEHR_UML-AM-14.mdzip
