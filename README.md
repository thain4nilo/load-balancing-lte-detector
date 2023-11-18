# Load Balancing LTE Detector 📡
#### Detecção de oportunidades de balanceamento de tráfego/carga entre células LTE 📶

## Autores 👩‍💻👨‍💻
- [Thainá Nilo](https://github.com/thain4nilo)
- [Tiago Beltrão Lacerda](https://github.com/tblacerda)


## Descrição do Projeto 📋
A rede LTE (Long-Term Evolution) é amplamente utilizada para comunicações móveis de alta velocidade em todo o mundo. Para garantir um desempenho ideal da rede, é crucial distribuir adequadamente a carga de tráfego entre as células LTE. O projeto se concentra em analisar os dados da rede LTE e identificar oportunidades de balanceamento de carga, o que pode resultar em uma melhoria significativa na qualidade do serviço para os usuários. O projeto tem como objetivo detectar oportunidades de balanceamento de tráfego/carga entre células LTE (4G) por meio de análise descritiva usando as linguagens R e Python. 💡

### Definições:
O projeto utiliza dados diários da utilização de PRB, quantidade de usuários RRC e largura de banda e Throughput User para classificar qual o nível de utilização da célula, de forma a obedecer os limiares definidos abaixo.
  - Uma célula será caracterizado como fora da meta em um dia pelo indicador caso:
    - Utilização de PRB > 70%
    - Thoughput User < 5 Mb
    - Largura de Banda = 5 e Usuários RRC > 25
    - Largura de Banda = 10 e Usuários RRC > 50
    - Largura de Banda = 15 e Usuários RRC > 75
    - Largura de Banda = 20 e Usuários RRC > 100
    - Largura de Banda = 25 e Usuários RRC > 125
   
  - Se a célula saia da meta em um ou mais indicadores por 4 dias ou mais o comportamento é considerado CRITICO
  - Se a célula saia da meta em um ou mais indicadores por até 1 dia é classificada como NORMAL
  - As demais células que não se classificam por nenhum dos critérios anteriores são chamadas ALERTA, estas não são consideradas utilizáveis para absorver mais tráfego, nem performam mal o suficiente para necessitar de otimização, mas também é possível ajustar o código para buscar oportunidades de balanceamento entre células ALERTAS e NORMAIS.

#### Oportunidade de Balanceamento entre células do tipo CoSite
Trata-se da oportunidade de otimização / distribuição de carga entre células que estão na mesma estação radio base e direcionadas para o mesmo azimute. No exemplo abaixo, a célula A que está crítica pode ser balanceada com a célula C.
![image_Oport_coSite](https://github.com/thain4nilo/load-balancing-lte-detector/assets/44781145/0b30cba3-9f22-4416-b321-51b8914b39b2)

#### Oportunidade de Balanceamento entre células do tipo Vizinho [Em atualização]
Trata-se da oportunidade de otimização / distribuição de carga entre células que NÃO estão na mesma estação radio base, mas em estações vizinhas onde suas regiões de cobertura se sobrepõem.


## Pré-requisitos ⚙️
Certifique-se de que você tenha os seguintes pré-requisitos instalados:
- R e RStudio para executar os códigos em R. 📈
- Python para executar o módulo em python. 🐍

## Contribuições 🤝
Contribuições são bem-vindas! Agradecemos por explorar o projeto "Load Balancing LTE Detector". Esperamos que este projeto seja útil para você e que possa contribuir para a melhoria das redes LTE. Se tiver alguma dúvida ou sugestão, não hesite em entrar em contato conosco. 🙌
