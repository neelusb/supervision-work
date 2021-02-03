class UnpairedParenthesisError(Exception):
    pass


def infix_aux(exp, parens_opened):
    outp = ''
    next_literal = None
    while exp:
        print(exp, outp)
        current_literal = exp[0]
        if current_literal == '':
            exp = exp[1:]
            continue
        elif current_literal == '(':
            in_parens, rest_of_exp, parens_opened = infix_aux(
                exp[1:], parens_opened + 1)
            outp += in_parens
            exp = rest_of_exp
        elif current_literal == ')':
            if not parens_opened:
                raise UnpairedParenthesisError('Unopened parenthesis closed')
            return outp, exp[1:], parens_opened - 1
        elif current_literal in '+-*/':
            next_literal = current_literal
            exp = exp[1:]
        else:
            outp += current_literal + ' '
            if next_literal:
                outp += next_literal + ' '
                next_literal = None
            exp = exp[1:]
    return outp, '', parens_opened


def infix(exp_string):
    exp_string = exp_string.replace(' ', '').replace('+', '|+|')
    exp_string = exp_string.replace('-', '|-|').replace('*', '|*|')
    exp_string = exp_string.replace('/', '|/|').replace('(', '|(|')
    exp_string = exp_string.replace(')', '|)|')
    exp = exp_string.split('|')
    outp, exp, parens_opened = infix_aux(exp, 0)
    if parens_opened:
        raise UnpairedParenthesisError('Unclosed parenthesis')
    return outp


print(infix('(3+12)*4 - 2'))
print(infix('((1 * 2) + 3) + 6'))
print(infix('((1 * 2) + 3 + 6'))  # Raises exception
