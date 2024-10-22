# Обработка ревизия индексов MS SQL
## Описание
Данная обработка позволяет выявить созданные\удаленные\измененные в обход платформы 1С индексы на СУБД MS SQL или PostgreSQL.
*Тестировалась на 8.3.22*

## Использование
Запустить обработку в анализируемой базе 1С
Выбрать откуда будут получаться данные о имеющихся индексах
1. Получение данных MS SQL - При этом станут доступны дополнительные настройки для прямого соединения с базой на СУБД MS SQL
2. Из csv-файла MS SQL - При этом необходимо в анализируемой базе в СУБД MS SQL выполнить запрос из поля, открывающегося по клику на гиперссылку "Текст запроса". Результат запроса необходимо сохранить на диск в формате csv и указать путь к нему в обработке в поле "Путь к файлу SQL"
3. Из csv-файла PostgreSQL - При этом необходимо в анализируемой базе в СУБД PostgreSQL выполнить запрос из поля, открывающегося по клику на гиперссылку "Текст запроса".Результат запроса необходимо сохранить на диск в формате csv и указать путь к нему в обработке в поле "Путь к файлу SQL"

После указания источника неоходимо нажать на кнопку "Сформировать"

Обработка сформирует отчет, в котором можно увидеть данные о индексах, их статусах (добавлен\удален) и увидеть запрос создания данного индекса на СУБД PostgreSQL