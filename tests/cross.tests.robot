*** Settings ***
Documentation   Reembolso
Resource        ../src/keywords.resource
Resource        ../src/variables.resource
Library         RequestsLibrary

Suite Setup     Recuperar Bearer Token
Default Tags    Cross

*** Test Cases ***
Listar Prestadores
    [Tags]    CT001
    Dado que esteja na CROSS.API do Reembolso
    Quando listo todos os "Prestadores cadastrados"
    Então a resposta de status deve ser de código 200
    E a resposta deve conter uma lista com "10 Prestadores"

Listar Prestador especifico
    [Tags]    CT002
    Dado que esteja na CROSS.API do Reembolso
    Quando listo um prestador "CRM" de documento "5387018006", Nº de Conselho "1423", do Estado "SP"
    Então a resposta de status deve ser de código 200
    E no corpo da resposta deve retornar o "prestador" de nome "TESTE 17"
    

Listar Bancos
    [Tags]    CT003
    Dado que esteja na CROSS.API do Reembolso
    Quando listo todos os "Bancos cadastrados"
    Então a resposta de status deve ser de código 200
    E a resposta deve conter uma lista com "10 Bancos"
    
Listar Banco por código
    [Tags]    CT004
    Dado que esteja na CROSS.API do Reembolso
    Quando solicito o Banco de Código "318"
    Então a resposta de status deve ser de código 200
    E no corpo da resposta deve retornar o "banco" de nome "BANCO BMG S.A."
    
Listar Procedimentos
    [Tags]    CT005
    Dado que esteja na CROSS.API do Reembolso
    Quando listo todos os "Procedimentos"
    Então a resposta de status deve ser de código 200
    E a resposta deve conter uma lista com "10 Procedimentos"

Listar Conselhos Profissionais
    [Tags]    CT006
    Dado que esteja na CROSS.API do Reembolso
    Quando listo todos os "Conselhos profissionais"
    Então a resposta de status deve ser de código 200
    E a resposta deve conter uma lista com "10 Conselhos"

Listar Conselhos Profissionais por modalidade
    [Tags]    CT007
    Dado que esteja na CROSS.API do Reembolso
    Quando listo o Conselhos Profissionais pelo modality-code "1"
    Então a resposta de status deve ser de código 200
    E no corpo da resposta deve retornar o "acrônimo" de nome "CRM"

Listar Especialidades
    [Tags]    CT008
    Dado que esteja na CROSS.API do Reembolso
    Quando listo todos os "Especialidades"
    Então a resposta de status deve ser de código 200
    E a resposta deve conter uma lista com "10 Especialidades"

Listar Terapias
    [Tags]    CT009
    Dado que esteja na CROSS.API do Reembolso
    Quando listo todos os "Terapias"
    Então a resposta de status deve ser de código 200
    E a resposta deve conter uma lista com "10 Terapias"