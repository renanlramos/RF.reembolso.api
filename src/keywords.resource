*** Settings ***
Resource        variables.resource
Library         RequestsLibrary
Library         Collections
Library         OperatingSystem

*** Keywords ***
Recuperar Bearer Token
    Set Log Level    NONE
    ${headers}=            Create Dictionary    Content-Type=application/x-www-form-urlencoded
    Create Session         authBearer    ${urltoken}    verify=False
    ${data}=               Create Dictionary    grant_type=client_credentials    client_id=${client_id}    scope=${scope}    client_secret=${client_secret}   
    ${response}=           POST On Session   authBearer    ${urltoken}    data=${data}
    Set Log Level    INFO
    Should Be Equal As Integers   ${response.status_code}    200
    ${bearer_token}=       Get From Dictionary    ${response.json()}    access_token
    Set Global Variable    ${bearer_token}
        IF    ${response.status_code} != 200
            Run Keyword    Fatal Error        
        END

##KEYWORDS REFERENTE AO MANAGEMENT.API##

Dado que esteja na Management.API do Reembolso
    ${headers}=       Create Dictionary     Authorization=${bearer_token}    Ocp-Apim-Subscription-Key=${apim_key_management}    Content-Type=application/json
    Create Session    reembolso             ${baseurl_management_api}    headers=${headers}

Quando recupero o protocolo "${protocol}" da Carterinha "${patient}" usando o endpoint de versão "${version}"
    ${response}=    
    ...    Run Keyword If    "${version}" == "V1"    
    ...    GET On Session    reembolso    url=v1/protocols/${protocol}?patient-code=${patient}  
    ...  ELSE IF             "${version}" == "V2"
    ...    GET On Session    reembolso    url=v2/protocols/${protocol}/user-code/${patient}
    ...  ELSE IF             "${version}" == "Consult-refunds"
    ...    GET On Session    reembolso    url=v1/protocols/consult-refunds?user-code=44937000312004&patient-code=${patient}&protocol=${protocol}    
    ...  ELSE IF             "${version}" == "Consults"
    ...    GET On Session    reembolso    url=v1/protocols/consults?user-code=44937000312004&protocol=${protocol}
    ...  ELSE
    ...    Fatal Error
    Set Test Variable   ${response}

Então a resposta de status deve ser de código 200
    Should Be Equal As Integers    ${response.status_code}    200

E o corpo da resposta deve conter os dados do paciente e do protocolo com a estrutura do(a) "${version}"
    Run Keyword If    "${version}" == "V1"
    ...    Should Be Equal As Strings    ${response.json()}      ${expected_json_get_protocol}
    ...  ELSE IF      "${version}" == "V2"
    ...    Should Be Equal As Strings    ${response.json()}      ${expected_json_get_protocol_v2}
    ...  ELSE IF      "${version}" == "Consult-refunds"
    ...    Should Be Equal As Strings    ${response.json()}      ${expected_json_get_protocol_consult_refunds}    
    ...  ELSE IF      "${version}" == "Consults"
    ...    Should Be Equal As Strings    ${response.json()}      ${expected_json_get_protocol_consults}    
    ...  ELSE IF      "${version}" == "Lista de protocolos" or "${version}" == "Lista de protocolos V2"
    ...    Should Be True    ${response.json()['content']['protocols'][9]}    
    ...  ELSE IF      "${version}" == "Demonstrativo"
    ...    Should Be True    ${response.json()['content']['statementRequestDetails']}
    ...  ELSE
    ...    Fatal Error
    

Quando crio um novo protocolo de reembolso para o paciente "${patient}"
    ${response}=    POST On Session    reembolso    url=v1/protocols    data={"UserCode":"44937000312004","PatientCode":"${patient}","Protocol":"","ProtocolCode":"","ReanalysisProtocol":"","ReanalysisRequest":"","PhoneNumber":"19989996663","Email":"EMAIL2@HAPVIDA.COM","RequestOriginCode":"1","ModalityCode":"2","ReasonCode":"2","DocumentType":"1","DocumentDescription":"teste3.nfe","DocumentOrigin":"1","PaymentDate":"12-12-2023","Value":"55,55","Currency":"21","IbgeDocumentCity":"","DocumentCity":"","State":"","DocumentDigit":"","PersonType":"J","Document":"05387018006","ProviderCode":"","ProviderName":"TESTE 17","CouncilCode":"CRM","CouncilNumber":"1423","CouncilState":"SP","City":"AMERICANA","FavouredName":"RENATA ALMEIDA","BankCode":"","FavouredBank":"","Agency":"","Account":"","HealthPlan":"9732","Contract":"44937000312"}
    Set Test Variable    ${response}

