//
//  description: Antlr4 grammar for Archetype Definition Language (ADL2)
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2015 openEHR Foundation
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar adl;
import odin_values, base_patterns;

//
//  ============== Parser rules ==============
//

input:
      archetype
    | template
    | template_overlay
    | operational_template
    ;

archetype: 
    SYM_ARCHETYPE arch_meta_data? 
    V_ARCHETYPE_ID 
    arch_specialisation?
    arch_language 
    arch_description 
    arch_definition 
    arch_rules? 
    arch_terminology 
    arch_annotations? 
    ;

template: 
    SYM_TEMPLATE arch_meta_data? 
    V_ARCHETYPE_ID 
    arch_specialisation 
    arch_language 
    arch_description 
    arch_definition 
    arch_rules? 
    arch_terminology 
    arch_annotations? 
    (HLINE template_overlay)*
    ;

template_overlay: 
    SYM_TEMPLATE_OVERLAY 
    V_ARCHETYPE_ID 
    arch_specialisation 
    arch_definition 
    arch_terminology 
    ;

operational_template: 
    SYM_OPERATIONAL_TEMPLATE arch_meta_data? 
    V_ARCHETYPE_ID 
    arch_language 
    arch_description 
    arch_definition 
    arch_rules? 
    arch_terminology 
    arch_annotations? 
    arch_component_terminologies?
    ;

arch_meta_data: '(' arch_meta_data_item  (';' arch_meta_data_item )* ')' ;

arch_meta_data_item:
      SYM_ADL_VERSION '=' V_DOTTED_NUMERIC
    | SYM_UID '=' ( V_DOTTED_NUMERIC | V_VALUE )
    | SYM_BUILD_UID '=' V_VALUE
    | SYM_RM_RELEASE '=' V_DOTTED_NUMERIC
    | SYM_IS_CONTROLLED
    | SYM_IS_GENERATED
    | V_IDENTIFIER  ( '=' ( V_IDENTIFIER | V_VALUE ))?
    | V_VALUE
    ;

arch_specialisation : SPECIALIZE_SECTION V_ARCHETYPE_ID ;
arch_language        : LANGUAGE_SECTION V_ODIN_LINE+ ;
arch_description    : DESCRIPTION_SECTION V_ODIN_LINE+ ;
arch_definition        : DEFINITION_SECTION V_CADL_LINE+ ;
arch_rules            : RULES_SECTION V_RULES_LINE+ ;
arch_terminology    : TERMINOLOGY_SECTION V_ODIN_LINE+ ;
arch_annotations    : ANNOTATIONS_SECTION V_ODIN_LINE+ ;
arch_component_terminologies: COMPONENT_TERMINOLOGIES_SECTION V_ODIN_LINE+ ;

//
//  ============== Lexical rules ==============
//

SYM_ARCHETYPE             : ^[Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;
SYM_TEMPLATE_OVERLAY     : ^[Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee]'_'[Oo][Vv][Ee][Rr][Ll][Aa][Yy] ;
SYM_TEMPLATE             : ^[Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee] ;
SYM_OPERATIONAL_TEMPLATE : ^[Oo][Pp][Ee][Rr][Aa][Tt][Ii][Oo][Nn][Aa][Ll]_[Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee] ;

// meta-data keywords
SYM_ADL_VERSION     : [Aa][Dd][Ll]_[Vv][Ee][Rr][Ss][Ii][Oo][Nn] ;
SYM_RM_RELEASE         : [Rr][Mm]_[Rr][Ee][Ll][Ee][Aa][Ss][Ee] ;
SYM_IS_CONTROLLED     : [Cc][Oo][Nn][Nn][Tt][Rr][Oo][Ll][Ll][Ee][Dd] ;
SYM_IS_GENERATED     : [Gg][Ee][Nn][Ee][Rr][Aa][Tt][Ee][Dd] ;
SYM_UID             : [Uu][Ii][Dd] ;
SYM_BUILD_UID         : [Bb][Uu][Ii][Ll][Dd]_[Uu][Ii][Dd] ;

// keywords identifying various ADL sections

SPECIALISE_SECTION     : ^SYM_SPECIALISE[ \t\r]*\n ;
LANGUAGE_SECTION     : ^SYM_LANGUAGE[ \t\r]*\n         -> pushMode (ODIN) ;
DESCRIPTION_SECTION    : ^SYM_DESCRIPTION[ \t\r]*\n     -> pushMode (ODIN) ;
DEFINITION_SECTION  : ^SYM_DEFINITION[ \t\r]*\n      -> pushMode (CADL) ;
RULES_SECTION         : ^SYM_RULES[ \t\r]*\n             -> pushMode (RULES) ;
TERMINOLOGY_SECTION : ^SYM_TERMINOLOGY[ \t\r]*\n     -> pushMode (ODIN) ;
ANNOTATIONS_SECTION : ^SYM_ANNOTATIONS[ \t\r]*\n     -> pushMode (ODIN) ;
COMPONENT_TERMINOLOGIES_SECTION : ^SYM_COMPONENT_TERMINOLOGIES[ \t\r]*\n -> pushMode (ODIN) ;

fragment SYM_SPECIALIZE  : ^[Ss][Pp][Ee][Cc][Ii][Aa][Ll][Ii][SsZz][Ee][ \t\r]*\n ;
fragment SYM_LANGUAGE      : [Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee] ;
fragment SYM_DESCRIPTION : [Dd][Ee][Ss][Cc][Rr][Ii][Pp][Tt][Ii][Oo][Nn] ;
fragment SYM_DEFINITION  : [Dd][Ee][Ff][Ii][Nn][Ii][Tt][Ii][Oo][Nn] ;
fragment SYM_RULES          : [Rr][Uu][Ll][Ee][Ss] ;
fragment SYM_TERMINOLOGY : [Tt][Ee][Rr][Mm][Ii][Nn][Oo][Ll][Oo][Gg][Yy] ;
fragment SYM_ANNOTATIONS : [Aa][Nn][Nn][Oo][Tt][Aa][Tt][Ii][Oo][Nn][Ss] ;
fragment SYM_COMPONENT_TERMINOLOGIES : [Cc][Oo][Mm][Pp][Oo][Nn][Ee][Nn][Tt]'_'[Tt][Ee][Rr][Mm][Ii][Nn][Oo][Ll][Oo][Gg][Ii][Ee][Ss] ;
fragment SECTION_KEYWORD : SYM_LANGUAGE | SYM_DESCRIPTION | SYM_DEFINITION | SYM_RULES | SYM_TERMINOLOGY | SYM_ANNOTATIONS | SYM_COMPONENT_TERMINOLOGIES ;

// -------- miscellaneous --------

HLINE : ^"-"{20,}[ \t\r]*\n ;

// ---------- ODIN section -----------
mode ODIN;
EXIT_ODIN:        ^SECTION_KEYWORD     -> popMode ;
V_ODIN_LINE:     .*\n ;    // gather any thing else, line by line

// ---------- CADL section -----------
mode CADL;
EXIT_CADL:        ^SECTION_KEYWORD     -> popMode ;
V_CADL_LINE:     .*\n ;    // gather any thing else, line by line

// ---------- RULES section -----------
mode RULES;
EXIT_RULES:        ^SECTION_KEYWORD     -> popMode ;
V_RULES_LINE:     .*\n ;    // gather any thing else, line by line

