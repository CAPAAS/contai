# Contai Gem - Полное руководство по использованию

## Быстрый старт

### 1. Установка

```ruby
# Gemfile
gem 'contai'
```

```bash
bundle install
rails generate contai:install
```

### 2. Настройка модели

```ruby
# app/models/article.rb
class Article < ApplicationRecord
  include Contai::Generatable
  
  contai do
    prompt_from :title, :description
    output_to :body
    provider :openai, api_key: ENV['OPENAI_API_KEY']
    template "Напиши подробную статью на тему: {{title}}. Описание: {{description}}"
  end
end
```

### 3. Использование в контроллере

```ruby
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  def create
    @article = Article.new(article_params)
    
    if @article.save
      # Синхронная генерация
      @article.generate_ai_content!
      
      # Или асинхронная
      # @article.generate_ai_content!(async: true)
      
      redirect_to @article
    else
      render :new
    end
  end
  
  def generate_content
    @article = Article.find(params[:id])
    
    if @article.generate_ai_content!
      redirect_to @article, notice: 'Контент успешно сгенерирован!'
    else
      redirect_to @article, alert: 'Ошибка генерации контента'
    end
  end
  
  private
  
  def article_params
    params.require(:article).permit(:title, :description)
  end
end
```