E o corpo da resposta deve conter os dados de identificação do protocolo e solicitação
    Set Test Variable    ${protocol}    ${response.json()['content']['protocol']}
    Set Test Variable    ${protocol_code}    ${response.json()['content']['protocolCode']}
    Set Test Variable    ${request}    ${response.json()['content']['request']}
    Set Test Variable    ${request_code}    ${response.json()['content']['requestCode']}
        IF    ${protocol} == $null or ${protocol_code} == $null or ${request_code} == $null or ${request} == $null
          Run Keyword    Fail
        END
    Log    CD SOLICITAÇÃO:${request_code} e CD PROTOCOLO: ${protocol_code}

E crio uma nova solicitação para o mesmo protocolo
    ${response}=    POST On Session    reembolso    url=v1/protocols    data={"UserCode":"44937000312004","PatientCode":"60300063869002","Protocol":"${response.json()['content']['protocol']}","ProtocolCode":"${response.json()['content']['protocolCode']}","ReanalysisProtocol":"","ReanalysisRequest":"","PhoneNumber":"19989996663","Email":"EMAIL2@HAPVIDA.COM","RequestOriginCode":"1","ModalityCode":"2","ReasonCode":"2","DocumentType":"1","DocumentDescription":"teste3.nfe","DocumentOrigin":"1","PaymentDate":"12-12-2023","Value":"55,55","Currency":"21","IbgeDocumentCity":"","DocumentCity":"","State":"","DocumentDigit":"","PersonType":"J","Document":"05387018006","ProviderCode":"","ProviderName":"TESTE 17","CouncilCode":"CRM","CouncilNumber":"1423","CouncilState":"SP","City":"AMERICANA","FavouredName":"RENATA ALMEIDA","BankCode":"","FavouredBank":"","Agency":"","Account":"","HealthPlan":"9732","Contract":"44937000312"}
    Set Test Variable    ${response}

Então é possivel fazer a atualização dos dados da solicitação
    ${response}    PUT On Session    reembolso    url=v1/protocols    data={"requestCode":"${requestCode}","Protocol":"${protocol}","ProtocolCode":"${protocolCode}","UserCode":"44937000312004","PatientCode":"60300063869002","PhoneNumber":"19989996668","Email":"EMAIL5@NDI.COM","AssociatedProtocol":"","RequestOriginCode":"1","ModalityCode":"2","ReasonCode":"2","DocumentType":"2","DocumentDescription":"teste3.nfe","DocumentOrigin":"1","PaymentDate":"12-12-2024","Value":"55,55","Currency":"21","IbgeDocumentCity":"5200050","DocumentCity":"AMERICANA","State":"SP","DocumentDigit":"9633","PersonType":"F","Document":"10517004003","ProviderCode":"1111","ProviderName":"JOAO DA SILVA","CouncilCode":"CRM","CouncilNumber":"1403","CouncilState":"SP","FavouredName":"RENATA ALMEIDA","BankCode":"001","FavouredBank":"BANCO DO BRASIL","Agency":"015","Account":"00000151-99","HealthPlan":"9732","Contract":"44937000312"}
    Set Test Variable    ${response}
    Log    CD SOLICITAÇÃO:${response.json()['content']['requestCode']} e CD PROTOCOLO: ${response.json()['content']['protocolCode']}

E deve conter a mensagem: "${message}"
    Should Be Equal As Strings    ${response.json()['content']['message']}    ${message}

E a resposta de status deve ser de código 200
    Então a resposta de status deve ser de código 200

Então fecho a solicitação de reembolso
    ${response}    POST On Session    reembolso    url=v1/protocols/close-protocol    data={"userCode": "60300063869002","protocolCode": "${protocolCode}"}
    Set Test Variable    ${response}

Quando listo todos as solicitações do beneficiário "${usercode}" usando a "${version}"
    ${response}    
    ...    Run Keyword If    "${version}" == "V1"    
    ...    GET On Session    reembolso    url=v1/protocols?user-code=${usercode}
    ...    ELSE IF           "${version}" == "V2"    
    ...    GET On Session    reembolso    url=v2/protocols?user-code=${usercode}
    ...    ELSE    
    ...    Fatal Error
    Set Test Variable    ${response}

Quando solicito os dados de demonstrativo de protocolo "${protocol}" e paciente "${patient}"
    ${response}    GET On Session    reembolso    url=v1/protocols/statement?protocol=${protocol}&user-code=${patient}
    Set Test Variable    ${response}

Quando solicito a listagem dos Protocolos BPA de status "${code}"
    ${response}    GET On Session    reembolso    url=v1/protocols/bpa?status-code=${code}
    Set Test Variable    ${response}

Então o corpo da reposta deve conter os dados de BPA
    Should Be True    ${response.json()['content']['protocolsBpa']}

