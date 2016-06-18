things = ORExpression

ANDExpression 
  = head:matcher tail:(_ AND _ ANDExpression)
    { return {op: tail[1], left: head, right: tail[3]} }
  / matcher

ORExpression
  = head:ANDExpression tail:(_ OR _ ANDExpression)
    { return {op: tail[1], left: head, right: tail[3]} }
  / ANDExpression

 
OR  
  = _ 'OR'i  _ { return 'OR' }
AND 
  = _ 'AND'i _ { return 'AND' }

matcher = PathMatcher / PlainMatcher

PlainMatcher
  = _ c:RegexChars _
    { return {op: 'matcher', path: c } }
    
PathMatcher 
  = _ p:Path _ ':' _ c:RegexChars _ 
    { return {op: 'matcher', path: p, match: c} }

Path = a:token '.' b:Path { return [a].concat(b) } / token

token = token:[a-zA-Z_]+ { return token.join('') }
RegexChars = chars:[a-zA-Z]+ { return chars.join('') }
_ = [ \r\n\t]*
