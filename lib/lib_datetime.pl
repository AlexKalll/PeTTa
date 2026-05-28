% Small Date & Time helpers for PeTTa.

now(TimeStamp) :-
    get_time(TimeStamp).

to_atom(Value, Atom) :-
    atom(Value), !,
    Atom = Value.
to_atom(Value, Atom) :-
    string(Value), !,
    atom_string(Atom, Value).
to_atom(Value, Atom) :-
    term_to_atom(Value, Atom).

format_date(TimeStamp, Format, Formatted) :-
    to_atom(Format, FormatAtom),
    stamp_date_time(TimeStamp, DateTime, 'UTC'),
    format_time(atom(Formatted), FormatAtom, DateTime).

date_diff(From, To, DiffSeconds) :-
    DiffSeconds is To - From.

date_add(TimeStamp, Seconds, NewTimeStamp) :-
    NewTimeStamp is TimeStamp + Seconds.

day_of_week(TimeStamp, DayName) :-
    stamp_date_time(TimeStamp, DateTime, 'UTC'),
    format_time(atom(DayName), '%A', DateTime).
    
