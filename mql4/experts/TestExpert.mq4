/**
 * TestExpert
 */
#include <stdlib.mqh>
#include <win32api.mqh>


datetime startTime;


/**
 * Initialisierung
 *
 * @return int - Fehlerstatus
 */
int init() {
   if (IsError(onInit(T_EXPERT)))
      return(last_error);

   debug("init()   hWndTester = 0x"+ IntToHexStr(GetTesterWindow()));

   return(catch("init()"));
}


/**
 * Deinitialisierung
 *
 * @return int - Fehlerstatus
 */
int deinit() {
   if (IsError(onDeinit()))
      return(last_error);
   return(catch("deinit()"));
}


/**
 * Main-Funktion
 *
 * @return int - Fehlerstatus
 */
int onTick() {
   if (IsError(prev_error))
      return(prev_error);

   return(NO_ERROR);



   if (startTime == 0)
      startTime = TimeCurrent();

   static bool done1, done2, done3, done4;
   static int ticket, ticket1, ticket2, partial;

   double execution[] = {NULL};

   if (!done1) {
      if (TimeCurrent() > startTime + 1*HOUR) {
         done1 = true;
         debug("onTick(1)          Ticket         Type   Lots   Symbol              OpenTime   OpenPrice             CloseTime   ClosePrice   Swap   Commission   Profit   MagicNumber   Comment");

         execution[EXEC_FLAGS] = NULL;
         ticket1 = OrderSendEx(Symbol(), OP_BUY, 0.7, NULL, NULL, NULL, NULL, "order comment", 111, NULL, Blue, execution);
         if (ticket1 == -1)
            return(SetLastError(stdlib_PeekLastError()));
         //debug("onTick(1) ->open        #"+ ticket1 +" = "+ ExecutionToStr(execution));

         if (!OrderSelectByTicket(ticket1, "onTick(1)"))
            return(last_error);
         //debug("onTick(1) open  "+ StringLeftPad("#"+ OrderTicket(), 9, " ") +"   "+ StringLeftPad(OperationTypeDescription(OrderType()), 10, " ") +"   "+ DoubleToStr(OrderLots(), 2) +"   "+ OrderSymbol() +"   "+ TimeToStr(OrderOpenTime(), TIME_FULL) +" "+ StringLeftPad(NumberToStr(OrderOpenPrice(), PriceFormat), 11, " ") +"   "+ ifString(OrderCloseTime()==0, "                   ", TimeToStr(OrderCloseTime(), TIME_FULL)) +" "+ StringLeftPad(NumberToStr(OrderClosePrice(), PriceFormat), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderSwap(), 2), 6, " ") +" "+ StringLeftPad(DoubleToStr(OrderCommission(), 2), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderProfit(), 2), 8, " ") +"   "+ StringLeftPad(OrderMagicNumber(), 11, " ") +"   "+ OrderComment());
      }
   }

   if (!done2) {
      if (TimeCurrent() > startTime + 2*HOURS) {
         done2 = true;

         execution[EXEC_FLAGS] = NULL;
         ticket2 = OrderSendEx(Symbol(), OP_SELL, 1, NULL, NULL, NULL, NULL, "order comment", 222, NULL, Red, execution);
         if (ticket2 == -1)
            return(SetLastError(stdlib_PeekLastError()));
         //debug("onTick(2) ->open        #"+ ticket2 +" = "+ ExecutionToStr(execution));

         if (!OrderSelectByTicket(ticket2, "onTick(2)"))
            return(last_error);
         //debug("onTick(2) open  "+ StringLeftPad("#"+ OrderTicket(), 9, " ") +"   "+ StringLeftPad(OperationTypeDescription(OrderType()), 10, " ") +"   "+ DoubleToStr(OrderLots(), 2) +"   "+ OrderSymbol() +"   "+ TimeToStr(OrderOpenTime(), TIME_FULL) +" "+ StringLeftPad(NumberToStr(OrderOpenPrice(), PriceFormat), 11, " ") +"   "+ ifString(OrderCloseTime()==0, "                   ", TimeToStr(OrderCloseTime(), TIME_FULL)) +" "+ StringLeftPad(NumberToStr(OrderClosePrice(), PriceFormat), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderSwap(), 2), 6, " ") +" "+ StringLeftPad(DoubleToStr(OrderCommission(), 2), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderProfit(), 2), 8, " ") +"   "+ StringLeftPad(OrderMagicNumber(), 11, " ") +"   "+ OrderComment());
      }
   }

   if (!done3) {
      if (TimeCurrent() > startTime + 3*HOURS) {
         done3 = true;

         if (!OrderSelectByTicket(ticket1, "onTick(3)"))
            return(last_error);
         debug("onTick(3)       "+ StringLeftPad("#"+ OrderTicket(), 9, " ") +"   "+ StringLeftPad(OperationTypeDescription(OrderType()), 10, " ") +"   "+ DoubleToStr(OrderLots(), 2) +"   "+ OrderSymbol() +"   "+ TimeToStr(OrderOpenTime(), TIME_FULL) +" "+ StringLeftPad(NumberToStr(OrderOpenPrice(), PriceFormat), 11, " ") +"   "+ ifString(OrderCloseTime()==0, "                   ", TimeToStr(OrderCloseTime(), TIME_FULL)) +" "+ StringLeftPad(NumberToStr(OrderClosePrice(), PriceFormat), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderSwap(), 2), 6, " ") +" "+ StringLeftPad(DoubleToStr(OrderCommission(), 2), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderProfit(), 2), 8, " ") +"   "+ StringLeftPad(OrderMagicNumber(), 11, " ") +"   "+ OrderComment());
         if (!OrderSelectByTicket(ticket2, "onTick(4)"))
            return(last_error);
         debug("onTick(3)       "+ StringLeftPad("#"+ OrderTicket(), 9, " ") +"   "+ StringLeftPad(OperationTypeDescription(OrderType()), 10, " ") +"   "+ DoubleToStr(OrderLots(), 2) +"   "+ OrderSymbol() +"   "+ TimeToStr(OrderOpenTime(), TIME_FULL) +" "+ StringLeftPad(NumberToStr(OrderOpenPrice(), PriceFormat), 11, " ") +"   "+ ifString(OrderCloseTime()==0, "                   ", TimeToStr(OrderCloseTime(), TIME_FULL)) +" "+ StringLeftPad(NumberToStr(OrderClosePrice(), PriceFormat), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderSwap(), 2), 6, " ") +" "+ StringLeftPad(DoubleToStr(OrderCommission(), 2), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderProfit(), 2), 8, " ") +"   "+ StringLeftPad(OrderMagicNumber(), 11, " ") +"   "+ OrderComment());

         int tickets[];
         ArrayPushInt(tickets, ticket1);
         ArrayPushInt(tickets, ticket2);

         execution[EXEC_FLAGS] = NULL;
         if (!OrderMultiClose(tickets, NULL, Orange, execution))
            return(SetLastError(stdlib_PeekLastError()));
         debug("onTick(3) ->OrderMultiClose = "+ ExecutionToStr(execution));

         int orders = OrdersHistoryTotal();
         for (int i=0; i < orders; i++) {
            OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
            debug("onTick(3)       "+ StringLeftPad("#"+ OrderTicket(), 9, " ") +"   "+ StringLeftPad(OperationTypeDescription(OrderType()), 10, " ") +"   "+ DoubleToStr(OrderLots(), 2) +"   "+ OrderSymbol() +"   "+ TimeToStr(OrderOpenTime(), TIME_FULL) +" "+ StringLeftPad(NumberToStr(OrderOpenPrice(), PriceFormat), 11, " ") +"   "+ ifString(OrderCloseTime()==0, "                   ", TimeToStr(OrderCloseTime(), TIME_FULL)) +" "+ StringLeftPad(NumberToStr(OrderClosePrice(), PriceFormat), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderSwap(), 2), 6, " ") +" "+ StringLeftPad(DoubleToStr(OrderCommission(), 2), 12, " ") +" "+ StringLeftPad(DoubleToStr(OrderProfit(), 2), 8, " ") +"   "+ StringLeftPad(OrderMagicNumber(), 11, " ") +"   "+ OrderComment());
         }
      }
   }

   return(catch("onTick(7)"));
}
