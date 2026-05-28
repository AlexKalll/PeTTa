; Tiny Date & Time wrapper for PeTTa.
!(import! &self (library lib_import))
!(import_prolog_functions_from_file (library lib_datetime.pl) (now format_date date_diff date_add day_of_week))

(= (format-date $timestamp $format)
   (format_date $timestamp $format))

(= (date-diff $from $to)
   (date_diff $from $to))

(= (date-add $timestamp $seconds)
   (date_add $timestamp $seconds))

(= (day-of-week $timestamp)
   (day_of_week $timestamp))
