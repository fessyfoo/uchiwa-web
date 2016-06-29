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

  function groupImplied(head, tail) {
    var result = head,
        len    = tail.length,
        i      = 0;

    for (;i<len; i++) {
      result = {
        op: 'AND',
        note: 'implied',
        left: result,
        right: tail[i][2]
      }
    }
    return result;
  }

}

things = Expression*

Expression
  = __ e:ANDExpression __ { return e}

ANDExpression
  = head:ORExpression _ op:AND _ tail:ANDExpression
    { return { op:op, left: head, right: tail } }
  / head:ORExpression _ !(OR _ ) tail:ANDExpression
    { return { op:'iAND', left: head, right: tail } }
  / ORExpression

ORExpression
  = head:Matcher _ op:OR _ tail:ORExpression
    { return { op:op, left: head, right: tail } }
    / Matcher

OR
  = ( 'OR'i  / '||' ) { return 'OR' }
AND
  = ( 'AND'i / '&&' ) { return 'AND' }

Matcher = PathMatcher / PlainMatcher

PlainMatcher
  = a:StringSequence
    { return {op: 'PlainMatch', match: a } }

PathMatcher
  = p:Path __ ':' __ c:StringSequence
    { return {op: 'PathMatch', path: p, match: c} }

Path
  = a:Token '.' b:Path { return [a].concat(b) }
  / Token

StringSequence
  = a:String _ !(PathMatcher / (AND/OR) _ Matcher) b:StringSequence
    { return a + ' ' + b }
  / String

String
  = DoubleQuotedString
  / SingleQuotedString
  / BareString

BareString
  = BareStringChar+ { return text() }

BareStringChar
  = !WS c:. { return c }

DoubleQuotedString
  = '"' c:DoubleQuoteChar* '"' { return c.join('') }

DoubleQuoteChar
  = EscapeSequence
  / c:[^"]

SingleQuotedString
  = "'" c:SingleQuoteChar* "'" { return c.join('') }

SingleQuoteChar
  = EscapeSequence
  / c:[^']

EscapeSequence
  = '\\' c:EscapeChar  { return c }

EscapeChar
  = "n" { return "\n"  }
  / "b" { return "\b"; }
  / "f" { return "\f"; }
  / "r" { return "\r"; }
  / "t" { return "\t"; }
  / "0" ![0-9] { return "\0"; }
  // TODO:  unicode and hex escapes
  / .

Token
  = token:[a-zA-Z_]+ { return token.join('') }

_
  = WS+

__
  = WS*

WS =
  [ \r\n\t]

