*** Settings ***
Resource        variables.resource
Library         RequestsLibrary
Library         Collections
Library         OperatingSystem

*** Keywords ***
Recuperar Bearer Token
    Set Log Level    NONE
    ${headers}=            Create Dictionary    Content-Type=application/x-www-form-urlencoded    Ocp-Apim-Subscription-Key=${apim_key_token}
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

Dado que esteja na Management.API do Reembolso
    ${headers}=       Create Dictionary     Authorization=${bearer_token}    Ocp-Apim-Subscription-Key=${apim_key_management}    Content-Type=application/json
    Create Session    reembolso             ${baseurl}    headers=${headers}

Quando recupero o protocolo "${protocol}" da Carterinha "${patient}"
    ${response}=      GET On Session    reembolso    url=/management/api/v1/protocols/${protocol}?patient-code=${patient}
    Set Test Variable   ${response}

Então a resposta de status deve ser de código 200
    Should Be Equal As Integers    ${response.status_code}    200

E o corpo da resposta deve conter os dados do protocolo
    Should Be Equal As Strings    ${response.json()}      ${expected_json_get_protocol}

Quando crio um novo protocolo de reembolso
    ${response}=    POST On Session    reembolso    url=/management/api/v1/protocols    data=${minimal_payload_protocol_creation}
    Set Test Variable    ${response}

E o corpo da resposta deve conter o protocol e protocolCode
    Set Test Variable    ${protocol}    ${response.json()['content']['protocol']}
    Set Test Variable    ${protocol_code}    ${response.json()['content']['protocolCode']}
        IF    ${protocol} == $null or ${protocol_code} == $null
          Run Keyword    Fail
        END
    
E o request e requestCode
    Set Test Variable    ${request}    ${response.json()['content']['request']}
    Set Test Variable    ${request_code}    ${response.json()['content']['requestCode']}
        IF    ${request_code} == $null or ${request} == $null
          Run Keyword    Fail
        END

E crio uma nova solicitação para o mesmo protocolo
    ${response}=    POST On Session    reembolso    url=/management/api/v1/protocols    data={"UserCode":"44937000312004","PatientCode":"60300063869002","Protocol":"${response.json()['content']['protocol']}","ProtocolCode":"${response.json()['content']['protocolCode']}","ReanalysisProtocol":"","ReanalysisRequest":"","PhoneNumber":"19989996663","Email":"EMAIL2@HAPVIDA.COM","RequestOriginCode":"1","ModalityCode":"2","ReasonCode":"2","DocumentType":"1","DocumentDescription":"teste3.nfe","DocumentOrigin":"1","PaymentDate":"12-12-2023","Value":"55,55","Currency":"21","IbgeDocumentCity":"","DocumentCity":"","State":"","DocumentDigit":"","PersonType":"J","Document":"05387018006","ProviderCode":"","ProviderName":"TESTE 17","CouncilCode":"CRM","CouncilNumber":"1423","CouncilState":"SP","City":"AMERICANA","FavouredName":"RENATA ALMEIDA","BankCode":"","FavouredBank":"","Agency":"","Account":"","HealthPlan":"9732","Contract":"44937000312"}
    Set Test Variable    ${response}
