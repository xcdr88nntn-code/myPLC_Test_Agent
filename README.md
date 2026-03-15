# myPLC_Test_Agent

**AI-assisted PLC Logic Review & Test Documentation Agent**  
**ИИ-агент для проверки логики ПЛК и создания документации по тестированию**

---

## Overview / Обзор

`myPLC_Test_Agent` is a structured prompt-based AI agent designed to assist automation engineers with:

- PLC logic review and analysis
- Factory Acceptance Test (FAT) and Site Acceptance Test (SAT) procedure generation
- Test case and checklist creation
- Findings and recommendations registers
- Traceability matrices
- Flow chart narratives

The agent accepts a structured input form (see [`plc_test_agent_prompt.md`](plc_test_agent_prompt.md)) and produces engineering-grade output documents in English, Russian, or both.

`myPLC_Test_Agent` — это структурированный AI-агент на основе промптов, предназначенный для помощи инженерам по автоматизации в следующих задачах:

- Проверка и анализ логики ПЛК
- Создание процедур FAT (Factory Acceptance Test) и SAT (Site Acceptance Test)
- Разработка тест-кейсов и чек-листов
- Ведение реестров замечаний и рекомендаций
- Матрицы прослеживаемости
- Описание блок-схем

Агент принимает структурированную форму ввода (см. [`plc_test_agent_prompt.md`](plc_test_agent_prompt.md)) и формирует инженерные документы на английском, русском языке или на обоих.

---

## Repository Structure / Структура репозитория

```
myPLC_Test_Agent/
├── README.md                      # This file / Этот файл
├── plc_test_agent_prompt.md       # Main input template / Основной шаблон ввода
├── system_prompt.md               # Agent system prompt / Системный промпт агента
└── examples/
    └── example_pump_station.md    # Filled example / Заполненный пример
```

---

## Quick Start / Быстрый старт

1. **Copy** [`plc_test_agent_prompt.md`](plc_test_agent_prompt.md) — the input template.  
   **Скопируйте** [`plc_test_agent_prompt.md`](plc_test_agent_prompt.md) — шаблон ввода.

2. **Fill in** all fields relevant to your project.  
   **Заполните** все поля, относящиеся к вашему проекту.

3. **Paste** the completed form into an AI chat (e.g., ChatGPT, Claude, Gemini, Copilot) along with the [system prompt](system_prompt.md).  
   **Вставьте** заполненную форму в AI-чат (напр., ChatGPT, Claude, Gemini, Copilot) вместе с [системным промптом](system_prompt.md).

4. **Receive** structured engineering documentation.  
   **Получите** структурированную инженерную документацию.

See [`examples/example_pump_station.md`](examples/example_pump_station.md) for a fully worked example.  
Полный заполненный пример — в [`examples/example_pump_station.md`](examples/example_pump_station.md).

---

## Supported PLC Platforms / Поддерживаемые платформы ПЛК

| Platform | Engineering Environment | Languages |
|---|---|---|
| Siemens S7 / S7-1500 | TIA Portal | LAD, FBD, SCL/ST, SFC |
| Allen-Bradley / Rockwell | Studio 5000 | LAD, FBD, ST, SFC |
| CODESYS-based | CODESYS | ST, LAD, FBD, SFC |
| Beckhoff | TwinCAT | ST, LAD, FBD, SFC |
| Schneider Electric | EcoStruxure / Unity Pro | ST, LAD, FBD, SFC |
| Omron | Sysmac Studio | ST, LAD, FBD, SFC |
| Mitsubishi | GX Works | LAD, ST, FBD, SFC |
| Other | Any | Any IEC 61131-3 |

---

## Supported Output Types / Поддерживаемые типы выходных документов

| Document | Description |
|---|---|
| Executive Summary | High-level project overview and findings |
| Logic Review | Detailed analysis of PLC code and logic |
| Findings Register | Numbered list of all identified issues |
| Recommendations Register | Actionable improvement suggestions |
| Master Test Plan | Overall test strategy and scope |
| FAT Procedure | Step-by-step Factory Acceptance Test |
| SAT Procedure | Step-by-step Site Acceptance Test |
| Detailed Test Cases | Input/action/expected result per scenario |
| Detailed Checklists | Pass/fail verification checklists |
| Traceability Matrix | Requirements ↔ Test case mapping |
| Punch List | Open items and sign-off tracker |
| Flow Charts | Process and logic flow descriptions |
| Missing Documents List | Gap analysis of project documentation |

---

## Standards Reference / Нормативные ссылки

- **IEC 61131-3** — Programming languages for PLCs
- **IEC 62443** — Industrial cybersecurity (where applicable)
- **ISA-88** — Batch control (for batch/CIP applications)
- **ISA-18.2** — Alarm management
- **GAMP 5** — Good automated manufacturing practice (for pharma/life sciences)

---

## License / Лицензия

MIT License — free to use, modify, and distribute.
