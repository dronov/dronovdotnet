#!/usr/bin/env ruby

require 'date'
require 'fileutils'

TRANSLIT = {
  'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'g', 'д' => 'd', 'е' => 'e', 'ё' => 'e',
  'ж' => 'zh', 'з' => 'z', 'и' => 'i', 'й' => 'y', 'к' => 'k', 'л' => 'l', 'м' => 'm',
  'н' => 'n', 'о' => 'o', 'п' => 'p', 'р' => 'r', 'с' => 's', 'т' => 't', 'у' => 'u',
  'ф' => 'f', 'х' => 'h', 'ц' => 'ts', 'ч' => 'ch', 'ш' => 'sh', 'щ' => 'sch',
  'ъ' => '', 'ы' => 'y', 'ь' => '', 'э' => 'e', 'ю' => 'yu', 'я' => 'ya'
}.freeze

def slugify(title)
  title
    .downcase
    .chars
    .map { |char| TRANSLIT.fetch(char, char) }
    .join
    .gsub(/[^a-z0-9]+/, '-')
    .gsub(/\A-|-+\z/, '')
end

def yaml_string(value)
  "\"#{value.gsub('\\', '\\\\\\').gsub('"', '\"')}\""
end

print 'Название статьи: '
title = STDIN.gets&.strip.to_s

abort 'Название статьи не может быть пустым' if title.empty?

date = Date.today
slug = slugify(title)
abort 'Не удалось сделать slug из названия статьи' if slug.empty?

path = File.join(__dir__, '..', 'source', "#{date.strftime('%Y-%m-%d')}-#{slug}.html.markdown")
abort "Файл уже существует: #{path}" if File.exist?(path)

content = <<~MARKDOWN
  ---
  title: #{yaml_string(title)}
  title_ru: #{yaml_string(title)}
  title_en:
  date: #{date.strftime('%Y-%m-%d')} 12:00 UTC
  tags:
  ---

  <div data-translation-content="ru" markdown="1">

  Русский текст статьи.

  </div>

  <div data-translation-content="en" markdown="1" hidden>

  English article text.

  </div>
MARKDOWN

FileUtils.mkdir_p(File.dirname(path))
File.write(path, content)

puts "Создан файл: #{path}"
