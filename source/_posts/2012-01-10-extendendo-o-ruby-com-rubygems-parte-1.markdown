---
layout: post
title: "Extendendo o Ruby com RubyGems: Parte 1"
date: 2012-01-10 23:26
comments: true
author: Reinaldo Junior
categories: 
 - ruby
 - basico
 - gems
---

[RubyGems](https://rubygems.org/) é um sistema de empacotamento e distribuição de bibliotecas em Ruby. Ele possui recursos como versionamento, dependência entre bibliotecas, distribuição de executáveis, entre outros.  

Neste artigo veremos como gerenciar pacotes rubygems e utilizá-los em seus programas.

<!-- more -->

## O ambiente RubyGems

O RubyGems é composto de:

1. o aplicativo de gerenciamento chamado `gem`.
2. as bibliotecas instaladas, chamadas de `gems`.
3. a biblioteca em Ruby chamada `rubygems`.

Pessoalmente me referencio a eles como **o** _(aplicativo)_ gem e **as** _(bibliotecas)_ gems. Sendo assim, digo que o `gem` (aplicativo) possui diversos comandos para gerenciamento das `gems` (bibliotecas), ou ainda, que o `gem` (aplicativo) gerencia as `gems` (bibliotecas).

Os comandos do aplicativo `gem` podem ser divididos em duas categorias: comandos para gerenciamento de `gems` e comandos para desenvolvimento de `gems`.

## Gerenciando gems

Os principais comandos de gerenciamento de `gems` são:

_(**Nota:** dependendo do seu sistema você precisará executar esses comandos como super usuário/administrador)_

#### `gem install`
Instala uma `gem` (e suas dependências).  
**Sintaxe:** `gem install nome_da_gem`

``` console Instalando a gem sinatra
~ $ gem install sinatra
Fetching: rack-1.4.0.gem (100%)
Fetching: rack-protection-1.2.0.gem (100%)
Fetching: tilt-1.3.3.gem (100%)
Fetching: sinatra-1.3.2.gem (100%)
Successfully installed rack-1.4.0
Successfully installed rack-protection-1.2.0
Successfully installed tilt-1.3.3
Successfully installed sinatra-1.3.2
4 gems installed
Installing ri documentation for rack-1.4.0...
Installing ri documentation for rack-protection-1.2.0...
Installing ri documentation for tilt-1.3.3...
Installing ri documentation for sinatra-1.3.2...
Installing RDoc documentation for rack-1.4.0...
Installing RDoc documentation for rack-protection-1.2.0...
Installing RDoc documentation for tilt-1.3.3...
Installing RDoc documentation for sinatra-1.3.2...
```

Observe que ao instalar a gem _sinatra_, várias outras gems foram instaladas automaticamente (suas dependências). Para cada gem instalada (inclusive as dependências) as seguintes operações serão realizadas:

1. Download da gem
2. Instalação da gem
3. Instalação das documentações estática ([RDoc](https://github.com/rdoc/rdoc)) e interativa (ri)

O comando `gem install` sempre instala a versão mais recente das gems. Caso deseje instalar uma versão específica, use a opção `--version`:

``` console Instalando uma versão específica
~ $ gem install sinatra --version 1.0.0
Fetching: sinatra-1.0.gem (100%)
Successfully installed sinatra-1.0
1 gem installed
Installing ri documentation for sinatra-1.0...
Installing RDoc documentation for sinatra-1.0...
```

#### `gem uninstall`
Desinstala uma `gem` (e **NÃO** suas dependências).  
**Sintaxe:** `gem uninstall nome_da_gem`

``` console Desinstalando a gem sinatra
~ $ gem uninstall sinatra
Successfully uninstalled sinatra-1.3.2
```

O comando `uninstall` **NÃO** irá desinstalar nenhuma das dependências. Isso porque "pode ser" que alguma dependência seja utilizada por outra gem.

Caso você possua mais de uma versão da mesma gem, você deverá selecionar qual versão quer desinstalar: interativamente ou manualmente.

``` console Desinstalando com várias versões
~ $ gem uninstall sinatra

Select gem to uninstall:
 1. sinatra-1.0
 2. sinatra-1.3.2
 3. All versions
> 1
Successfully uninstalled sinatra-1.0

~ $ gem uninstall sinatra --version  1.3.2
Successfully uninstalled sinatra-1.3.2
```

Você ainda pode remover todas as versões da gem usando a opção `--all`

#### `gem outdated`
Exibe quais gems estão desatualizadas (se há uma versão mais recente disponível).
**Sintaxe:** `gem outdated`

Se eu tiver instalado apenas a versão 1.0 da gem sinatra o resultado seria esse:

```
~ $ gem outdated
sinatra (1.0 < 1.3.2)
```

#### `gem update`
Atualiza uma (ou mais) gems para a versão mais recente.
**Sintaxe:** `gem update uma_gem outra_gem ...`

Supondo ainda o caso anterior eu poderia atualizar a gem sinatra para a versão mais recente com o comando

```
~ $ gem update sinatra
Updating installed gems
Updating sinatra
Fetching: sinatra-1.3.2.gem (100%)
Successfully installed sinatra-1.3.2
Gems updated: sinatra
Installing ri documentation for sinatra-1.3.2...
Installing RDoc documentation for sinatra-1.3.2...
```

Caso deseje atualizar todas as gems, você pode usar o comando sem especificar nenhuma gem: `gem update`.

#### `gem server`
Inicia o servidor de documentação (e repositório) de gems
**Sintaxe:** `gem server`

{% img /images/posts/rubygems_parte1/gem_server.png %}

O servidor ira iniciar na porta `8808`. Esse servidor é mais comumente usado para consultar a documentação instalada com as gems.  

Uma outra utilidade deste servidor é a instalação de gems. Se um computador na sua rede pode instalar as gems a partir do seu computador (oa invés da internet), usando o comando `gem install nome_da_gem --source http://seu_computador:8808`.

## Utilizando gems

O ruby possui o comando `require` que inclui arquivos externos ao seu arquivo atual. Por padrão, o interpretador Ruby irá procurar pelo arquivo nos diretórios especificados pela variávei `$LOAD_PATH`. Desse modo, usar bibliotecas externas (de maneira modular) exige o trabalho de:

1. Adicionar as bibliotecas ao `$LOAD_PATH`
2. Incluir a biblioteca

Quando se adiciona questões como gerenciamento de versões e dependências a coisa complica ainda mais.

A bblioteca `rubygems` fornece uma solução fácil para utilizar gems em seus programas.

{% include_code Utilizando a gem sinatra 001/usando_sinatra.rb %}

Começamos incluindo a biblioteca `rubygems`. Ela se encarrega de modificar o `require` padrão do Ruby para tratar gems e dependências.

Em seguida, incluimos a biblioteca `sinatra`. Com o rubygems carregado, esse require sabe onde encontrar a biblioteca sinatra.

Finalmente utilizamos a biblioteca sinatra. Observe que o código é executado normalmente no interpretador Ruby, sem nenhum parâmetro adicional ou configuração prévia. Precisamos apenas ter a gem sinatra instalada via Rubygems.

    $ ruby usando_sinatra.rb 
    [2012-01-11 01:20:56] INFO  WEBrick 1.3.1
    [2012-01-11 01:20:56] INFO  ruby 1.9.2 (2011-07-09) [x86_64-darwin10.8.0]
    == Sinatra/1.3.2 has taken the stage on 4567 for development with backup from WEBrick
    [2012-01-11 01:20:56] INFO  WEBrick::HTTPServer#start: pid=30324 port=4567

Observe que a versão utilizada é a `1.3.2` (a mais recente) da gem.

A biblioteca `rubygems` também fornece facilidades para o gerenciamento de versões. O exemplo a seguir mostra como utilizar uma versão específica (1.0) da gem sinatra.

{% include_code Utilizando uma versão específica da gem sinatra 001/usando_sinatra_10.rb %}

    $ ruby usando_sinatra_10.rb
    == Sinatra/1.0 has taken the stage on 4567 for development with backup from WEBrick
    [2012-01-11 01:20:40] INFO  WEBrick 1.3.1
    [2012-01-11 01:20:40] INFO  ruby 1.9.2 (2011-07-09) [x86_64-darwin10.8.0]
    [2012-01-11 01:20:40] INFO  WEBrick::HTTPServer#start: pid=30310 port=4567

## Entendendo o ambiente

Para entender melhor o funcionamento do Rubygems vamos examinar o ambiente que o aplicativo `gem` e a biblioteca `rubygems` compartilham. 

Veja a saída do comando `gem environment`:

    ~ $ gem environment
    RubyGems Environment:
      - RUBYGEMS VERSION: 1.3.6
      - RUBY VERSION: 1.8.7 (2010-01-10 patchlevel 249) [universal-darwin11.0]
      - INSTALLATION DIRECTORY: /Library/Ruby/Gems/1.8
      - RUBY EXECUTABLE: /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby
      - EXECUTABLE DIRECTORY: /usr/bin
      - RUBYGEMS PLATFORMS:
        - ruby
        - universal-darwin-11
      - GEM PATHS:
         - /Library/Ruby/Gems/1.8
         - /Users/juniorz/.gem/ruby/1.8
         - /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8
      - GEM CONFIGURATION:
         - :update_sources => true
         - :verbose => true
         - :benchmark => false
         - :backtrace => false
         - :bulk_threshold => 1000
         - "install" => "--no-rdoc --no-ri"
         - "update" => "--no-rdoc --no-ri"
      - REMOTE SOURCES:
         - http://rubygems.org/

As `gems` são organizadas em `GEM PATHS`. O aplicativo `gem` instala as gems em um desses diretórios e a biblioteca `rubygems` procura as gems em todos esses diretórios.

Um `Gem Path` tem a seguinte estrutura:

* **bin/**  
  Diretório onde os executáveis instalados pelas gems residem.

* **cache/**  
  Diretório onde os pacotes `.gem` ficam armazenados. Ao usar `gem server` como um servidor local de instalação, as gems em cache serão disponibilizadas para instalação.

* **doc/**  
  Diretório onde as documentações são instaladas. Cada gem (e cada versão) possui um diretório separado.
  
* **gems/**  
  Diretório onde as gems são instaladas. Cada gem (e cada versão) possui um diretório separado. Basicamente é o pacote `.gem` descompactado.

* **specifications/**  
  Todas as especificações de gems (arquivos `.gemspec`) ficam nesse diretório. Os arquivos `.gemspec` possuem meta-informações das gems (há um arquivo pra cada gem e cada versão).

Olhando o ambiente em questão vemos que há dois diretórios bem distintos:

* **/Library/Ruby/Gems/1.8** - Diretório com escrita somente para super usuário. Gems instaladas **com** `sudo gem install` vão nesse gem path e estão disponíveis para qualquer usuário do sistema.
* **/Users/juniorz/.gem/ruby/1.8** - Diretório com escrita somente para o meu usuário. Gems instaladas com `gem install` vão nesse gem path e estão disponíveis apenas para o meu usuário.


## Conclusão

O RubyGems é o fundamento da modularidade em nível de bibliotecas. No próximo artigo, veremos como criar suas próprias `gems` e como gerenciar as dependências de seus projetos usando [Bundler](http://gembundler.com/).