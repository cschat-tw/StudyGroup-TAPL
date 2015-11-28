// eval1() is pretty much okay until eval() came along, 
// borrow checker stopped me from finishing it.
#![feature(box_syntax, box_patterns)]

#[derive(Debug)]
enum Term {
    True,
    False,
    If(Box<Term>, Box<Term>, Box<Term>),
    Zero,
    Succ(Box<Term>),
    Pred(Box<Term>),
    IsZero(Box<Term>)
}

fn eval1(t: Term) -> Term {
    match t {
        Term::True => Term::True,
        Term::False => Term::False,
        Term::If(box a, box b, box c) => 
            match a {
                Term::True => eval1(b),
                Term::False => eval1(c),
                _ => Term::If(box eval1(a), box b, box c)
            },
        Term::Zero => Term::Zero,
        Term::Pred(box Term::Succ(box n)) => n,
        Term::IsZero(box Term::Zero) => Term::True,
        Term::IsZero(_) => Term::False,
        _ => Term::False
    }
}

fn main() {
    println!("{:?}", eval1(Term::If(
        box Term::True, 
        box Term::Pred(box Term::Succ(box Term::Zero)), 
        box Term::False))
    );
}

