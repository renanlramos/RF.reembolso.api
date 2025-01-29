<h1>#Testes da API de Reembolso da HAPVIDA#<h1>

<h3>Para executar a automação é necessário instalar o python</h3>
https://www.python.org/downloads/<br>

<h3>Utilizado o Robot Framework 7.2</h3>
https://robotframework.org/<br>
    🤖Bibliotecas utilizadas🤖<br>
<ul>
  <li>RequestsLibrary</li>
  <li>Collections(Nativo)</li>
  <li>OperatingSystem(Nativo)</li>
  <li>Robotmetrics</li>
</ul>
<br>
<h3>Como executar os testes:</h3>
<p>Navegue até a pasta principal do projeto e abra o terminal</p>
<p>No terminal, digite uma das seguintes opções, conforme necessidade:</p>
<h7>Toda a suite de testes:</h7>
<p>robot --outputdir .\results\ .\tests</p>
<h7>Apenas uma das Suites:</h7>
<p>robot --outputdir .\results\ .\tests\management.tests.robot</p>
<h7>Apenas um Cenário especifico de uma suite:</h7>
<p>robot --outputdir .\results\ -i CT001 .\tests\management.tests.robot</p>
<br>
<h4>Legenda dos comandos:</h4>
<p>robot : comando para iniciar a execução do Robot Framework</p>
<p>--outputdir : informa um caminho customizado para a saída dos relatórios de execução, no caso a pasta /results</p>
<p>.\tests : executa todos os arquivos dentro da pasta /tests</p>
<p>.\tests\management.tests.robot : executara apenas o arquivo management da pasta /tests</p>
<p>-i : permite informar uma tag para executar apenas um teste em especifico</p>
