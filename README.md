# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

### Ruby version

2.4.1

### Rails version
5.1.4

### System dependencies

```ruby
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'
gem 'jquery-rails'
gem 'bootstrap', '~> 4.0.0.beta2.1'
gem 'jquery-ui-rails', '~> 6.0', '>= 6.0.1'
gem 'pg', '~> 0.18'
``` 
### Configuration
Create your `secrets.yml` inside config and 
Set your database credentials `username:` and `password:`

### Database creation
```
rails db:create
```

### Database initialization
```
rails db:migrate
```

* Deployment instructions

# Como criar uma aplicação simples de TODO list com rails

Para criarmos uma aplicação simples de lista de afazeres utilizando do framework rails e da biblioteca de drag and drop, precisamos seguir os seguintes passos.


Em primeiro lugar devemos criar uma nova aplicação

```
rails new simpletodolistapp --database=postgresql
```

Esse comando criar uma nova aplicação rails com o banco de dados postresql

Feito isso devemos configurar nosso database.yml, adicionando nosso username e password de acesso ao banco de dados

![username and password](/docs/usernamedb.png "Username e Password")

Se tudo estiver configurado corretamente, seremos capazes de criar o banco de dados.

```
rails db:create
```

Em seguida criamos nosso recurso. No nosso caso, o activities(atividades).

```
rails generate resource activities title:string position:integer
```

> O resource funciona mais ou menos como o scaffold, mas não gera as views e as funções do nosso controlador

Também devemos efetuar nossa migração para o bando de dados.

```
rails db:migrate
```


No arquivo `activities_controller.rb` localizado em app/controllers, vamos criar nossa action chamada index. Nosso controlador deve ficar dessa maneira

```ruby
class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
  end
end
```

Também devemos criar nossa view para que o controlador agora possa redirecionar para o index. Então em app/view/activities criamos um novo documento chamado `index.html.erb` e nele inserimos o seguinte.

```erb
<div class="col-md-4 sortable">
  <% @activities.each do |activity| %>
    <div class="card" data-id="<%= activity.id %>">
      <p class="card-text"><%= activity.title %></p>
      <%= link_to 'edit', edit_activity_path(activity)%>
      <%= link_to 'delete' %>
    </div>
  <%end%>
</div>
```

Com isso temos nosso controlador, visão, migração e rotas criados.

Vamos inserir algumas atividades para exibir em nosso `index.html.erb` 

Em seu terminal acesse ao rails console
```
rails c
```

Em seguida vamos criar duas novas atividades

```
Activity.create(title: "Criar UI")
```

```
Activity.create(title: "Implementar Back-End")
```

Agora para verificar se tudo esta funcionando corretamente, levatamos nosso rails servidor rails e acessamos a url da nossa aplicação http://localhost:3000/activities

```
rails server
```
Se a aplicação exibir as duas atividades, elas está configurada corretamente.

Para dar continuidade, vamos instalar algumas gems. O [bootstrap](https://github.com/twbs/bootstrap-rubygem) e o [jquery-rails](https://github.com/rails/jquery-rails) e a [jquery-ui-rails](https://github.com/jquery-ui-rails/jquery-ui-rails). Essas duas ultimas gems nos dão acesso as funcionalidades do JQuery e o JQuery UI. Para saber como instalar as gems, basta acessar aos links e seguir os passos de instalação.

O proximo desafio é implementar a biblioteca JavaScript que vai nos permitir trabalhar com o drag and drop no rails. Ela é o [html5sortable](https://github.com/lukasoppermann/html5sortable/tree/master/dist), vamos acessar ao arquivo html.sortable.js e copiar todo o conteudo presente no arquivo.

Depois acessamos a pasta app/assets/javascripts e dentro dela criamos um novo arquivo, chamado de html.sortable.js, e nesse arquivo colamos todo o conteudo que haviamos copiado do repositorio do html5sortable.

E por fim, em nosso arquivo `application.js`, localizado na mesma pasta app/assets/javascripts. Nos implementados as chamadas de bibliotecas na seguinte sequencia.

```JavaScript
//= require jquery3
//= require bootstrap-sprockets
//= require rails-ujs
//= require jquery-ui
//= require html.sortable
//= require turbolinks
//= require_tree .
```
No arquivo `activities.coffee` adicionamos o seguinte código

```coffeescript
ready = undefined
set_positions = undefined

set_positions = -> 
  $('.card').each (i) ->
    $(this).attr 'data-pos', i + 1
    return
  return

ready = ->
  set_positions()
  $('.sortable').sortable()
  return

$(document).ready ready
```

Se tudo foi configurado corretamente o drag and drop já deve funcionar e você já pode trocar as atividades de lugar. Mas isso funciona apenas no front, se dermos um reload na página, as atividades voltarao as posições anteriores. E é nisso que vamos trabalhar agora, vamos editar nosso back-end, para que as posições quando trocadas sejam permanentes.

A primeira parte de nossa integração com o back-end é atualizar nossa função ready do `activities.coffee`

```coffee
ready = undefined
set_positions = undefined

set_positions = -> 
  $('.card').each (i) ->
    $(this).attr 'data-pos', i + 1
    return
  return
ready = ->
  set_positions()
  $('.sortable').sortable()
  $('.sortable').sortable().bind 'sortupdate', (e, ui) ->
    updated_order = []
    set_positions()
    $('.card').each (i) ->
      updated_order.push
        id: $(this).data('id')
        position: i + 1
      return
    $.ajax
      type: 'PUT'
      url: '/activities/sort'
      data: order: updated_order
    return
  return

$(document).ready ready
```

Com essa nova implementação, toda vez que movermos uma atividade, a ordem será alterada no nosso vetor `updated_order` e via ajax será enviado para a action 'sort' do nosso controller.

Na action `sort` do controller atualizamos a `:position` de cada uma de nossas atividades. E na action `index` atualizamos para que a nossa lista de atividades seja com as posições corretas.

```ruby
  def index
    @activities = Activity.by_position
  end

  def sort
    params[:order].each do |key, value|
      Activity.find(value[:id]).update(position: value[:position])
    end

    render nothing: true
  end
```

No model implementamos a função responsavel por carregar a lista das atividades na ordem correta pela `:position`

```ruby
class Activity < ApplicationRecord
  
  def self.by_position
    order("position ASC")
  end

end
```

Isso é o suficiente para que nossa aplicação consiga atualizar as ordens das atividades atraves drag and drop no front e no back-end da aplicação.




