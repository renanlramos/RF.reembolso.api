*** Settings ***
Documentation   Reembolso
Resource        ../src/keywords.resource
Resource        ../src/variables.resource
Library         RequestsLibrary

Suite Setup     Recuperar Bearer Token
Default Tags    Management

*** Test Cases ***
Criar Novo Protocolo
    [Tags]    CT001
    Dado que esteja na Management.API do Reembolso
    Quando crio um novo protocolo de reembolso para o paciente "60300063869002"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
   
Criar nova solicitação para o mesmo Protocolo
    [Tags]    CT002
    Dado que esteja na Management.API do Reembolso
    Quando crio um novo protocolo de reembolso para o paciente "60300063869002"
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    E crio uma nova solicitação para o mesmo protocolo
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação

Atualizar solicitação
    [Tags]    CT003
    Dado que esteja na Management.API do Reembolso
    Quando crio um novo protocolo de reembolso para o paciente "60300063869002"
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    Então é possivel fazer a atualização dos dados da solicitação
    E deve conter a mensagem: "SOLICITAÇÃO REGISTRADA COM SUCESSO."
    E a resposta de status deve ser de código 200

Fechar Protocolo
    [Tags]    CT004
    Dado que esteja na Management.API do Reembolso
    Quando crio um novo protocolo de reembolso para o paciente "60300063869002"
    E a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    Então fecho a solicitação de reembolso
    E deve conter a mensagem: "PROTOCOLO ENVIADO PARA FILA DE ANÁLISE."

Recuperar Protocolo de Paciente
    [Tags]    CT005
    Dado que esteja na Management.API do Reembolso
    Quando recupero o protocolo "300000304169" da Carterinha "60300063869002" usando o endpoint de versão "V1"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados do paciente e do protocolo com a estrutura do(a) "V1"

Recuperar Protocolo de Paciente V2
    [Tags]    CT006
    Dado que esteja na Management.API do Reembolso
    Quando recupero o protocolo "300000304169" da Carterinha "60300063869002" usando o endpoint de versão "V2"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados do paciente e do protocolo com a estrutura do(a) "V2"

Consultar Reembolso Completo
    [Tags]    CT007
    Dado que esteja na Management.API do Reembolso
    Quando recupero o protocolo "300000304553" da Carterinha "60300063869002" usando o endpoint de versão "Consult-refunds"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados do paciente e do protocolo com a estrutura do(a) "Consult-refunds"

Consultar resumo de Reembolso
    [Tags]    CT008
    Dado que esteja na Management.API do Reembolso
    Quando recupero o protocolo "300000304553" da Carterinha "60300063869002" usando o endpoint de versão "Consults"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados do paciente e do protocolo com a estrutura do(a) "Consults"

Consultar lista de Reembolso
    [Tags]    CT009
    Dado que esteja na Management.API do Reembolso
    Quando listo todos as solicitações do beneficiário "44937000312004" usando a "V1"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados do paciente e do protocolo com a estrutura do(a) "Lista de protocolos"

Consultar lista de Reembolso V2
    [Tags]    CT010
    Dado que esteja na Management.API do Reembolso
    Quando listo todos as solicitações do beneficiário "44937000312004" usando a "V2"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados do paciente e do protocolo com a estrutura do(a) "Lista de protocolos V2"

Consultar demonstrativo
    [Tags]    CT011
    Dado que esteja na Management.API do Reembolso
    Quando solicito os dados de demonstrativo de protocolo "100023361026" e paciente "3ZRX1000001015"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter os dados do paciente e do protocolo com a estrutura do(a) "Demonstrativo"

Consultar Protocolos BPA
    [Tags]    CT012
    Dado que esteja na Management.API do Reembolso
    Quando solicito a listagem dos Protocolos BPA de status "99"
    E a resposta de status deve ser de código 200
    Então o corpo da reposta deve conter os dados de BPA

Download de anexo
    [Tags]    CT013
    Dado que esteja na Management.API do Reembolso
    E código de protocolo:"235362" e código de solicitação:"233162"
    E informo a pasta "anexo_reembolso"
    Quando solicito o download do arquivo "100022025679_Laudomédicolucas.pdf"
    Então a resposta de status deve ser de código 200
    E o corpo da resposta deve conter o link para download do arquivo

Listar anexos
    [Tags]    CT014
    Dado que esteja na Management.API do Reembolso
    Quando solicito a listagem dos anexos do protocolo "304569" e solicitação "298954"
    Então o corpo da reposta deve conter uma lista com varios anexos

Anexar arquivo
    [Tags]    CT015
    Skip

Deletar arquivo anexado
    [Tags]    CT016
    Skip
