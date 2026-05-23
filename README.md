# dronovdotnet
My personal blog at dronov.net

## Генератор статьи

Создать новую статью:

```sh
ruby bin/new_article.rb
```

Или через rake:

```sh
rake article:new
```

Генератор спросит название статьи и создаст файл в `source/` с текущей датой в имени. Внутри будет `front matter` с `title_ru`, пустым `title_en` и двумя блоками для русского и английского текста.

## Переводы статей

Переводы живут в одном markdown-файле статьи. У статьи остаётся один slug и один URL, а языковые версии размечаются отдельными блоками внутри файла.

```yaml
---
title: Ужасный, ужасный Terraform
title_ru: Ужасный, ужасный Terraform
title_en: Terraform, the terrible
date: 2024-02-21 12:20 UTC
tags: terraform, clean_code
---
```

```markdown
<div data-translation-content="ru" markdown="1">

Русский текст статьи.

</div>

<div data-translation-content="en" markdown="1" hidden>

English article text.

</div>
```

Поддерживаются языки `ru` и `en`. Если у статьи нет обоих заголовков `title_ru` и `title_en`, переключатель языков не выводится.

Язык выбирается автоматически: сначала сохранённый выбор в браузере, затем язык браузера, затем английский. Переключатель появляется в верхнем меню справа только на статьях с переводами.
