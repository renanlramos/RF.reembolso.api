*** Settings ***
Documentation   Reembolso
Resource        ../src/keywords.resource
Resource        ../src/variables.resource
Library         RequestsLibrary

Suite Setup     Recuperar Bearer Token
Default Tags    Engine

*** Test Cases ***
Gerar PDF Prévia
    [Tags]    CT001
    Dado que esteja na Preview.API do Reembolso
    Quando crio um novo protocolo de "prévia" para o paciente "44937000312004"
    E a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    E que alterne para Engine.PDF.API do Reembolso
    Então solicito o PDF de "prévia"
    E a resposta de status deve ser de código 200
    E o corpo da resposta deve conter um link

Gerar PDF Reembolso
    Dado que esteja na Management.API do Reembolso
    Quando crio um novo protocolo de "reembolso" para o paciente "60300063869002"
    E a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    E que alterne para Engine.PDF.API do Reembolso
    Então solicito o PDF de "reembolso"
    E a resposta de status deve ser de código 200
    E o corpo da resposta deve conter um link

Gerar PDF Demonstrativo
    Dado que esteja na Management.API do Reembolso
    Quando crio um novo protocolo de "reembolso" para o paciente "60300063869002"
    E a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    E que alterne para Engine.PDF.API do Reembolso
    Então solicito o PDF de "demonstrativo"
    E a resposta de status deve ser de código 200
    E o corpo da resposta deve conter um link