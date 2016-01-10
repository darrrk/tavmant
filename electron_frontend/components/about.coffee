# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM


module.exports = class extends React.Component

    render : ->
        $.div null,
            $.div class-name : "pager row",
                "Версия: #{global.tavmant.VERSION}"
            $.div class-name : "pager row",
                "Истекает: #{global.tavmant.EXPIRED}"
            $.ul class-name : "pager row",
                $.li null,
                    "12.4.1"
                    $.ul null,
                        $.li null, "Исправление недочета, где происходило излишнее копирование изображений для резки"
                $.li null,
                    "12.4.0"
                    $.ul null,
                        $.li null, "Выполнение \"Сбор данных\" перед построением категорий и HTML, что способствует \
                        ускорению и расширению функционала"
                $.li null,
                    "12.3.0"
                    $.ul null,
                        $.li null, "Модуль \"Галерея\" удален"
                $.li null,
                    "12.2.0"
                    $.ul null,
                        $.li null, "В интерфейс добавлен модуль \"Галерея\""
                        $.br!
                        $.li null, "Очистка кеша перенесена в \"Настройки\""
                        $.br!
                        $.li null, "Более компактный вид категорий/подкатегорий"
                $.li null,
                    "12.1.0"
                    $.ul null,
                        $.li null, "Добавление категорий/подкатегорий/... в начало таблицы"
                        $.br!
                        $.li null, "Исправлена ошибка, где при переименовании категории/подкатегории/... старая не удалялась"
                $.li null,
                    "12.0.2"
                    $.ul null,
                        $.li null, "Исправлена регрессия - неправильная сортировка меню"
                $.li null,
                    "12.0.1"
                    $.ul null,
                        $.li null, "Исправлена ошибка, при которой не запускался сайт при портфолио-режиме"
                $.li null,
                    "12.0.0"
                    $.ul null,
                        $.li null, "Переделана структура категорий, что поспособствует расширению функционала"
                $.li null,
                    "11.4.2"
                    $.ul null,
                        $.li null, "Обновление до 12 версии"
                $.li null,
                    "11.4.1"
                    $.ul null,
                        $.li null, "Всякие опрятности в панели - Облако"
                $.li null,
                    "11.4.0"
                    $.ul null,
                        $.li null, "Добавлена панель - Кеш"
                $.li null,
                    "11.3.0"
                    $.ul null,
                        $.li null, "Кеширование резки изображений"
                        $.br!
                        $.li null, "Исправлена регрессия, где не отображались страницы при Якубовиче"
                $.li null,
                    "11.2.0"
                    $.ul null,
                        $.li null, "Видать все усы Якубовича"
                $.li null,
                    "11.1.0"
                    $.ul null,
                        $.li null, "Раздел голых категорий для разруливания конфликтов"
                        $.br!
                        $.li null, "Исправлено, когда в логах вместо ошибки - undefined"
                $.li null,
                    "11.0.4"
                    $.ul null,
                        $.li null, "Исправлена перезагрузка на кнопке Сохранить в облаке, настройках"
                $.li null,
                    "11.0.3"
                    $.ul null,
                        $.li null, "Улучшения в стабильности категорий"
                $.li null,
                    "11.0.2"
                    $.ul null,
                        $.li null, "починка резак изображений на windows"
                $.li null,
                    "11.0.1"
                    $.ul null,
                        $.li null, "Список файлов в контейнере с прокруткой"
                        $.br!
                        $.li null, "Исправлена ошибка, где в Windows не открывались категории"
                $.li null,
                    "11.0.0"
                    $.ul null,
                        $.li null, "резка изображений в ~2 раза быстрее из-за использования libvips вместо GraphicsMagick"
                $.li null,
                    "10.0.2"
                    $.ul null,
                        $.li null, "не срабатывает лишний раз копирование изображений при резке одной фотографии"
