/**
 * SnowRoller Stop
 */
#include <stddefine.mqh>
int   __INIT_FLAGS__[];
int __DEINIT_FLAGS__[];
#include <core/script.mqh>
#include <stdfunctions.mqh>
#include <stdlibs.mqh>

#include <app/SnowRoller/define.mqh>
#include <app/SnowRoller/functions.mqh>


/**
 * Main-Funktion
 *
 * @return int - Fehlerstatus
 */
int onStart() {
   string ids [];
   int  status[], sizeOfIds;


   // (1) Sequenzen des aktuellen Charts ermitteln
   if (FindChartSequences(ids, status)) {
      sizeOfIds = ArraySize(ids);


      // (2) f�r Command unzutreffende Sequenzen herausfiltern
      for (int i=sizeOfIds-1; i >= 0; i--) {
         switch (status[i]) {
          //case STATUS_UNDEFINED  :      //
            case STATUS_WAITING    :      // ok, solange es keine Testsequenz au�erhalb des Testers ist
            case STATUS_STARTING   :      // ok, solange es keine Testsequenz au�erhalb des Testers ist
            case STATUS_PROGRESSING:      // ok, solange es keine Testsequenz au�erhalb des Testers ist
          //case STATUS_STOPPING   :      //
          //case STATUS_STOPPED    :      //
               if (StringGetChar(ids[i], 0)!='T' || This.IsTesting())
                  continue;
            default:
               ArraySpliceStrings(ids, i, 1);
               ArraySpliceInts(status, i, 1);
               sizeOfIds--;
         }
      }


      // (3) Best�tigung einholen
      for (i=0; i < sizeOfIds; i++) {
         PlaySoundEx("Windows Notify.wav");
         int button = MessageBoxEx(__NAME__, ifString(IsDemoFix(), "", "- Real Account -\n\n") +"Do you really want to stop sequence "+ ids[i] +"?", MB_ICONQUESTION|ifInt(sizeOfIds==1, MB_OKCANCEL, MB_YESNOCANCEL));
         if (button == IDCANCEL)
            break;
         if (button == IDNO)
            continue;


         // (4) Command setzen
         string mutex = "mutex.ChartCommand";
         if (!AquireLock(mutex, true))
            return(ERR_RUNTIME_ERROR);

         string label = StringConcatenate("SnowRoller.", ids[i], ".command");    // TODO: Commands zu bereits existierenden Commands hinzuf�gen
         if (ObjectFind(label) != 0) {
            if (!ObjectCreate(label, OBJ_LABEL, 0, 0, 0))
               return(_int(catch("onStart(1)"), ReleaseLock(mutex)));
            ObjectSet(label, OBJPROP_TIMEFRAMES, OBJ_PERIODS_NONE);
         }
         ObjectSetText(label, "stop", 1);

         if (!ReleaseLock(mutex))
            return(ERR_RUNTIME_ERROR);


         // (5) Tick senden
         Chart.SendTick();
         return(catch("onStart(2)"));                                            // regular exit
      }
   }

   if (!last_error) {
      if (sizeOfIds == 0) {
         PlaySoundEx("Windows Chord.wav");
         MessageBoxEx(__NAME__, "No running sequence found.", MB_ICONEXCLAMATION|MB_OK);
      }
      catch("onStart(3)");
   }
   return(last_error);
}


/**
 * Unterdr�ckt unn�tze Compilerwarnungen.
 */
void DummyCalls() {
   ConfirmFirstTickTrade(NULL, NULL);
   CreateEventId();
   CreateSequenceId();
   IsSequenceStatus(NULL);
   IsStopTriggered(NULL, NULL);
   StatusToStr(NULL);
}
