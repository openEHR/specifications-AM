//
//  General purpose patterns used in all openEHR parser and lexer tools
//

grammar base_patterns;

//
//  ============== Parse rules ==============
//

type_id : V_TYPE_NAME ( '<' v_type_id ( ',' v_type_id )* '>' )? ;

//
//  ============== Lexical rules ==============
//

// ---------- whitespace & comments ----------

WS : 
      [ \t\r]+      // skip
    | '\n'+         // increment line count
    | '--'.*        // Ignore comments
    | '--'.*'\n'    // (increment line count)
    ;

// ---------- ISO8601 Date/Time values ----------

V_ISO8601_DATE      :     YEAR '-' MONTH ( '-' DAY )? ;
V_ISO8601_TIME      :     HOUR ':' MINUTE ( ':' SECOND ( ',' INTEGER )?)? ( TIMEZONE )? ; 
V_ISO8601_DATE_TIME :     YEAR '-' MONTH '-' DAY 'T' HOUR (':' MINUTE (':' SECOND ( ',' [0-9]+ )?)?)? ( TIMEZONE )? ;

fragment TIMEZONE   :     'Z' | ('+'|'-') HOUR_MIN ;   // hour offset, e.g. `+0930`, or else literal `Z` indicating +0000.
fragment MONTH      :     ( [0][0-9] | [1][0-2] ) ;    // month in year
fragment DAY        :     ( [012][0-9] | [3][0-2] ) ;  // day in month
fragment HOUR       :     ( [01]?[0-9] | [2][0-3] ) ;  // hour in 24 hour clock
fragment MINUTE     :     [0-5][0-9] ;                 // minutes
fragment SECOND     :     [0-5][0-9] ;                 // seconds

// ISO8601 DURATION PnYnMnWnDTnnHnnMnn.nnnS 
// here we allow a deviation from the standard to allow weeks to be
// mixed in with the rest since this commonly occurs in medicine
V_ISO8601_DURATION : 'P'([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?('T'([0-9]+[hH])?([0-9]+[mM])?([0-9]+('.'[0-9]+)?[sS])?)? ;

// -------- other values --------

V_ARCHETYPE_ID  : (V_DOMAIN_NAME '::')? V_IDENTIFIER '-' V_IDENTIFIER '-' V_IDENTIFIER '.' V_NAME '.v' V_VERSION_ID ;

V_DOMAIN_NAME   : V_NAME ('.' V_NAME)+ ;
V_IDENTIFIER    : ALPHA_CHAR ID_CHAR* ;
V_TYPE_NAME     : ALPHA_UPPER ID_CHAR* ;
V_ATTRIBUTE_ID  : [_a-z][a-zA-Z0-9_]* ;
V_NAME          : ALPHA_CHAR NAME_CHAR+ ;
V_VALUE         : ( NAME_CHAR | ^[ \r\n\t] )* ;

V_DOTTED_NUMERIC: DIGIT+ DOT_SEGMENT+ ;
V_VERSION_ID    : DIGIT+ ( DOT_SEGMENT ( DOT_SEGMENT ( ('-rc'|'-alpha') DOT_SEGMENT? )? )? )? ;
fragment DOT_SEGMENT : '.' DIGIT+ ;

// -------- primitive types --------

V_URI : [a-z]+ ':' ( '//' | '/' | ~[/ ]+ )? ~[ \t\n]+? ; // just a simple recogniser, the full thing isn't required
V_QUALIFIED_TERM_CODE_REF : '[' NAMECHAR_PAREN+ '::' NAME_CHAR+ ']' ;  // e.g. [ICD10AM(1998)::F23]

V_INTEGER :   [0-9]+ E_SUFFIX? ;
V_REAL :      [0-9]+'.'[0-9]+ E_SUFFIX? ;
fragment E_SUFFIX : [eE][+-]?[0-9]+ ;

V_STRING : '"' V_STRING_CHAR*? '"' ;
fragment V_STRING_CHAR : UTF8CHAR | '\\'['nrt\"] | ~["] ;

V_CHARACTER : '\'' V_CHAR '\'' ;
fragment V_CHAR : UTF8CHAR | '\\['nrt\]' | ~[\n'] ;

SYM_TRUE : [Tt][Rr][Uu][Ee] ;
SYM_FALSE : [Ff][Aa][Ll][Ss][Ee] ;

// -------- character fragments --------

fragment ALPHA_CHAR    : [a-zA-Z] ;
fragment ALPHA_UPPER   : [A-Z] ;
fragment DIGIT         : [0-9] ;
fragment ALPHANUM_CHAR : ALPHA_CHAR | DIGIT ;
fragment ID_CHAR       : ALPHANUM_CHAR | '_' ;
fragment NAME_CHAR     : ID_CHAR | '-' ;
fragment NAME_CHAR_PAREN: NAME_CHAR | [()] ;

fragment UTF8CHAR : 
    | '\u00C0'..'\u00D6'
    | '\u00D8'..'\u00F6'
    | '\u00F8'..'\u02FF'
    | '\u0300'..'\u036F'
    | '\u0370'..'\u037D'
    | '\u037F'..'\u1FFF'
    | '\u200C'..'\u200D'
    | '\u203F'..'\u2040'
    | '\u2070'..'\u218F'
    | '\u2C00'..'\u2FEF'
    | '\u3001'..'\uD7FF'
    | '\uF900'..'\uFDCF'
    | '\uFDF0'..'\uFFFD'
    ;

