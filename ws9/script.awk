BEGIN{
   FS=","
   OFS","
}
{
   if (NR == 1) {print}
   if (NR > 1 && $12 >= 6) {
      $12 = 1
      print
   }
   else if (NR > 1) {
      $12 = 0
      print
   }
}
