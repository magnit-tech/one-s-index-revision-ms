# Обработка ревизия индексов MS SQL
## Описание
Данная обработка позволяет выявить созданные\удаленные\измененные в обход платформы 1С индексы на СУБД MS SQL или PostgreSQL.
*Тестировалась на 8.3.22 и на 8.3.25*

## Использование
Запустить обработку в анализируемой базе 1С
Выбрать откуда будут получаться данные о имеющихся индексах
1. Получение данных MS SQL - При этом станут доступны дополнительные настройки для прямого соединения с базой на СУБД MS SQL
2. Из csv-файла MS SQL - При этом необходимо в анализируемой базе в СУБД MS SQL выполнить запрос из поля, открывающегося по клику на гиперссылку "Текст запроса". Результат запроса необходимо сохранить на диск в формате csv и указать путь к нему в обработке в поле "Путь к файлу SQL"
3. Из csv-файла PostgreSQL - При этом необходимо в анализируемой базе в СУБД PostgreSQL выполнить запрос из поля, открывающегося по клику на гиперссылку "Текст запроса".Результат запроса необходимо сохранить на диск в формате csv и указать путь к нему в обработке в поле "Путь к файлу SQL"

После указания источника неоходимо нажать на кнопку "Сформировать"

Обработка сформирует отчет, в котором можно увидеть данные о индексах, их статусах (добавлен\удален) и увидеть запрос создания данного индекса на СУБД PostgreSQL. Кроме этого будет сгенерирован скрипт для удаления дублей записей таблиц по ключевым полям индекса. Эти дубли мешают создать индекс с ключем UNIQUE. Скрипты можно выполнить например в консоли PG admin. 	
Вначале делам для КЛАСТЕРНОГО индекса, потом, если есть для остальных индексов: 
1. Пробуем вначале создать индекс по соответствующему скрипту из отчета. 
2. Если индекс не создается по ошибке: «ERROR: Ключ (_fld71rref, _fld72rref)=(\x855e005056a0012711efee98a679cb46, \x855e005056a0012711efee91e986438a, \x855e005056a0012711efee91e9cf742e) дублируется.создать уникальный индекс ""_inforg70_1"" не удалось», то следует использовать скрипты по удалению задублированных строк. Крипт нужно использовать осторожно.
3. Переходим к п.1
Кроме того 1С не предоставляет информацию по тому кластерный это индекс или нет. Поэтому нужно вручную определить признак кластерный это индекс и выставить его."