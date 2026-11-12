# Doki Doki Tri-Line Quest — patch em português do Brasil

**Correção da lentidão na cidade, r9:** Painéis e textos invisíveis não são desenhados; três molduras verificadas usam no máximo nove chamadas. As 108 comparações coincidem pixel a pixel. A cidade à noite passou de 4,31 para 0,41 ms de processamento no Windows original e de 5,52 para 0,53 ms de scripts com dados Android no executor local. Não são FPS medidos no celular; o novo teste no celular está pendente. A correção de início r8 foi mantida.

**Correção de falha no Android, r8:** Descritores ZIP inconsistentes nos APKs r7 impediam o carregamento das classes de inicialização. Em todos os idiomas, os cabeçalhos são normalizados antes da assinatura; a estrutura e os CRCs são verificados depois. Gere o APK novamente com r8. Ainda falta repetir o teste no celular afetado.

## Instalação no Windows

1. Tenha uma cópia original e compatível de **Doki Doki Tri-Line Quest 2.01.04 Beta para Windows**.
2. Execute `WindowsPatch.bat` com dois cliques.
3. Selecione **3 - Português (Brasil)** e pressione **Enter**.
4. Quando solicitado, informe a pasta do jogo original para Windows.
5. Aguarde a conclusão. Uma nova cópia traduzida será criada na pasta `output`. Inicie o jogo por essa nova cópia. Os arquivos originais permanecem intactos.

## Instalação no Android

1. Tenha uma cópia original e compatível do jogo para Windows. **Não é necessário ter o jogo instalado no Android nem possuir o APK original.**
2. Em um computador Windows, execute `Build-APK.bat` com dois cliques.
3. Selecione **3 - Português (Brasil)** e pressione **Enter**.
4. Informe a pasta do jogo original para Windows quando solicitado.
5. O script baixará e verificará automaticamente as ferramentas necessárias.
6. Aguarde a geração do APK Android assinado na pasta `output`.
7. Transfira o APK gerado para um celular compatível com **Android 7 ou superior e ARM64** e instale-o.

**Importante:** os dois processos exigem uma cópia própria e compatível do jogo original para Windows. O pacote público contém as ferramentas e os arquivos de tradução, mas não inclui o jogo completo nem um APK original.

Toque na tela para clicar; mantenha o dedo pressionado e mova para arrastar. L/R selecionam o botão esquerdo/direito do mouse; use L normalmente. Abra o menu auxiliar pelo botão superior. Arrastar sobre o menu não confirma uma opção.

[简体中文](README.md) · [English](README.en.md) · [Português](README.pt-BR.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [한국어](README.ko.md) · [Türkçe](README.tr.md)

## Xbox

Controles Xbox têm suporte nativo. Use o analógico esquerdo (LS) ou o direcional para se mover; A confirma e inicia conversas, B volta e Start pausa o jogo. Y ou View abre a “Ajuda”. O analógico direito (RS) move o cursor virtual. RT ou X funciona como o botão esquerdo do mouse; mantenha pressionado para arrastar. LT funciona como o botão direito. Segure LB para mover o cursor com precisão ou RB para acelerar. O sistema reconhece controles USB e Bluetooth; não é necessário usar um programa para mapear os botões.

Depois de conectar ou voltar ao jogo, solte os botões e centralize os analógicos antes de continuar.
