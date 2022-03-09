///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ
//  Обработка-шаблон помощника состоит из т.н. поставляемой и переопределяемой части.
// При реализации переопределяемой части обработки достигается необходимая
// прикладная логика работы помощника.
// Логика навигации по страницам помощника и отображение элементов формы, 
// а также вызовы обработчиков событий выполняются автоматически из поставляемой части обработки,
// которая не требует внесения изменений.
//
//  Разработка переопределяемой части.
// Переопределяемая часть помощника состоит из визуальной и программной части.
// При разработке визуальной переопределяемой части следует разработать содержание
// страниц групп "ПанельОсновная", "ПанельНавигации" и "ПанельДекорации".
// Группа "ПанельДекорации" является опциональной и может быть исключена (удалена).
// Следует отметить, что имена групп "ПанельОсновная", "ПанельНавигации"
// и "ПанельДекорации" являются зарезервированными и не подлежат изменению.
// Создание и размещение полей на страницах формы не ограничено.
// Также не накладывается ограничения на создание реквизитов формы и реквизитов объекта,
// а также команд формы и пр.
//
//  После разработки визуальной части помощника следует создать программный код 
// в переопределяемой части модуля формы помощника. Разработку программного кода 
// начинают с описания таблиц переходов.
// Для каждого возможного сценария работы помощника определяется т.н. таблица переходов.
// Каждая таблица переходов определяет только один из возможных сценариев работы помощника.
// Таблица переходов представляет собой таблицу значений, каждая строка которой описывает
// один шаг помощника, она определяет внешний вид помощника на каждом шаге и обработчики событий,
// которые соответствуют текущему шагу помощника. 
// Таблиц переходов может быть несколько, но текущая таблица переходов всегда одна, 
// т.е. навигация по страницам помощника выполняется только по одной из таблиц переходов.
// Переключение между таблицами переходов (сценариями работы помощника) обычно выполняется
// в зависимости от выполняемых пользователем действий.
//
//  Обработчики событий переходов.
// Прикладная логика работы помощника реализуется посредством обработчиков событий переходов
// по страницам помощника. Выделяют три обработчика событий: "При открытии", "При переходе далее"
// и "При переходе назад". Обработчики событий выполняются в контексте клиента(*).
// При необходимости можно выполнить контекстный или неконтекстный вызов сервера из обработчика.
// Обработчики событий представляют собой функции с набором параметров. Используя параметры обработчиков
// можно добиться требуемого поведения переходов по страницам помощника. Возвращаемое значение функции-обработчика
// никак не анализируется, поэтому рекомендуется в качестве возвращаемого значения обработчиков
// указывать значение Неопределено или ничего не возвращать. Имя функции в модуле содержит обязательный префикс
// "Подключаемый_".
// При указании имени обработчика в таблице переходов имя обработчика следует задавать без префикса "Подключаемый_".
//
//  (*)Примечание:
// Если известно, что на клиенте никаких прикладных действий выполняться не будет,
// то выполнение обработчиков событий можно перенести в контекст сервера. Для этого необходимо
// установить серверный контекст у процедур блока "ВНУТРЕННИЕ ПРОЦЕДУРЫ И ФУНКЦИИ",
// а именно, для следующих процедур установить директиву компиляции &НаСервере:
// ИзменитьПорядковыйНомерПерехода, УстановитьПорядковыйНомерПерехода, ПорядковыйНомерПереходаПриИзменении,
// ПолучитьКнопкуФормыПоИмениКоманды.
//
// Эта обработка демонстрирует только один сценарий работы помощника (одна таблица переходов).
//////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Устанавливаем текущую таблицу переходов.
	ТаблицаПереходовПоСценарию1();
	
	// Позиционируемся на первом шаге помощника.
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТекстПредупреждения = НСтр("ru = 'Закрыть помощник?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ЗакрытьФормуБезусловно = Истина;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Поставляемая часть

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяСтраницыДекорации) Тогда
		
		Элементы.ПанельДекорации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыДекорации];
		
	КонецЕсли;
	
	// Устанавливаем текущую кнопку по умолчанию.
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов.
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеДалее.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеНазад.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					ПорядковыйНомерПерехода = ПорядковыйНомерПерехода + 1;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации.
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И СтрНайти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Обработчики событий переходов.

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "СтраницаДва".
//
// Параметры:
//   Отказ - Булево - флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Функция Подключаемый_СтраницаДва_ПриПереходеДалее(Отказ)
	
	Если СУсловиямиОзнакомлен Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выполняется обработчик ПриПереходеДалее страницы № 2'"));
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Необходимо сначала ознакомиться с условиями.'"),, "СУсловиямиОзнакомлен");
		Отказ = Истина;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Обработчик перехода назад (на предыдущую страницу) при уходе со страницы помощника "СтраницаДва".
