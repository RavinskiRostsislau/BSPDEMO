///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ИтерацияПроверки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		ТекстЗаголовкаФормы = НСтр("ru = 'Выгрузить данные в локальную версию'");
		ТекстСообщения      = НСтр("ru = 'Данные из сервиса будут выгружены в файл для последующей их загрузки
			|и использования в локальной версии.'");
	Иначе
		ТекстЗаголовкаФормы = НСтр("ru = 'Выгрузить данные для перехода в сервис'");
		ТекстСообщения      = НСтр("ru = 'Данные из локальной версии будут выгружены в файл для последующей их загрузки
			|и использования в режиме сервиса.'");
	КонецЕсли;
	Элементы.ДекорацияПредупреждение.Заголовок = ТекстСообщения;
	Заголовок = ТекстЗаголовкаФормы;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОткрытьФормуАктивныхПользователей(Команда)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.АктивныеПользователи");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	СвойстваВременногоФайла = Неопределено;

	Если РежимВыгрузкиДляТехническойПоддержки Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузкаДанныхДляТехническойПоддержкиПроверкаЗавершение", ЭтотОбъект);

		ЧастиСтрокиВопроса = Новый Массив;
		ЧастиСтрокиВопроса.Добавить(НСтр("ru = 'В режиме выгрузки для технической поддержки не будут выгружаться присоединенные файлы, версии объектов и др.'"));
		ЧастиСтрокиВопроса.Добавить(Символы.Пс);
		ЧастиСтрокиВопроса.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Полученную выгрузку следует использовать только в целях расследования проблем и тестирования.'"), Новый Шрифт(,, Истина), WebЦвета.Красный));
		ЧастиСтрокиВопроса.Добавить(Символы.Пс);
		ЧастиСтрокиВопроса.Добавить(НСтр("ru = 'Продолжить?'"));
		ПоказатьВопрос(ОписаниеОповещения, Новый ФорматированнаяСтрока(ЧастиСтрокиВопроса), РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.Отмена);

	Иначе
		ЗапуститьВыгрузкуДанных();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте 
Процедура СохранитьФайлВыгрузки()
	
	Если РежимВыгрузкиДляТехническойПоддержки Тогда
		ИмяФайлаНаКлиенте = "data_dump_technical_support.zip";
	Иначе
		ИмяФайлаНаКлиенте = "data_dump.zip";
	КонецЕсли;
	
	ПараметрыПередачи = ФайлыБТСКлиент.ПараметрыПолученияФайла();
	Если ЭтоАдресВременногоХранилища(АдресДанныхВыгрузки) Тогда
		ПараметрыПередачи.ИмяФайлаИлиАдрес = АдресДанныхВыгрузки;
	Иначе
		ПараметрыПередачи.ИмяФайлаИлиАдрес = СвойстваВременногоФайла.Имя;
		ПараметрыПередачи.ПутьФайлаWindows = СвойстваВременногоФайла.ПутьWindows;
		ПараметрыПередачи.ПутьФайлаLinux = СвойстваВременногоФайла.ПутьLinux;
	КонецЕсли;
	ПараметрыПередачи.ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ПослеСохраненияФайлаВыгрузки", ЭтотОбъект);
	ПараметрыПередачи.БлокируемаяФорма = ЭтотОбъект;
	ПараметрыПередачи.ЗаголовокДиалогаСохранения = НСтр("ru = 'Получение файла выгрузки'");
	ПараметрыПередачи.ФильтрДиалогаСохранения = СтрШаблон(НСтр("ru = 'Архивы %1'"), "(*.zip)|*.zip");
	ПараметрыПередачи.ИмяФайлаДиалогаСохранения = ИмяФайлаНаКлиенте;
	
	ФайлыБТСКлиент.ПолучитьФайлИнтерактивно(ПараметрыПередачи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСохраненияФайлаВыгрузки(ОписаниеФайла, ДополнительныеПараметры) Экспорт
	
	Если ОписаниеФайла = Неопределено Тогда
		
		Оповещение = Новый ОписаниеОповещения("ОбработкаВопросаОбОшибкеПолученияФайла", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Файл выгрузки подготовлен, но не получен клиентом. 
		|Повторить попытку сохранения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	УдалитьВременныеДанныеПослеСохранения();
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВопросаОбОшибкеПолученияФайла(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		УдалитьВременныеДанныеПослеСохранения();
		Закрыть();
		Возврат;
		
	КонецЕсли; 
	
	СохранитьФайлВыгрузки();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВременныеДанныеПослеСохранения()

	Если СвойстваВременногоФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайлаНаСервере = ФайлыБТС.ПолноеИмяФайлаВСеансе(СвойстваВременногоФайла.Имя,
	СвойстваВременногоФайла.ПутьWindows,
	СвойстваВременногоФайла.ПутьLinux);
	
	ИмяСобытияЖР = НСтр("ru = 'Удаление файла.После сохранения файла выгрузки'", ОбщегоНазначения.КодОсновногоЯзыка());
	ФайлыБТС.УдалитьФайлыВПопытке(ИмяФайлаНаСервере, ИмяСобытияЖР);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СнятьМонопольныйРежимПослеВыгрузки()
	
	УстановитьМонопольныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьГотовностьВыгрузки()
	
	Попытка
		ГотовностьВыгрузки = ВыгрузкаГотова();
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
		СнятьМонопольныйРежимПослеВыгрузки();
		
		ОбработатьОшибку(
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
	КонецПопытки;
	
	Если ГотовностьВыгрузки Тогда
		СнятьМонопольныйРежимПослеВыгрузки();
		ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
		СохранитьФайлВыгрузки();
	Иначе
		
		ИтерацияПроверки = ИтерацияПроверки + 1;
		
		Если ИтерацияПроверки = 3 Тогда
			ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
			ПодключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки", 30);
		ИначеЕсли ИтерацияПроверки = 4 Тогда
			ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
			ПодключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки", 60);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиЗаданиеПоИдентификатору(Идентификатор)
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	
	Возврат Задание;
	
КонецФункции

&НаСервере
Функция ВыгрузкаГотова()
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Предупреждение;
	
	Если Задание = Неопределено Тогда
		ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - не найдено задание подготавливающее выгрузку.'"));
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		ОшибкаЗадания = Задание.ИнформацияОбОшибке;
		Если ОшибкаЗадания <> Неопределено Тогда
			ВызватьИсключение(ПодробноеПредставлениеОшибки(ОшибкаЗадания));
		Иначе
			ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - задание подготавливающее выгрузку завершилось с неизвестной ошибкой.'"));
		КонецЕсли;
	ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
		ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - задание подготавливающее выгрузку было отменено администратором.'"));
	Иначе
		
		ИмяФайлаВыгрузки = ПолучитьИзВременногоХранилища(АдресИмениФайлаВыгрузки);
		ОбъектФС = Новый Файл(ИмяФайлаВыгрузки);
		Если НЕ ОбъектФС.Существует() ИЛИ НЕ ОбъектФС.ЭтоФайл() Тогда
			ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - не найден файл результата'"));
		КонецЕсли;
		
		Если ОбъектФС.Размер() > ФайлыБТСКлиентСервер.ПриемлемыйРазмерВременногоХранилища() Тогда
			АдресДанныхВыгрузки = Неопределено;
			СвойстваВременногоФайла = ФайлыБТС.СвойстваНовогоВременногоФайла("zip");
			СвойстваВременногоФайла.Имя = ОбъектФС.Имя;
		Иначе
			АдресДанныхВыгрузки = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайлаВыгрузки), УникальныйИдентификатор);
			ИмяСобытияЖР = НСтр("ru = 'Удаление файла.После помещения выгрузки во временное хранилище'", ОбщегоНазначения.КодОсновногоЯзыка());
			ФайлыБТС.УдалитьФайлыВПопытке(ИмяФайлаВыгрузки, ИмяСобытияЖР);
		КонецЕсли;
		
		ИдентификаторЗадания = Неопределено;
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗапуститьВыгрузкуДанныхНаСервере()
	
	УстановитьМонопольныйРежим(Истина);
	
	Попытка
		
		АдресИмениФайлаВыгрузки = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		
		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(АдресИмениФайлаВыгрузки);
		ПараметрыЗадания.Добавить(РежимВыгрузкиДляТехническойПоддержки);

		Задание = ФоновыеЗадания.Выполнить("ВыгрузкаЗагрузкаОбластейДанных.ВыгрузитьТекущуюОбластьДанныхВАрхив", 
			ПараметрыЗадания,
			,
			НСтр("ru = 'Подготовка выгрузки области данных'"));
			
		ИдентификаторЗадания = Задание.УникальныйИдентификатор;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		УстановитьМонопольныйРежим(Ложь);
		ОбработатьОшибку(
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		
		ОтменитьЗаданиеПодготовки(ИдентификаторЗадания);
		СнятьМонопольныйРежимПослеВыгрузки();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьЗаданиеПодготовки(Знач ИдентификаторЗадания)
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено
		ИЛИ Задание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат;
	КонецЕсли;
	
	Попытка
		Задание.Отменить();
	Исключение
		// Возможно задание как раз в этот момент закончилось и ошибки нет
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отмена выполнения задания подготовки выгрузки области данных'", 
			ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьОшибку(Знач КраткоеПредставление, Знач ПодробноеПредставление)
	
	ШаблонЗаписиЖР = НСтр("ru = 'При выгрузке данных произошла ошибка:
                           |
                           |-----------------------------------------
                           |%1
                           |-----------------------------------------'");
	ТекстЗаписиЖР = СтрШаблон(ШаблонЗаписиЖР, ПодробноеПредставление);
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Выгрузка данных'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		ТекстЗаписиЖР);
	
	ШаблонИсключения = НСтр("ru = 'При выгрузке данных произошла ошибка: %1.
                             |
                             |Расширенная информация для службы поддержки записана в журнал регистрации. Если причина ошибки неизвестна - рекомендуется обратиться в службу технической поддержки, предоставив для расследования информационную базу и выгрузку журнала регистрации.'");
	
	ВызватьИсключение СтрШаблон(ШаблонИсключения, КраткоеПредставление);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаДанныхДляТехническойПоддержкиПроверкаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ЗапуститьВыгрузкуДанных();	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗапуститьВыгрузкуДанных()
	
	ТекстПредложения = НСтр("ru = 'Файл выгрузки может оказаться большим. В этом случае потребуется расширение для работы с 1С:Предприятием.
	|С этим расширением работа в веб-клиенте станет удобней не только при работе с большими файлами.'");
	Оповещение = Новый ОписаниеОповещения("ЗапуститьВыгрузкуДанныхПослеУстановкиРасширения", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстПредложения);
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗапуститьВыгрузкуДанныхПослеУстановкиРасширения(Подключено, ДополнительныеПараметры) Экспорт

	ЗапуститьВыгрузкуДанныхНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Выгрузка;
	ИтерацияПроверки = 1;
	ПодключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки", 15);

КонецПроцедуры

#КонецОбласти
