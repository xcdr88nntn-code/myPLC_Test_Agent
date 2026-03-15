# myPLC_Test_Agent — Input Form / Форма ввода

> **Instructions / Инструкция:**  
> Fill in every field below. Replace all placeholder text in square brackets `[...]` with your actual project data.  
> Paste the completed form along with [`system_prompt.md`](system_prompt.md) into your AI assistant.  
>  
> Заполните каждое поле ниже. Замените весь текст-заполнитель в квадратных скобках `[...]` реальными данными проекта.  
> Вставьте заполненную форму вместе с [`system_prompt.md`](system_prompt.md) в вашего AI-ассистента.

---

## 1. Project Identification / Идентификация проекта

**Project / Проект:**  
[Project name / Название проекта]

**Customer / Site / Заказчик / объект:**  
[Insert customer name and/or site location / Укажите наименование заказчика и/или объект]

---

## 2. System & Platform / Система и платформа

**System Type / Тип системы:**  
<!-- Select one or more / Выберите одно или несколько -->
- [ ] Pump station / Насосная станция
- [ ] Conveyor / Конвейер
- [ ] HVAC / Вентиляция и кондиционирование
- [ ] CIP (Clean-In-Place)
- [ ] Compressor / Компрессор
- [ ] Boiler / Котёл
- [ ] Water treatment / Водоподготовка
- [ ] Packaging line / Линия упаковки
- [ ] Other / Другое: [specify / укажите]

**PLC Platform / Платформа ПЛК:**  
<!-- Select one / Выберите одно -->
- [ ] Siemens S7 / S7-1500 / S7-300
- [ ] Allen-Bradley / Rockwell (ControlLogix / CompactLogix)
- [ ] CODESYS-based (generic)
- [ ] Beckhoff
- [ ] Schneider Electric (Modicon)
- [ ] Omron
- [ ] Mitsubishi
- [ ] Other / Другое: [specify / укажите]

**Engineering Environment / Среда разработки:**  
<!-- Select one / Выберите одно -->
- [ ] TIA Portal
- [ ] CODESYS
- [ ] Studio 5000 (RSLogix 5000)
- [ ] TwinCAT
- [ ] EcoStruxure / Unity Pro
- [ ] Sysmac Studio
- [ ] GX Works
- [ ] Other / Другое: [specify / укажите]

**Programming Language / Язык программирования:**  
<!-- Select all that apply / Выберите все подходящие -->
- [ ] ST (Structured Text / Структурированный текст)
- [ ] LAD (Ladder Diagram / Лестничная диаграмма)
- [ ] FBD (Function Block Diagram / Диаграмма функциональных блоков)
- [ ] SFC (Sequential Function Chart / Последовательная функциональная схема)
- [ ] Mixed / Смешанный

**Software / Hardware Version / Версия ПО / оборудования:**  
[e.g., TIA Portal V18, CPU 1515-2 PN FW 3.1 / напр., TIA Portal V18, CPU 1515-2 PN FW 3.1]

---

## 3. Goals & Testing Scope / Цели и область тестирования

**Goal / Цель:**  
<!-- Select all that apply / Выберите все подходящие -->
- [ ] Logic review / Проверка логики
- [ ] FAT (Factory Acceptance Test)
- [ ] SAT (Site Acceptance Test)
- [ ] Test cases / Тест-кейсы
- [ ] Checklist / Чек-лист
- [ ] Full documentation package / Полный пакет документации
- [ ] Flow charts / Блок-схемы

**Testing Level / Уровень тестирования:**  
<!-- Select all that apply / Выберите все подходящие -->
- [ ] FAT
- [ ] SAT
- [ ] SIT (System Integration Test)
- [ ] Commissioning / Пуско-наладка
- [ ] Regression / Регрессионное тестирование
- [ ] Full lifecycle / Полный жизненный цикл

---

## 4. Process Description / Описание процесса

**Process Description / Описание процесса:**  
[Describe the process in detail. Include sequence of operations, control objectives, safety requirements, and any special conditions. / Опишите процесс подробно. Включите последовательность операций, цели управления, требования безопасности и особые условия.]

---

## 5. Main Equipment / Основное оборудование

**Main Equipment / Основное оборудование:**  
- [Equipment 1 — e.g., Pump P-101, 11 kW, 400V / Насос P-101, 11 кВт, 400В]
- [Equipment 2 — e.g., Motorized valve MV-201 / Моторизованный клапан MV-201]
- [Equipment 3 — e.g., Level transmitter LT-301 / Датчик уровня LT-301]
- [Add more as needed / Добавьте при необходимости]

