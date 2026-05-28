!(import! &self ../lib/lib_datetime)

;get current timestamp
!(let $now-ts (now) ($now-ts))

;format the current date
!(let* (($now-ts (now))
              ($formatted (format-date $now-ts "%Y-%m-%d %H:%M:%S")))
          ($formatted))
;increase date by adding seconds
!(let* (($ts (now))
              ($plus-3600 (date-add $ts 3600))
              ($formatted (format-date $plus-3600 "%Y-%m-%d %H:%M:%S")))
          ($formatted))

; get day of the week
!(let* (($christmas-ts 1766188800)
              ($dow (day-of-week $christmas-ts)))
          ($dow))

; diff between two timestamps
!(let* (($ts1 1735689600)
              ($ts2 1736294400)
              ($diff (date-diff $ts1 $ts2)))
          ($diff))
;extract time only
!(let* (($ts 1735725045)
              ($time-only (format-date $ts "%H:%M:%S")))
          ($time-only))
