# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.ls" .call!


module.exports = class extends React.Component

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.settings_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.ul class-name : "nav nav-pills nav-stacked",
            $.li role : "presentation",
                $.a href : "\#git", "Облако"
            $.li role : "presentation",
                $.a href : "#", "Запуск сервера"
            $.li role : "presentation",
                $.a href : "\#images", "Картинки"
            $.li role : "presentation",
                $.a href : "\#assets", "Прикрепления"
            $.li role : "presentation",
                $.a href : "\#pages", "Страницы"
            $.li role : "presentation",
                $.a href : "\#partials", "Части страниц"
            $.li role : "presentation",
                $.a href : "\#layouts", "Макеты"
            if @state.model.category
                $.li role : "category",
                    $.a href : "\#category", "Категории"
            if @state.model.category
                $.li role : "category",
                    $.a href : "\#subcategory", "Подкатегории"
            if @state.model.category and not @state.model.category.portfolio
                $.li role : "category",
                    $.a href : "\#subcategory_items", "Элементы подкатегорий"
            if @state.model.category?.portfolio
                $.li role : "category",
                    $.a href : "\#portfolio", "Режим портфолио"
            if @state.model.category
                $.li role : "category",
                    $.a href : "\#rawcategory", "База данных (если конфликты)"
            $.li role : "presentation",
                $.a href : "\#settings", "Настройки"
            $.li role : "presentation",
                $.a href : "\#about", "О Tavmant"
