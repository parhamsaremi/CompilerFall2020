#ifndef AST_H_
#define AST_H_

#include <bits/stdc++.h>
#include <string.h>

using namespace std;

class AstNode;
class Start;
class Program;
class Decl;
class VariableDecl;
class FunctionDecl;
class ClassDecl;
class InterfaceDecl;
class StmlBlock;
class Variable;

enum type
{
    int_t,
    bool_t,
    string_t,
    double_t,
    class_t
};

class AstNode
{
public:
    AstNode(){};
    ~AstNode(){};
};

class Start : public AstNode
{
    Program *program;

public:
    Start(Program *program)
    {
        this->program = program;
    }
};

class Program : public AstNode
{
public:
    vector<Decl *> decls;

    Program() = default;
};

class Decl : public AstNode
{
public:
    VariableDecl *variable_decl;
    FunctionDecl *function_decl;
    ClassDecl *class_decl;
    InterfaceDecl *interface_decl;

    Decl(VariableDecl *variable_decl)
    {
        this->variable_decl = variable_decl;
    }

    Decl(FunctionDecl *function_decl)
    {
        this->function_decl = function_decl;
    }

    Decl(ClassDecl *class_decl)
    {
        this->class_decl = class_decl;
    }

    Decl(InterfaceDecl *interface_decl)
    {
        this->interface_decl = interface_decl;
    }
};

class VariableDecl : public AstNode
{
};

class FunctionDecl : public AstNode
{
public:
    bool is_void;
    Type *type;
    vector<Variable *> formals;
    StmtBlock *stmt_block;
    string id;

    FunctionDecl(Type *type, string id, vector<Variable *> formals, StmtBlock *stmt_block)
    {
        this->is_void = false;
        this->id = id;
        this->type = type;
        this->formals = formals;
        this->stmt_block = stmt_block;
    }
};

class ClassDecl : public AstNode
{
};

class InterfaceDecl : public AstNode
{
};

class Type : public AstNode
{
public:
    bool is_array = false;
    int type = 4;
    string class_name = NULL;

    Type(string type, bool is_array)
    {
        this->is_array = is_array;
        switch (type)
        {
        case "bool":
            this->type = bool_t;
            break;

        case "int":
            this->type = int_t;
            break;

        case "double":
            this->type = double_t;
            break;

        case "string":
            this->type = string_t;
            break;

        default:
            this->class_name = type;
            this->type = class_t;
            break;
        }
    }
};

class StmtBlock
{
};

class Variable
{
};

// %type <sval> variable
// %type <sval> formals
// %type <sval> variable1ToInfColon
// %type <sval> extendsIdent0Or1
// %type <sval> implementsIdentPlusColon0Or1
// %type <sval> fields0ToInf
// %type <sval> field
// %type <sval> ids1ToInfColon
// %type <sval> accessMode
// %type <sval> prototype0ToInf
// %type <sval> prototype
// %type <sval> stmtBlock
// %type <sval> variableDecl0ToInf
// %type <sval> stmt0ToInf
// %type <sval> stmt
// %type <sval> expr0Or1
// %type <sval> ifStmt
// %type <sval> elseStmt0Or1
// %type <sval> whileStmt
// %type <sval> forStmt
// %type <sval> returnStmt
// %type <sval> breakStmt
// %type <sval> continueStmt
// %type <sval> printStmt
// %type <sval> expr1ToInfColon
// %type <sval> expr
// %type <sval> lValue
// %type <sval> call
// %type <sval> actuals
// %type <sval> constant

#endif