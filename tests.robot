*** Settings ***
Documentation   Reembolso
Resource        keywords.resource
Resource        variables.resource
Library         RequestsLibrary

Suite Setup     Recuperar Bearer Token

*** Test Cases ***
Criar Novo Protocolo
    Dado que esteja na Management.API do Reembolso
    Quando crio um novo protocolo de reembolso
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter o protocol e protocolCode
    E o request e requestCode
   
Criar nova solicitação para o mesmo Protocolo
    Dado que esteja na Management.API do Reembolso
    Quando crio um novo protocolo de reembolso
    E o corpo da resposta deve conter o protocol e protocolCode
    E crio uma nova solicitação para o mesmo protocolo
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter o protocol e protocolCode
    E o request e requestCode

Get Protocolo de Paciente
    Dado que esteja na Management.API do Reembolso
    Quando recupero o protocolo "300000304169" da Carterinha "60300063869002"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados do protocolo

