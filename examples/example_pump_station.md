# myPLC_Test_Agent — Example: Pump Station FAT  
# myPLC_Test_Agent — Пример: Насосная станция FAT

> **This is a fully worked example showing how to fill in [`plc_test_agent_prompt.md`](../plc_test_agent_prompt.md).**  
> **Это полностью заполненный пример использования [`plc_test_agent_prompt.md`](../plc_test_agent_prompt.md).**

---

## 1. Project Identification / Идентификация проекта

**Project / Проект:**  
Booster Pump Station Upgrade — Phase 2

**Customer / Site / Заказчик / объект:**  
AquaCity Municipal Water Authority / WTP-North Plant

---

## 2. System & Platform / Система и платформа

**System Type / Тип системы:**  
- [x] Pump station / Насосная станция

**PLC Platform / Платформа ПЛК:**  
- [x] Siemens S7 / S7-1500 / S7-300

**Engineering Environment / Среда разработки:**  
- [x] TIA Portal

**Programming Language / Язык программирования:**  
- [x] LAD (Ladder Diagram)
- [x] ST (Structured Text)

**Software / Hardware Version / Версия ПО / оборудования:**  
TIA Portal V18 (Update 3), CPU 1515-2 PN, FW V3.1; STEP 7 Safety V18 (not in scope — safety PLC reviewed separately)

---

## 3. Goals & Testing Scope / Цели и область тестирования

**Goal / Цель:**  
- [x] Logic review / Проверка логики
- [x] FAT (Factory Acceptance Test)
- [x] Test cases / Тест-кейсы
- [x] Checklist / Чек-лист

**Testing Level / Уровень тестирования:**  
- [x] FAT
- [x] SAT

---

## 4. Process Description / Описание процесса

**Process Description / Описание процесса:**  

The booster pump station supplies treated water from the ground-level storage tank (TK-101) to the elevated distribution network. The station consists of three identical centrifugal pumps (P-101, P-102, P-103) connected in parallel. Pumps are driven by variable frequency drives (VFDs).

Control objectives:
- Maintain network pressure at setpoint (SP = 6.5 bar, tolerance ±0.2 bar).
- Lead/lag/standby pump rotation based on runtime hours (rotate every 168 hours or on manual command).
- Automatically start lag pump if pressure drops below 6.0 bar for > 5 seconds after lead pump is running.
- Automatically stop lag pump if pressure rises above 6.8 bar for > 10 seconds.
- Shut down all pumps and raise alarm if low-low tank level (LT-101 < 20%) is detected.
- Raise alarm (non-trip) on high network pressure (> 7.2 bar) for > 30 seconds.
- Pump fault causes automatic changeover to the next available pump within 3 seconds.

Safety interlocks (hardwired, outside PLC scope — reviewed separately by safety engineer):
- Emergency stop buttons at MCC and local panel.
- Motor thermal overload relays (hardwired trip).

---

## 5. Main Equipment / Основное оборудование

**Main Equipment / Основное оборудование:**  
- Pump P-101: Grundfos CR45-7, 22 kW, 400V/50Hz, driven by VFD VFD-101 (Siemens SINAMICS G120)
- Pump P-102: Grundfos CR45-7, 22 kW, 400V/50Hz, driven by VFD VFD-102 (Siemens SINAMICS G120)
- Pump P-103: Grundfos CR45-7, 22 kW, 400V/50Hz, driven by VFD VFD-103 (Siemens SINAMICS G120)
- Pressure transmitter PT-201: Endress+Hauser Cerabar M, 0–16 bar, 4–20 mA, 2-wire
- Level transmitter LT-101: VEGA VEGAFLEX 81, 4–20 mA, installed on TK-101
- Motorized isolation valve MV-101 (inlet to pump header): Auma SAR 07.2, 400V, open/close
- Non-return valves (check valves) NRV-101/102/103: hardwired mechanical, no feedback

---

## 6. Operating Modes / Режимы работы

**Operating Modes / Режимы работы:**  
- [x] Auto / Авто — PLC controls pump starts/stops based on pressure and level
- [x] Manual / Ручной — Operator can start/stop individual pumps from SCADA/HMI
- [x] Local / Местный — Individual pump start/stop from local panel pushbutton (bypasses PLC speed control; VFD at 50 Hz fixed)
- [x] Maintenance / Техническое обслуживание — Pump can be isolated from auto selection; MCC is locked out

---

## 7. Available Documents / Доступные документы

**Available Documents / Доступные документы:**  
- [x] PLC Code (TIA Portal V18 project export — LAD and ST blocks)
- [x] Functional Description (Rev 3, dated 2025-11-10)
- [x] I/O List (Rev 2, dated 2025-10-22)
- [x] Tag List (extracted from TIA Portal)
- [x] Alarm List (Rev 1, dated 2025-09-15)
- [ ] Interlock List — **NOT AVAILABLE** (to be prepared by contractor)
- [x] Permissive List (included in Functional Description Appendix B)
- [ ] Cause & Effect Matrix — **NOT AVAILABLE**
- [x] P&ID (Rev 4, dated 2025-11-01)
- [x] HMI Description (Rev 2 — SCADA Ignition project)
- [ ] SCADA Description — **PARTIAL** (screens described, no tag mapping)
- [ ] Sequence Description — **NOT AVAILABLE**
- [ ] Operating Philosophy — **NOT AVAILABLE**
- [ ] Previous Findings — N/A (new system)