E código de protocolo:"${protocolCode}" e código de solicitação:"${requestCode}"
    Set Test Variable    ${protocolCode}
    Set Test Variable    ${requestCode}
E informo a pasta "${folder}"
    Set Test Variable    ${folder}

Quando solicito o download do arquivo "${file}"
    ${response}    GET On Session    reembolso    url=v1/protocols/file?protocolCode=${protocolCode}&requestCode=${requestCode}&fileName=${file}&path=${folder}
    Set Test Variable    ${response}

E o corpo da resposta deve conter o link para download do arquivo
    Should Be True    ${response.json()['content']}
    Log    ${response.json()['content']['link']}

Quando solicito a listagem dos anexos do protocolo "${protocolCode}" e solicitação "${requestCode}"
    ${response}    GET On Session    reembolso    url=v1/protocols/attach-files?protocol-code=${protocolCode}&request-code=${requestCode}
    Set Test Variable    ${response}

Então o corpo da reposta deve conter uma lista com varios anexos
    Should Be True    ${response.json()['content']['attachFiles'][1]}
    Log    ${response.json()['content']['attachFiles'][0]}
    Log    ${response.json()['content']['attachFiles'][1]}

### KEYWORDS COM FOCO EM USO NO CROSS.API###

Dado que esteja na CROSS.API do Reembolso
    ${headers}=       Create Dictionary     Authorization=${bearer_token}    Ocp-Apim-Subscription-Key=${apim_key_cross}    Content-Type=application/json
    Create Session    reembolso             ${baseurl_cross_api}    headers=${headers}

Quando listo um prestador "${acronym}" de documento "${doc}", Nº de Conselho "${council}", do Estado "${UF}"
    ${response}=    GET On Session    reembolso    url=v1/providers?limit=10&page=1&document=${doc}&council-Number=${council}&state=${UF}&council-Acronym=${acronym}&modality-code=1
    Set Test Variable    ${response}

Quando solicito o Banco de Código "${item}"
    ${response}=    GET On Session    reembolso    url=v1/banks?bankCode=${item}
    Set Test Variable    ${response}

Quando listo o Conselhos Profissionais pelo modality-code "${item}"
    ${response}=    GET On Session    reembolso    url=v1/professionals-councils?modality-code=${item}
    Set Test Variable    ${response}

E no corpo da resposta deve retornar o "${a}" de nome "${b}"
    Run Keyword If    "${a}" == "prestador"
    ...    Should Be Equal As Strings    ${b}    ${response.json()['content']['providers'][0]['providerName']}
    ...  ELSE IF    "${a}" == "banco"
    ...    Should Be Equal As Strings    ${b}    ${response.json()['content']['banks'][0]['description']}
    ...  ELSE IF    "${a}" == "acrônimo"
    ...    Should Be Equal As Strings    ${b}    ${response.json()['content']['professionalsCouncils'][0]['acronym']}
    ...  ELSE
    ...    Fail

E a resposta deve conter uma lista com "${item}"
    Run Keyword If    "${item}" == "10 Bancos"
    ...    Should Be True        ${response.json()['content']['banks'][9]}
    ...  ELSE IF    "${item}" == "10 Prestadores"
    ...    Should Be True    ${response.json()['content']['providers'][9]}
    ...  ELSE IF    "${item}" == "10 Procedimentos"
    ...    Should Be True    ${response.json()['content']['procedures'][9]}
    ...  ELSE IF    "${item}" == "10 Conselhos"
    ...    Should Be True    ${response.json()['content']['professionalsCouncils'][9]}
    ...  ELSE IF    "${item}" == "10 Especialidades"
    ...    Should Be True    ${response.json()['content']['specialties'][9]}
    ...  ELSE IF    "${item}" == "10 Terapias"
    ...    Should Be True    ${response.json()['content']['therapies'][5]}
    ...  ELSE
    ...    Fail

Quando listo todos os "${item}"
    ${response}=    
    ...    Run Keyword If    "${item}" == "Prestadores cadastrados"    GET On Session    reembolso    url=v1/providers
    ...    ELSE IF           "${item}" == "Bancos cadastrados"         GET On Session    reembolso    url=v1/banks
    ...    ELSE IF           "${item}" == "Conselhos profissionais"    GET On Session    reembolso    url=v1/professionals-councils
    ...    ELSE IF           "${item}" == "Procedimentos"              GET On Session    reembolso    url=v1/procedures
    ...    ELSE IF           "${item}" == "Especialidades"             GET On Session    reembolso    url=v1/specialties
    ...    ELSE IF           "${item}" == "Terapias"                   GET On Session    reembolso    url=v1/therapies
    ...    ELSE    Fail
    Set Test Variable    ${response}
    
