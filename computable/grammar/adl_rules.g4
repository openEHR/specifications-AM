//
//  description: Antlr4 grammar for Rules sub-syntax of Archetype Definition Language (ADL2)
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2015 openEHR Foundation
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar adl_rules;
import adl_symbols, odin_values, base_patterns;

//
//  ============== Parser rules ==============
//

assertion:
      ( IDENTIFIER ':' )? boolean_node
    | cadl_constraint_expr
    ;

boolean_node:
      boolean_leaf
    | boolean_expr
    ;

boolean_expr:
      boolean_unop_expr
    | boolean_binop_expr
    ;

boolean_leaf:
      boolean_literal
    | boolean_constraint
    | '(' boolean_node ')'
    | boolean_unop_expr
    | arithmetic_relop_expr
    ;

cadl_constraint_expr: REL_PATH SYM_MATCHES '{' c_primitive_object '}' ;

boolean_constraint:
      ABS_PATH SYM_MATCHES '{' c_primitive_object '}'
    ;

boolean_unop_expr:
      ( SYM_EXISTS | SYM_NOT ) ABS_PATH
    | SYM_NOT ( boolean_node )
    ;

boolean_binop_expr: boolean_node boolean_binop_symbol boolean_leaf ;

boolean_binop_symbol:
      SYM_OR
    | SYM_AND
    | SYM_XOR
    | SYM_IMPLIES
    ;

boolean_literal:
      SYM_TRUE
    | SYM_FALSE
    ;

arithmetic_relop_expr: arithmetic_node relational_binop_symbol arithmetic_node ;

arithmetic_node:
      arithmetic_leaf
    | arithmetic_arith_binop_expr
    ;

arithmetic_leaf:
      arithmetic_value
    | '(' arithmetic_node ')'
    ;

arithmetic_arith_binop_expr: arithmetic_node arithmetic_binop_symbol arithmetic_leaf ;

arithmetic_value:
      integer_value
    | real_value
    | ABS_PATH
    ;

relational_binop_symbol:
      '='
    | SYM_NE
    | SYM_LE
    | SYM_LT
    | SYM_GE
    | SYM_GT
    ;

arithmetic_binop_symbol:
      '/'
    | '*'
    | '+'
    | '-'
    | '^'
    ;

//
//  ============== Lexical rules ==============
//

SYM_THEN    : [Tt][Hh][Ee][Nn] ;
SYM_ELSE    : [Ee][Ll][Ss][Ee] ;
SYM_AND        : [Aa][Nn][Dd] ;
SYM_OR        : [Oo][Rr] ;
SYM_XOR        : [Xx][Oo][Rr] ;
SYM_NOT        : [Nn][Oo][Tt] ;
SYM_IMPLIES    : [Ii][Mm][Pp][Ll][Ii][Ee][Ss] ;
SYM_FOR_ALL    : [Ff][Oo][Rr][_][Aa][Ll][Ll] ;
SYM_EXISTS    : [Ee][Xx][Ii][Ss][Tt][Ss] ;