---

## 8. PLC Logic / Логика ПЛК

**PLC Logic / Логика ПЛК:**  

```pascal
// FC_PumpControl - Pump Selection and Pressure Control
// Executed in OB1 (cyclic, 100ms cycle time)

// --- INPUTS ---
// PT201_Value    : REAL   // Network pressure (bar), scaled from AI card
// LT101_Value    : REAL   // Tank level (%), scaled from AI card
// P101_Fault     : BOOL   // VFD fault signal (TRUE = fault)
// P102_Fault     : BOOL
// P103_Fault     : BOOL
// P101_Running   : BOOL   // VFD running feedback
// P102_Running   : BOOL
// P103_Running   : BOOL
// Mode_Auto      : BOOL   // Mode selector: Auto selected
// P101_MaintMode : BOOL   // Maintenance mode active for P101
// P102_MaintMode : BOOL
// P103_MaintMode : BOOL

// --- OUTPUTS ---
// P101_StartCmd  : BOOL
// P102_StartCmd  : BOOL
// P103_StartCmd  : BOOL
// Alarm_LowLow   : BOOL
// Alarm_HighPres  : BOOL

// --- STATIC VARIABLES ---
// LeadPump       : INT    // 1, 2, or 3
// LagActive      : BOOL
// LagTON         : TON    // Lag start timer
// LagStopTON     : TON    // Lag stop timer
// HighPresTON    : TON    // High pressure alarm timer

PROGRAM FC_PumpControl;

// Low-Low Level Shutdown
IF LT101_Value < 20.0 THEN
    P101_StartCmd := FALSE;
    P102_StartCmd := FALSE;
    P103_StartCmd := FALSE;
    Alarm_LowLow := TRUE;
    RETURN;
END_IF;
Alarm_LowLow := FALSE;

// Auto Mode Logic
IF Mode_Auto THEN

    // Lead pump start: pressure below setpoint (6.5 bar)
    IF PT201_Value < 6.5 AND NOT P101_MaintMode THEN
        P101_StartCmd := (LeadPump = 1);
        P102_StartCmd := (LeadPump = 2);
        P103_StartCmd := (LeadPump = 3);
    END_IF;

    // Lag pump start: pressure < 6.0 bar for > 5s while lead is running
    LagTON(IN := (PT201_Value < 6.0) AND
                 ((LeadPump = 1 AND P101_Running) OR
                  (LeadPump = 2 AND P102_Running) OR
                  (LeadPump = 3 AND P103_Running)),
           PT := T#5S);
    IF LagTON.Q AND NOT LagActive THEN
        LagActive := TRUE;
        // Start the next available pump (simplified - actual rotation not shown)
    END_IF;

    // Lag pump stop: pressure > 6.8 bar for > 10s
    LagStopTON(IN := PT201_Value > 6.8 AND LagActive, PT := T#10S);
    IF LagStopTON.Q THEN
        LagActive := FALSE;
    END_IF;

    // High pressure alarm (non-trip): pressure > 7.2 bar for > 30s
    HighPresTON(IN := PT201_Value > 7.2, PT := T#30S);
    Alarm_HighPres := HighPresTON.Q;

    // Pump fault auto-changeover (simplified)
    IF LeadPump = 1 AND P101_Fault THEN
        P101_StartCmd := FALSE;
        LeadPump := 2;
    ELSIF LeadPump = 2 AND P102_Fault THEN
        P102_StartCmd := FALSE;
        LeadPump := 3;
    ELSIF LeadPump = 3 AND P103_Fault THEN
        P103_StartCmd := FALSE;
        LeadPump := 1;
    END_IF;

END_IF;
```

---

## 9. Constraints / Ограничения

**Constraints / Ограничения:**  
- Offline review only — no test bench available for FAT preparation; FAT will be performed on actual hardware at the factory.
- Safety PLC (emergency stop circuit) is out of scope — reviewed by a certified safety engineer separately.
- VFD speed control logic (ramp-up/down profiles) is in the VFD parameterisation, not in PLC code; this is outside scope.
- SCADA/HMI logic is partially available — HMI screen descriptions only, no tag binding file.
- Customer NDA in place — no sharing of code outside review team.

---

## 10. Required Output / Требуемый результат

**Required Output / Что нужно на выходе:**  
- [x] Executive Summary / Исполнительное резюме
- [x] Logic Review / Обзор логики
- [x] Findings Register / Реестр замечаний
- [x] Recommendations Register / Реестр рекомендаций
- [x] FAT Procedure / Процедура FAT
- [x] Detailed Test Cases / Подробные тест-кейсы
- [x] Detailed Checklists / Подробные чек-листы
- [x] Missing Documents List / Список недостающих документов

---

## 11. Output Language / Язык результата

**Output Language / Язык результата:**  
- [x] EN (English only)

---

## 12. Special Requirements / Дополнительные требования

**Special Requirements / Дополнительные требования:**  
- Use IEC 61131-3 standard terminology throughout.
- Number all findings with prefix F-XXX and all test cases with prefix TC-XXX.
- Split critical tests from optional tests in the FAT procedure.
- Customer-ready format (no internal comments or draft notes in the output).
- All timers must be explicitly tested in test cases (LagTON 5s, LagStopTON 10s, HighPresTON 30s, fault changeover 3s).
