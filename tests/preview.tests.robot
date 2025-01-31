*** Settings ***
Documentation   Reembolso
Resource        ../src/keywords.resource
Resource        ../src/variables.resource
Library         RequestsLibrary

Suite Setup     Recuperar Bearer Token
Default Tags    Preview

*** Test Cases ***
Criar Prévia
    [Tags]    CT001
    Dado que esteja na Preview.API do Reembolso
    Quando crio um novo protocolo de "prévia" para o paciente "44937000312004"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação

Atualizar Prévia
    [Tags]    CT002
    Dado que esteja na Preview.API do Reembolso
    Quando crio um novo protocolo de "prévia" para o paciente "44937000312004"
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    Então é possivel fazer a atualização dos dados da solicitação de "prévia"
    E os dados da resposta da criação deve ser igual da atualização
    E deve conter a mensagem: "SOLICITAÇÃO REGISTRADA COM SUCESSO."
    E a resposta de status deve ser de código 200

Fechar Prévia
    [Tags]    CT003
    Dado que esteja na Preview.API do Reembolso
    Quando crio um novo protocolo de "prévia" para o paciente "44937000312004"
    E a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    Então fecho a solicitação de "prévia"
    E deve conter a mensagem: "PROTOCOLO ENVIADO PARA FILA DE ANÁLISE."

Consultar Prévia
    [Tags]    CT004
    Dado que esteja na Preview.API do Reembolso
    Quando crio um novo protocolo de "prévia" para o paciente "44937000312004"
    E a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    E fecho a solicitação de "prévia"
    E deve conter a mensagem: "PROTOCOLO ENVIADO PARA FILA DE ANÁLISE."
    Então consulto a prévia
    E o corpo da resposta deve conter os dados do paciente e do protocolo com a estrutura do(a) "Prévia"

Download anexo Prévia
    [Tags]    CT005
    Dado que esteja na Preview.API do Reembolso
    E código de protocolo:"304599" e código de solicitação:"298972"
    Quando solicito o download do arquivo "testeclinipam.png" de "prévia"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter o link para download do arquivo

Anexar arquivo prévia
    [Tags]    CT006
    Skip

Deletar anexo prévia
    [Tags]    CT007
    Skip