---

## 6. Operating Modes / Режимы работы

**Operating Modes / Режимы работы:**  
<!-- Mark all modes present in the system / Отметьте все режимы, присутствующие в системе -->
- [ ] Auto / Авто
- [ ] Manual / Ручной
- [ ] Local / Местный
- [ ] Remote / Дистанционный
- [ ] Maintenance / Техническое обслуживание
- [ ] Emergency / Аварийный
- [ ] Other / Другое: [specify / укажите]

---

## 7. Available Documents / Доступные документы

**Available Documents / Доступные документы:**  
<!-- Check all that you are providing or that exist / Отметьте все, что вы предоставляете или что существует -->
- [ ] PLC Code / Код ПЛК
- [ ] Functional Description / Функциональное описание
- [ ] I/O List / Список ввода-вывода
- [ ] Tag List / Список тегов
- [ ] Alarm List / Список аварий
- [ ] Interlock List / Список блокировок
- [ ] Permissive List / Список разрешений
- [ ] Cause & Effect Matrix / Матрица причин и следствий
- [ ] P&ID (Piping & Instrumentation Diagram)
- [ ] HMI Description / Описание HMI
- [ ] SCADA Description / Описание SCADA
- [ ] Sequence Description / Описание последовательности
- [ ] Operating Philosophy / Концепция управления
- [ ] Previous Findings / Предыдущие замечания

---

## 8. PLC Logic / Логика ПЛК

**PLC Logic / Логика ПЛК:**  

```
[Paste PLC code, pseudocode, or a narrative description of the logic here.
 You may also describe it in plain text if code is not available.

 Вставьте код ПЛК, псевдокод или текстовое описание логики здесь.
 Можно описать словами, если код недоступен.]
```

---

## 9. Constraints / Ограничения

**Constraints / Ограничения:**  
[List any constraints that affect the review or testing, e.g.:
- Offline review only — no test bench available
- Partial simulation only (digital I/O only, no analog)
- Safety loop is external (SIL-rated, reviewed separately)
- Access to PLC is read-only
- Customer NDA — no external sharing

Укажите ограничения, влияющие на проверку или тестирование, напр.:
- Только офлайн-проверка — стенд отсутствует
- Только частичная симуляция (только дискретные входы/выходы, без аналоговых)
- Контур безопасности внешний (SIL, проверяется отдельно)
- Доступ к ПЛК только на чтение
- NDA заказчика — внешний обмен запрещён]

---

## 10. Required Output / Требуемый результат

**Required Output / Что нужно на выходе:**  
<!-- Check all outputs you need / Отметьте все необходимые выходные документы -->
- [ ] Executive Summary / Исполнительное резюме
- [ ] Logic Review / Обзор логики
- [ ] Findings Register / Реестр замечаний
- [ ] Recommendations Register / Реестр рекомендаций
- [ ] Master Test Plan / Мастер-план тестирования
- [ ] FAT Procedure / Процедура FAT
- [ ] SAT Procedure / Процедура SAT
- [ ] Detailed Test Cases / Подробные тест-кейсы
- [ ] Detailed Checklists / Подробные чек-листы
- [ ] Traceability Matrix / Матрица прослеживаемости
- [ ] Punch List / Список открытых пунктов
- [ ] Flow Charts / Блок-схемы
- [ ] Missing Documents List / Список недостающих документов

---

## 11. Output Language / Язык результата

**Output Language / Язык результата:**  
<!-- Select one / Выберите одно -->
- [ ] EN (English only)
- [ ] RU (Russian only / Только русский)
- [ ] RU+EN (Bilingual / Двуязычный)

---

## 12. Special Requirements / Дополнительные требования

**Special Requirements / Дополнительные требования:**  
[Add any special formatting, terminology, or delivery requirements, e.g.:
- Use IEC 61131-3 standard terminology throughout
- Split critical tests from optional/nice-to-have tests
- Customer-ready format (no internal comments)
- Follow ISA-88 state model terminology
- Number all test cases with prefix TC-XXX
- Number all findings with prefix F-XXX

Укажите специальные требования к оформлению, терминологии или поставке, напр.:
- Использовать терминологию стандарта IEC 61131-3
- Разделить критические и необязательные тесты
- Формат для заказчика (без внутренних комментариев)
- Использовать терминологию модели состояний ISA-88
- Нумеровать все тест-кейсы с префиксом TC-XXX
- Нумеровать все замечания с префиксом F-XXX]