//
// Параметры:
//   Отказ - Булево - флаг отказа от выполнения перехода назад;
//					если в обработчике поднять этот флаг, то переход на предыдущую страницу выполнен не будет.
//
&НаКлиенте
Функция Подключаемый_СтраницаДва_ПриПереходеНазад(Отказ)
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выполняется обработчик ПриПереходеНазад страницы № 2'"));
	
	Возврат Неопределено;
	
КонецФункции

// Обработчик выполняется при открытии страницы помощника "СтраницаДва".
//
// Параметры:
//
//  Отказ - Булево - флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад).
//
//  ПропуститьСтраницу - Булево - если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад).
//
//  ЭтоПереходДалее (только чтение) - Булево - флаг определяет направление перехода.
//			Истина - выполняется переход далее; Ложь - выполняется переход назад.
//
&НаКлиенте
Функция Подключаемый_СтраницаДва_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выполняется обработчик ПриОткрытии страницы № 2'"));
	
	Возврат Неопределено;
	
КонецФункции

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "СтраницаОжидания".
//
// Параметры:
//   Отказ - Булево - флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Функция Подключаемый_СтраницаОжидания_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ВыполнитьПродолжительноеДействиеНаСервере();
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ВыполнитьПродолжительноеДействиеНаСервере()
	
	// Имитация продолжительного действия (5 сек.).
	ДатаНачалаОперации = ТекущаяДатаСеанса();
	Пока ТекущаяДатаСеанса() - ДатаНачалаОперации < 5 Цикл
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Инициализация переходов помощника.

// Процедура определяет таблицу переходов по сценарию №1.
//
&НаКлиенте
Процедура ТаблицаПереходовПоСценарию1()
	
	ТаблицаПереходов.Очистить();
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 1;
	Переход.ИмяОсновнойСтраницы     = "СтраницаОдин";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииНачало";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииНачало";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 2;
	Переход.ИмяОсновнойСтраницы     = "СтраницаДва";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииПродолжение";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	Переход.ИмяОбработчикаПриОткрытии = "СтраницаДва_ПриОткрытии";
	Переход.ИмяОбработчикаПриПереходеДалее = "СтраницаДва_ПриПереходеДалее";
	Переход.ИмяОбработчикаПриПереходеНазад = "СтраницаДва_ПриПереходеНазад";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 3;
	Переход.ИмяОсновнойСтраницы     = "СтраницаТри";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииПродолжение";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 4;
	Переход.ИмяОсновнойСтраницы     = "СтраницаЧетыре";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииПродолжение";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 5;
	Переход.ИмяОсновнойСтраницы     = "СтраницаОжидания";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииОжидание";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	Переход.ДлительнаяОперация      = Истина;
	Переход.ИмяОбработчикаДлительнойОперации = "СтраницаОжидания_ОбработкаДлительнойОперации";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 6;
	Переход.ИмяОсновнойСтраницы     = "СтраницаПять";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииОкончание";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииОкончание";
	
КонецПроцедуры

#КонецОбласти
