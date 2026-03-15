(******************************************************************************
 * FB_StickManage
 * ---------------------------------------------------------------------------
 * Description : Manages a VMB Stick valve (VMB_XV) for a generic Tool (N).
 *               Reusable for TOOL1, TOOL2, ... TOOLN.
 *               Based on ladder logic "Manage VMB Stick #1".
 *
 * Includes    :
 *   - "Check if need to monitor Fill too long"
 *       FR2LONG_EN is computed internally:
 *       (DR_F2LONG_SP > 0) AND DELIVERY_MODE AND VMB_MODE_START
 *
 *   - "Convert and load timers value"
 *       VMB_FR2LONG_LIM := DINT_TO_TIME(DR_F2LONG_SP * 6000)
 *       (setpoint in 0.1-min units -> milliseconds -> TIME)
 *
 *   - "Fill request too long" alarm (TON-based)
 *       Timer fires -> FR2L_T_ALM (coil) + FR2L_OUT (set/latch coil)
 *
 *   - "Reset Fill too long"
 *       VMB_HMI_RESET_ALM -> FR2L_OUT (reset coil)
 *
 * Compatible  : Automation Builder 2.8 (ABB) / CODESYS V3 based
 *
 * Author      : Auto-generated from ladder screenshots
 * Date        : 2026-02-22
 ******************************************************************************)

FUNCTION_BLOCK FB_StickManage

VAR_INPUT
    (* ---------- Inputs from Tool N ------------------------------------ *)
    VMB_FR_TOOL       : BOOL;   (* VMB Flow Request from Tool N            - NC contact (active LOW = allow) *)

    (* ---------- Fill-Request-Too-Long Setpoint ------------------------ *)
    DR_F2LONG_SP      : DINT;   (* Fill-too-long setpoint from HMI/recipe  - units: 0.1 min (x 6000 -> ms)  *)
                                (* Set to 0 to disable monitoring          *)

    (* ---------- HMI Alarm Reset --------------------------------------- *)
    VMB_HMI_RESET_ALM : BOOL;   (* HMI Alarm Reset pushbutton             - NO contact, resets FR2L_OUT    *)

    (* ---------- System / Common Inputs -------------------------------- *)
    DELIVERY_MODE     : BOOL;   (* Delivery Mode active                    - NO contact *)
    VMB_MODE_MANUAL   : BOOL;   (* VMB Manual Mode selector                - used NC in auto, NO in manual *)
    VMB_CDDU_READY    : BOOL;   (* VMB CDDU Ready signal                   - NO contact *)
    VMB_MODE_START    : BOOL;   (* VMB Mode Start command                  - NO contact *)
    VMB_SHUT_ALM      : BOOL;   (* VMB Shutdown Alarm                      - NC contact (active LOW = no alarm) *)

    (* ---------- Manual Override --------------------------------------- *)
    FORCE_VMB_XV      : BOOL;   (* Force VMB Valve in Manual Mode          - NO contact *)
END_VAR

VAR_OUTPUT
    VMB_XV            : BOOL;   (* VMB Valve output command (to solenoid valve) *)
    FR2L_T_ALM        : BOOL;   (* Flow-Request-Too-Long Alarm             - TRUE when timer expires *)
    FR2L_OUT          : BOOL;   (* Latched alarm output (set coil)         - remains TRUE until HMI reset *)
    FR2LONG_EN        : BOOL;   (* Fill-too-long monitoring enabled flag    - for HMI / diagnostics *)
    VMB_FR2LONG_LIM   : TIME;   (* Computed timer preset                   - for HMI / diagnostics *)
END_VAR

VAR
    xAutoCondition    : BOOL;   (* Intermediate: automatic run condition    *)
    xManualOverride   : BOOL;   (* Intermediate: manual override condition  *)

    (* --- Fill-request-too-long timer --- *)
    FR2L_T_TMR        : TON;    (* On-delay timer - "fill request too long" *)
    xTimerIn          : BOOL;   (* Composed IN signal for the TON block     *)

    (* --- Setpoint evaluation --- *)
    xSpGreaterZero    : BOOL;   (* TRUE when DR_F2LONG_SP > 0              *)
END_VAR

(* ====================================================================== *)
(* RUNG - Reset Fill too long                                             *)
(* ---------------------------------------------------------------------- *)
(* VMB_HMI_RESET_ALM (NO) --------------------------------- FR2L_OUT (R)  *)
(* The HMI reset button unlatches the latched alarm output.               *)
(* Placed FIRST so a reset in the same scan clears before re-evaluation.  *)
(* ====================================================================== *)

