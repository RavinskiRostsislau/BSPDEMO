///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ИдентификаторыТипов = Новый Массив;
	ИдентификаторыТипов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ._ДемоОприходованиеТоваров"));
	ИдентификаторыТипов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ._ДемоПеремещениеТоваров"));
	ИдентификаторыТипов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ._ДемоСписаниеТоваров"));
	
	МетаданныеТипов = Новый Массив;
	МетаданныеТипов.Добавить(Метаданные.Документы._ДемоОприходованиеТоваров);
	МетаданныеТипов.Добавить(Метаданные.Документы._ДемоПеремещениеТоваров);
	МетаданныеТипов.Добавить(Метаданные.Документы._ДемоСписаниеТоваров);
	
	ПраваПоИдентификаторам = УправлениеДоступом.ПраваПоИдентификаторам(ИдентификаторыТипов);
	
	Изменение = Ложь;
	ОтборТипыДокументов = Новый Массив;
	Для Каждого Идентификатор Из ИдентификаторыТипов Цикл
		Права = ПраваПоИдентификаторам.Получить(Идентификатор);
		Если Не Права.Чтение Тогда
			Продолжить;
		КонецЕсли;
		ОтборТипыДокументов.Добавить(Идентификатор);
		Если Права.Изменение Тогда
			Изменение = Истина;
		КонецЕсли;
		Если Права.Добавление Тогда
			ОбъектМетаданных = МетаданныеТипов[ИдентификаторыТипов.Найти(Идентификатор)];
			Команда = Команды.Добавить("Создать" + ОбъектМетаданных.Имя);
			Команда.Действие = "Подключаемый_Создать";
			Команда.Заголовок = ОбъектМетаданных.Представление();
			Кнопка = Элементы.Добавить("Создать" + ОбъектМетаданных.Имя, Тип("КнопкаФормы"), Элементы.Создать);
			Кнопка.ИмяКоманды = Команда.Имя;
			Кнопка = Элементы.Добавить("СписокКонтекстноеМенюСоздать" + ОбъектМетаданных.Имя, Тип("КнопкаФормы"),
				Элементы.СписокКонтекстноеМенюСоздать);
			Кнопка.ИмяКоманды = Команда.Имя;
		КонецЕсли;
	КонецЦикла;
	
	Если Не Изменение Тогда
		ТолькоПросмотр = Ложь;
		
		Элементы.Скопировать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСкопировать.Видимость = Ложь;
		
		Элементы.ПометитьНаУдаление.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюПометитьНаУдаление.Видимость = Ложь;
		
		Элементы.Провести.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюПровести.Видимость = Ложь;
		
		Элементы.ОтменитьПроведение.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюОтменитьПроведение.Видимость = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ТипСсылки",
		ОтборТипыДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов")
	 Или Не ПравоДоступа("Редактирование", Метаданные.РегистрыСведений._ДемоРеестрСкладскихДокументов) Тогда
		
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КомандыФормы;
	ПараметрыРазмещения.Источники = Метаданные.РегистрыСведений._ДемоРеестрСкладскихДокументов.Измерения.Ссылка.Тип;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельСписокРеализаций;
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов("ДокументСсылка._ДемоРеализацияТоваров");
	ПараметрыРазмещения.ПрефиксГрупп = "СписокРеализаций";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		Элементы.Комментарий.Видимость = Ложь;
		Элементы.Ответственный.Видимость = Ложь;
		Элементы.СписокРеализацийКомментарий.Видимость = Ложь;
		Элементы.СписокРеализацийОтветственный.Видимость = Ложь;
		Элементы.Создать.Отображение = ОтображениеКнопки.Картинка;
		СоставКоманднойПанелиНаМобильномУстройстве.Добавить(Элементы.КоманднаяПанель);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись__ДемоОприходованиеТоваров"
	 Или ИмяСобытия = "Запись__ДемоПеремещениеТоваров"
	 Или ИмяСобытия = "Запись__ДемоСписаниеТоваров" Тогда
	
		ПодключитьОбработчикОжидания("ОбновитьСписок", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	#Если МобильныйКлиент Тогда
		ИзменитьСоставКоманднойПанелиНаМобильномУстройстве();
	#КонецЕсли
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьТекущийДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	СтрокаДоступна = Элемент.ТекущиеДанные <> Неопределено;
	
	Элементы.Скопировать.Доступность = СтрокаДоступна;
	Элементы.СписокКонтекстноеМенюСкопировать.Доступность = СтрокаДоступна;
	
	Элементы.ПометитьНаУдаление.Доступность = СтрокаДоступна;
	Элементы.СписокКонтекстноеМенюПометитьНаУдаление.Доступность = СтрокаДоступна;
	
	Элементы.Провести.Доступность = СтрокаДоступна;
	Элементы.СписокКонтекстноеМенюПровести.Доступность = СтрокаДоступна;
	
	Элементы.ОтменитьПроведение.Доступность = СтрокаДоступна;
	Элементы.СписокКонтекстноеМенюОтменитьПроведение.Доступность = СтрокаДоступна;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьТекущийДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ПодключитьОбработчикОжидания("ПометитьНаУдалениеСнятьПометку", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы


// Параметры:
// 	Команда - КомандаФормы
//
&НаКлиенте
Процедура Подключаемый_Создать(Команда)
	
	ИмяФормыДокумента = "Документ." + Сред(Команда.Имя, 8) + ".ФормаОбъекта";
	
	ОткрытьФорму(ИмяФормыДокумента, , Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Скопировать(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Документ = Элементы.Список.ТекущиеДанные.Ссылка;
	ИмяФормыДокумента = ИмяФормыДокумента(Документ);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначениеКопирования", Документ);
	
	ОткрытьФорму(ИмяФормыДокумента, ПараметрыФормы, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ПометитьНаУдалениеСнятьПометку();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, ТекущийСписок(ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, ТекущийСписок(ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, ТекущийСписок(ЭтотОбъект));
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура УстановитьПериод(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = УстановленныйПериод;
	Диалог.Показать(Новый ОписаниеОповещения("УстановитьПериодЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура Провести(Команда)
	
	УстановитьПроводки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПроведение(Команда)
	
	УстановитьПроводки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекущийСписок(Форма)
	Если Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаСкладскиеДокументы Тогда
		Возврат Форма.Элементы.Список;
	ИначеЕсли Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаРеализации Тогда
		Возврат Форма.Элементы.СписокРеализаций;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок()
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТекущийДокумент()
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Документ = Элементы.Список.ТекущиеДанные.Ссылка;
	ИмяФормыДокумента = ИмяФормыДокумента(Документ);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Документ);
	
	ОткрытьФорму(ИмяФормыДокумента, ПараметрыФормы, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометку()
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные.ПометкаУдаления Тогда
		ШаблонВопроса = НСтр("ru = 'Снять с ""%1"" пометку на удаление?'");
	Иначе
		ШаблонВопроса = НСтр("ru = 'Пометить ""%1"" на удаление?'");
	КонецЕсли;
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонВопроса, Строка(ТекущиеДанные.Ссылка));
	
	Контекст = Новый Структура;
	Контекст.Вставить("Ссылка",          ТекущиеДанные.Ссылка);
	Контекст.Вставить("ПометкаУдаления", ТекущиеДанные.ПометкаУдаления);
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПометитьНаУдалениеСнятьПометкуЗавершение", ЭтотОбъект, Контекст),
		ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометкуЗавершение(Ответ, Контекст) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПометитьНаУдалениеСнятьПометкуНаСервере(Контекст.Ссылка);
	
	ТекстОповещения = ?(Контекст.ПометкаУдаления,
		НСтр("ru = 'Пометка удаления снята'"),
		НСтр("ru = 'Пометка удаления установлена'"));
	
	
	ОповеститьОбИзменении(Контекст.Ссылка);
	
	ПоказатьОповещениеПользователя(ТекстОповещения,
		ПолучитьНавигационнуюСсылку(Контекст.Ссылка), Строка(Контекст.Ссылка), БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура ПометитьНаУдалениеСнятьПометкуНаСервере(Ссылка)
	
	ЗаблокироватьДанныеДляРедактирования(Ссылка);
	ДокументОбъект = Ссылка.ПолучитьОбъект();
	
	ДокументОбъект.ПометкаУдаления = Не ДокументОбъект.ПометкаУдаления;
	
	Если ДокументОбъект.Проведен Тогда
		ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	Иначе
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

// Завершение процедуры УстановитьПериод.
&НаКлиенте
Процедура УстановитьПериодЗавершение(Период, Контекст) Экспорт
	
	Если Период = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УстановленныйПериод = Период;
	
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода", УстановленныйПериод.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода",
		?(ЗначениеЗаполнено(УстановленныйПериод.ДатаОкончания),
			КонецДня(УстановленныйПериод.ДатаОкончания),
			УстановленныйПериод.ДатаОкончания));
	
КонецПроцедуры

&НаКлиенте
Функция ИмяФормыДокумента(Ссылка)
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка._ДемоОприходованиеТоваров") Тогда
		ИмяФормыДокумента = "Документ._ДемоОприходованиеТоваров.ФормаОбъекта"
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка._ДемоПеремещениеТоваров") Тогда
		ИмяФормыДокумента = "Документ._ДемоПеремещениеТоваров.ФормаОбъекта"
	
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка._ДемоСписаниеТоваров") Тогда
		ИмяФормыДокумента = "Документ._ДемоСписаниеТоваров.ФормаОбъекта"
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестный тип документа %1'"), ТипЗнч(Ссылка));
	КонецЕсли;
	
	Возврат ИмяФормыДокумента;
	
КонецФункции

&НаКлиенте
Процедура УстановитьПроводки(Провести)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	УстановитьПроводкиНаСервере(ТекущиеДанные.Ссылка, Провести);
	
	ОповеститьОбИзменении(ТекущиеДанные.Ссылка);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Изменение'"),
		ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка), Строка(ТекущиеДанные.Ссылка), БиблиотекаКартинок.Информация32);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьПроводкиНаСервере(Ссылка, Провести)
	
	ЗаблокироватьДанныеДляРедактирования(Ссылка);
	ДокументОбъект = Ссылка.ПолучитьОбъект(); // ДокументОбъект
	
	Если Провести Тогда
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьСоставКоманднойПанелиНаМобильномУстройстве()
	
	Для Каждого ЭлементКоманднойПанели Из СоставКоманднойПанелиНаМобильномУстройстве Цикл
		СоставКоманднойПанелиНаМобильномУстройстве.Удалить(ЭлементКоманднойПанели);
	КонецЦикла;
	
	ЭлементКоманднойПанели = ?(Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСкладскиеДокументы,
		Элементы.КоманднаяПанель, Элементы.КоманднаяПанельСписокРеализаций);
		
	СоставКоманднойПанелиНаМобильномУстройстве.Добавить(ЭлементКоманднойПанели);
	
КонецПроцедуры

#КонецОбласти
