#!/usr/bin/bash

#
# ============== Definitions =============
#
USAGE='$0 [-p] : generate publishing outputs; HTML by default
  -p : generate PDF as well
'
# if launched from inside spec-publish-asciidoc git clone area, we don't need to cd out to get
# the resources; if in any other repo, we do. This is complicated by the need to make the directories
# work not just in a normal file system, but on Github, which doesn't appear to see the repo root
# points as being inside a 'directory'
resources_git_repo_name=spec-publish-asciidoc
if [ "$(basename $(pwd))" != "$resources_git_repo_name" ]; then
	resources_git_cd=../$resources_git_repo_name/
fi
resources_dir=../../${resources_git_cd}resources ## relative to doc dirs 2 level down

year=`date +%G`
stylesdir=${resources_dir}/css
stylesheet=openehr.css
master_doc_name=master.adoc

#
# ============== functions =============
#

run_asciidoctor () {
	out_file=${1}.html
	asciidoctor -a current_year=$year -a resources_dir=$resources_dir -a stylesdir=$stylesdir -a stylesheet=$stylesheet --out-file=$out_file $2
	echo generated $(pwd)/$out_file
}

run_asciidoctor_pdf () {
	out_file=${1}.pdf

	# work out the options
	pdf_opts="-a current_year=$year \
		-a stylesdir=$stylesdir \
		-a resources_dir=$resources_dir \
		-a pdf-style=openehr_pdf_theme.yml \
		-a pdf-stylesdir=$resources_dir \
		-r asciidoctor-pdf -b pdf"
	# -a pdf-fontsdir=path/to/fonts 
	if [ "$pdf_trace" = true ]; then
		pdf_opts="${pdf_opts} --trace"
	fi

	asciidoctor ${pdf_opts} --out-file=$out_file $2
	echo generated $(pwd)/$out_file
}

# run a command in a standard way
# $1 = command string
do_cmd () {
	echo "------ Running: $1"
	eval $1 2>&1
}

usage() { echo "Usage: $0 [-hpt]" 1>&2; exit 1; }
#
# ================== main =================
#
while getopts "hpt" o; do
    case "${o}" in
        p)
            gen_pdf=true
            ;;
        t)
            pdf_trace=true
            ;;
        h)
            usage
            ;;
        *)
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
