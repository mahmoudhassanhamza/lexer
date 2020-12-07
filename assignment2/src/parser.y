/* Types that are used in %union should be defined in this code block. */
%code requires {
#include <stdbool.h>
}

/* Everything else can go in this code block. */
%code {
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int line_number;
extern FILE *yyin;
extern int yylex();
static void yyerror(const char *s);
}

/* Enable verbose error messages. */
%define parse.error verbose

/* Declare type for semantic value. You may need to extend this. */
%union {
    bool bval;
    int ival;
    double fval;
    char *str;
};

/* Declare tokens with semantic values */
%token<bval> BOOL
%token<ival> INT
%token<fval> FLOAT
%token<str> TYPE STATE IDENTIFIER ERROR

/* Declare tokens without semantic values */
%token BREAK CONTINUE DO FOR WHILE SWITCH CASE DEFAULT IF ELSE RETURN STRUCT
%token ATTRIBUTE CONST UNIFORM VARYING BUFFER SHARED COHERENT VOLATILE RESTRICT
%token READONLY WRITEONLY LAYOUT CENTROID FLAT SMOOTH NOPERSPECTIVE PATCH SAMPLE
%token SUBROUTINE IN OUT INOUT INVARIANT PRECISE DISCARD LOWP MEDIUMP HIGHP PRECISION

%token CLASS ILLUMINANCE AMBIENT PUBLIC PRIVATE SCRATCH
%token RT_PRIMITIVE RT_CAMERA RT_MATERIAL RT_TEXTURE RT_LIGHT

%token LEFT_OP RIGHT_OP INC_OP DEC_OP LE_OP GE_OP EQ_OP NE_OP AND_OP OR_OP XOR_OP

%token MUL_ASSIGN DIV_ASSIGN ADD_ASSIGN MOD_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN
%token AND_ASSIGN XOR_ASSIGN OR_ASSIGN SUB_ASSIGN

/* You can specify the type for a production using %type.
 * For example, if "function_header" should have a "str" value, use:
 * %type<str> function_header
 */

/* Start production. */
%start translation_unit

%%

/* TODO Implement RTSL grammar here */
translation_unit: ;

%%
 
/* Data tables for interface methods and states, so you don't have to extract them yourself.
 * Note: The paper contains a number of errors regarding the allowed state variables. These
 * errors are already corrected here and marked with a comment. */

static const char *camera_methods[] = {
    "constructor",
    "generateRay",
    NULL
};

static const char *primitive_methods[] = {
    "constructor",
    "intersect",
    "computeBounds",
    "computeNormal",
    "computeTextureCoordinates",
    "computeDerivatives",
    "generateSample",
    "samplePDF",
    NULL
};

static const char *texture_methods[] = {
    "constructor",
    "lookup",
    NULL
};

static const char *material_methods[] = {
    "constructor",
    "shade",
    "BSDF",
    "sampleBSDF",
    "evaluatePDF",
    "emission",
    NULL
};

static const char *light_methods[] = {
    "constructor",
    "illumination",
    NULL
};

static const char **interface_methods[] = {
    primitive_methods, camera_methods, material_methods, texture_methods, light_methods, NULL
};

static const char *camera_states[] = {
    "RayOrigin",
    "RayDirection",
    "InverseRayDirection",
    "Epsilon",
    "HitDistance",
    "ScreenCoord",
    "LensCoord",
    "du",
    "dv",
    "TimeSeed",
    NULL
};

static const char *primitive_states[] = {
    "RayOrigin",
    "RayDirection",
    "InverseRayDirection",
    "Epsilon",
    "HitDistance",
    "BoundMin",
    "BoundMax",
    "GeometricNormal",
    "dPdu",
    "dPdv",
    "ShadingNormal",
    "TextureUV",
    "TextureUVW",
    "dsdu",
    "dsdv",
    "PDF",
    "TimeSeed",
    "HitPoint", // missing in paper
    NULL
};

static const char *texture_states[] = {
    "TextureUV",
    "TextureUVW",
    "TextureColor",
    "FloatTextureValue",
    "du",
    "dv",
    "dsdu",
    "dtdu",
    "dsdv",
    "dtdv",
    "dPdu",
    "dPdv",
    "TimeSeed",
    NULL
};

static const char *material_states[] = {
    "RayOrigin",
    "RayDirection",
    "InverseRayDirection",
    "HitPoint",
    "dPdu",
    "dPdv",
    "LightDirection",
    "LightDistance",
    "LightColor",
    "EmissionColor",
    "BSDFSeed",
    "TimeSeed",
    "PDF",
    "SampleColor",
    "BSDFValue",
    "du",
    "dv",
    "ShadingNormal", // missing in paper
    "HitDistance", // missing in paper
    NULL
};

static const char *light_states[] = {
    "HitPoint",
    "GeometricNormal",
    "ShadingNormal",
    "LightDirection",
    "TimeSeed",
    NULL
};

static const char **interface_states[] = {
    primitive_states, camera_states, material_states, texture_states, light_states
};

/* TODO You'll probably want to add some additional functions to implement the
 * semantic checks here. */
 
static void yyerror(const char *s) {
    fprintf(stderr, "%s on line %d\n", s, line_number);
    exit(-1);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("File %s not found.\n", argv[1]);
            return 1;
        }
    } else {
        yyin = stdin;
    }
    
    do {
        yyparse();
    } while (!feof(yyin));
    return 1;
}
