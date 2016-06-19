{
  function groupLeftAssociative(head, tail) {
    var result = head,
        len    = tail.length,
        i      = 0;

    for (;i<len; i++) {
      result = {
        op: tail[i][1],
        left: result,
        right: tail[i][3]
      }
    }

     return result;
  }

}

// things
//   = (_ thing:thing _ { return thing })*

foo = _ thing:thing _ { return thing }

thing
  = ORExpression

ANDExpression
  = head:Matcher tail:(_ AND _ Matcher)*
    { return groupLeftAssociative(head, tail) }
  / Matcher

ORExpression
  = head:ANDExpression tail:(_ OR _ ANDExpression)*
    { return groupLeftAssociative(head, tail) }
  / ANDExpression

OR
  = _ 'OR'i  _ { return 'OR' }
AND
  = _ 'AND'i _ { return 'AND' }

Matcher = PathMatcher / PlainMatcher

PlainMatcher
  = a:StringSequence
    { return {op: 'PlainMatch', match: a } }

PathMatcher
  = _ p:Path _ ':' _ c:StringSequence _
    { return {op: 'PathMatch', path: p, match: c} }

Path
  = a:Token '.' b:Path { return [a].concat(b) }
  / Token

StringSequence
  = a:String WS+ b:StringSequence
    { return a + ' ' + b }
  / String

String
  = DoubleQuotedString
  / SingleQuotedString
  / BareString

BareString
  = !( AND / OR ) BareStringChar+
  { return text() }

BareStringChar
  = !WS c:. { return c }

DoubleQuotedString
  = '"' c:DoubleQuoteChar* '"'
    { return c.join('') }

DoubleQuoteChar
  = EscapeSequence
  / c:[^"]

SingleQuotedString
  = "'" c:SingleQuoteChar* "'"
    { return c.join('') }

SingleQuoteChar
  = EscapeSequence
  / c:[^']

EscapeSequence
  = '\\' c:EscapeChar  { return c }

EscapeChar
  = "n" { return "\n" }
  / "b" { return "\b";   }
  / "f" { return "\f";   }
  / "r" { return "\r";   }
  / "t" { return "\t";   }
  / "v" { return "\x0B"; }   // IE does not recognize "\v".
  / "0" ![0-9] { return "\0"; }
  // TODO:  unicode and hex escapes
  / .

Token
  = token:[a-zA-Z_]+ { return token.join('') }

_
  = WS*

WS =
  [ \r\n\t]