IF VMB_HMI_RESET_ALM THEN
    FR2L_OUT := FALSE;
END_IF;

(* ====================================================================== *)
(* RUNG - Check if need to monitor Fill too long                          *)
(* ---------------------------------------------------------------------- *)
(*                                        +-----+                         *)
(*                            +---GT---+  | AND |                         *)
(*              DR_F2LONG_SP -|        |--|     |                         *)
(*                         0 -|        |  |     |-- FR2LONG_EN            *)
(*                            +--------+  |     |                         *)
(*               DELIVERY_MODE -----------|     |                         *)
(*              VMB_MODE_START -----------|     |                         *)
(*                                        +-----+                         *)
(* Monitoring is enabled only when:                                       *)
(*   - The setpoint is configured (> 0)                                   *)
(*   - The system is in delivery mode                                     *)
(*   - The start command has been given                                   *)
(* ====================================================================== *)

xSpGreaterZero := (DR_F2LONG_SP > 0);

FR2LONG_EN := xSpGreaterZero AND DELIVERY_MODE AND VMB_MODE_START;

(* ====================================================================== *)
(* RUNG - Convert and load timers value                                   *)
(* ---------------------------------------------------------------------- *)
(* VMB_FR2LONG_LIM := DINT_TO_TIME( DR_F2LONG_SP * 6000 )                 *)
(*                                                                        *)
(* DR_F2LONG_SP is in 0.1-minute increments (6 s each).                   *)
(* Multiply by 6000 -> value in milliseconds.                             *)
(* DINT_TO_TIME interprets the DINT as milliseconds -> TIME.              *)
(* ====================================================================== *)

VMB_FR2LONG_LIM := DINT_TO_TIME(DR_F2LONG_SP * 6000);

(* ====================================================================== *)
(* RUNG - Fill Request Too Long  (Tool 1A)                                *)
(* ---------------------------------------------------------------------- *)
(* VMB_FR_TOOL (NC) -- FR2LONG_EN (NO) --|TON|-- FR2L_T1_ALM ( )          *)
(*                                        |    |-- FR2L_OUT    (S)        *)
(*             VMB_FR2LONG_LIM -----------|PT  |                          *)
(*                                                                        *)
(* When the tool is requesting flow AND monitoring is enabled, the timer  *)
(* runs.  If it exceeds the preset, the alarm fires and FR2L_OUT latches. *)
(* ====================================================================== *)

xTimerIn := VMB_FR_TOOL AND FR2LONG_EN;

FR2L_T_TMR(
    IN := xTimerIn,
    PT := VMB_FR2LONG_LIM
);

(* Normal coil - mirrors timer Q output *)
FR2L_T_ALM := FR2L_T_TMR.Q;

(* Set (latch) coil - once TRUE it stays TRUE until HMI reset above *)
IF FR2L_T_TMR.Q THEN
    FR2L_OUT := TRUE;
END_IF;

(* ====================================================================== *)
(* RUNG - Automatic Mode Logic                                            *)
(* ---------------------------------------------------------------------- *)
(* All conditions must be met simultaneously:                             *)
(*   - No flow request alarm from tool  (NC -> NOT)                       *)
(*   - No flow-to-long alarm            (NC -> NOT)                       *)
(*   - Delivery mode is active          (NO)                              *)
(*   - NOT in manual mode               (NC -> NOT)                       *)
(*   - CDDU is ready                    (NO)                              *)
(*   - Start command is given           (NO)                              *)
(*   - No shutdown alarm                (NC -> NOT)                       *)
(* ====================================================================== *)

xAutoCondition :=      VMB_FR_TOOL
                  AND NOT FR2L_T_ALM
                  AND DELIVERY_MODE
                  AND NOT VMB_MODE_MANUAL
                  AND VMB_CDDU_READY
                  AND VMB_MODE_START
                  AND NOT VMB_SHUT_ALM;

(* ====================================================================== *)
(* RUNG - Manual Override Logic                                           *)
(* ---------------------------------------------------------------------- *)
(* Operator can force the valve open when in manual mode                  *)
(* ====================================================================== *)

xManualOverride :=    VMB_MODE_MANUAL
                  AND FORCE_VMB_XV;

(* ====================================================================== *)
(* OUTPUT - OR of both rungs                                              *)
(* ====================================================================== *)

VMB_XV := xAutoCondition OR xManualOverride;

END_FUNCTION_BLOCK
