#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include "lex.yy.h"

using namespace std ;
extern FILE* yyout;
extern FILE* yyin;
int main(int argc, char* argv[]){
    if (argc < 5 ){
        cerr<< "Usage: " << argv[0] << " -i <input> -o <output>" << endl ;
        return 1;
    }

    char* input_file_path = argv[2];
    char* output_file_path = argv[4];
    printf("input: %s\noutput: %s\n",input_file_path, output_file_path);
    yyin= fopen(input_file_path, "r");
    yyout = fopen(output_file_path, "w");

    yylex();
    fclose(yyin);
    fclose(yyout);
}
