#!/usr/bin/bash

#
# ============== Definitions =============
#
USAGE='$0 [-p] : generate publishing outputs; HTML by default
  -p : generate PDF as well
'
year=`date +%G`
#spec_asciidoc_git_dir=$(cd ../spec-publish-asciidoc; pwd)
spec_asciidoc_git_dir=../../../spec-publish-asciidoc ## relative to doc dirs 2 level down
stylesdir=${spec_asciidoc_git_dir}/css
stylesheet=openehr.css
master_doc_name=master.adoc

#
# ============== functions =============
#

run_asciidoctor () {
	out_file=${1}.html
	asciidoctor -a current_year=$year -a spec_asciidoc_git_dir=$spec_asciidoc_git_dir -a stylesdir=$stylesdir -a stylesheet=$stylesheet --out-file=$out_file $2
	echo generated $(pwd)/$out_file
}

run_asciidoctor_pdf () {
	out_file=${1}.pdf
	asciidoctor -a current_year=$year -a spec_asciidoc_git_dir=$spec_asciidoc_git_dir -a stylesdir=$stylesdir -r asciidoctor-pdf -b pdf --out-file=$out_file $2
	echo generated $(pwd)/$out_file
}

# run a command in a standard way
# $1 = command string
do_cmd () {
	echo "------ Running: $1"
	eval $1 2>&1
}

usage() { echo "Usage: $0 [-p]" 1>&2; exit 1; }
#
# ================== main =================
#
while getopts "hp" o; do
    case "${o}" in
        p)
            gen_pdf=true
            ;;
        h)
            usage
            ;;
    esac
done
shift $((OPTIND-1))


topdir=${PWD}
find docs -name $master_doc_name | \
while read docpath
do
	docdir=$(dirname $docpath)
	docname=$(basename $docdir)
	echo ---------------------- publishing $docname ----------------------
	olddir=$(pwd)
	cd $docdir
	run_asciidoctor ${docname} $master_doc_name
	if [ "$gen_pdf" = true ]; then
		run_asciidoctor_pdf ${docname} $master_doc_name
	fi
	cd $olddir
done
