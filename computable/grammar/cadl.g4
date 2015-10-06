//
// description: Antlr4 grammar for cADL non-primitves sub-syntax of Archetype Definition Language (ADL2)
// author:      Thomas Beale <thomas.beale@openehr.org>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar cadl;
import adl_rules;

//
//  ======================= Parser rules ========================
//

c_complex_object: type_id '[' ( ROOT_ID_CODE | ID_CODE ) ']' c_occurrences? ( SYM_MATCHES '{' c_attribute_def+ '}' )? ;

c_objects: ( sibling_order? c_non_primitive_object+ ) | c_primitive_object ;

sibling_order: ( SYM_AFTER | SYM_BEFORE ) '[' ID_CODE ']' ;

c_non_primitive_object:
      c_complex_object
    | c_archetype_root
    | c_complex_object_proxy
    | archetype_slot
    ;

c_archetype_root: SYM_USE_ARCHETYPE type_id '[' ID_CODE ',' ARCHETYPE_REF ']' c_occurrences? ;

c_complex_object_proxy: SYM_USE_NODE type_id '[' ID_CODE ']' c_occurrences? adl_path ;

archetype_slot:
      c_archetype_slot_head SYM_MATCHES '{' c_includes? c_excludes? '}'
    | c_archetype_slot_head
    ;

c_archetype_slot_head: c_archetype_slot_id c_occurrences? ;

c_archetype_slot_id: SYM_ALLOW_ARCHETYPE type_id '[' ID_CODE ']' SYM_CLOSED? ;

c_attribute_def:
      c_attribute
    | c_attribute_tuple
    ;

c_attribute: adl_dir? attribute_id c_existence? c_cardinality? ( SYM_MATCHES '{' c_objects '}' )? ;

adl_dir  : '/' | ( adl_path_segment+ '/' ) ;

c_attribute_tuple: '[' attribute_id ( ',' attribute_id )* ']' SYM_MATCHES '{' c_object_tuple ( ',' c_object_tuple )* '}' ;

c_object_tuple: '[' c_object_tuple_items ']' ;

c_object_tuple_items: '{' c_primitive_object '}' ( ',' '{' c_primitive_object '}' )* ;

c_includes: SYM_INCLUDE assertion+ ;
c_excludes: SYM_EXCLUDE assertion+ ;

c_existence: SYM_EXISTENCE SYM_MATCHES '{' existence '}' ;
existence: INTEGER | INTEGER '..' INTEGER ;

c_cardinality: SYM_CARDINALITY SYM_MATCHES '{' cardinality '}' ;
cardinality: multiplicity ( multiplicity_mod multiplicity_mod? )? ; // max of two
ordering_mod : ';' ( SYM_ORDERED | SYM_UNORDERED ) ;
unique_mod : ';' SYM_UNIQUE ;
multiplicity_mod: ordering_mod | unique_mod ;

c_occurrences: SYM_OCCURRENCES SYM_MATCHES '{' multiplicity '}' ;

multiplicity: INTEGER | '*' | INTEGER SYM_INTERVAL_SEP ( INTEGER | '*' ) ;

//
//  ======================= Lexical rules ========================
//


// ---------- various ADL2 codes

ROOT_ID_CODE : 'id1' ('.1')* ;
ID_CODE      : 'id' CODE_STR ;
AT_CODE      : 'at' CODE_STR ;
AC_CODE      : 'ac' CODE_STR ;
fragment CODE_STR : ('0' | [1-9][0-9]*) ( '.' ('0' | [1-9][0-9]* ))* ;

// ---------- ISO8601-based date/time/duration constraint patterns

DATE_CONSTRAINT_PATTERN :       YEAR_PATTERN '-' MONTH_PATTERN '-' DAY_PATTERN ;
TIME_CONSTRAINT_PATTERN :       HOUR_PATTERN ':' MINUTE_PATTERN ':' SECOND_PATTERN ;
DATE_TIME_CONSTRAINT_PATTERN :  DATE_CONSTRAINT_PATTERN 'T' TIME_CONSTRAINT_PATTERN ;
DURATION_CONSTRAINT_PATTERN :   'P' [yY]?[mM]?[Ww]?[dD]? ('T' [hH]?[mM]?[sS]?)? ;

// date time pattern
fragment YEAR_PATTERN:	 		('yyy' 'y'?) | ('YYY' 'Y'?);
fragment MONTH_PATTERN:	        'mm' | 'MM' | '??' | 'XX';
fragment DAY_PATTERN:			'dd' | 'DD' | '??' | 'XX';
fragment HOUR_PATTERN:			'hh' | 'HH' | '??' | 'XX';
fragment MINUTE_PATTERN:	    'mm' | 'MM' | '??' | 'XX';
fragment SECOND_PATTERN:		'ss' | 'SS' | '??' | 'XX';

