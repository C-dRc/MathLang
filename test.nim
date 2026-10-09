import tables
import strutils
import strformat

#Main var
const
    Equations: set[char] = {'+', '-', '*', '/'}

#Variables
var variables: Table[system.string, system.string] = initTable[string, string]()

variables["a"] = "12"
variables["b"] = "11"




proc deleteLastEquationItem(equation: var seq[string]) =
    if equation.len > 0:
        equation.setLen(equation.len - 1)


proc parseEquation(line: string): string =
    var
            to_go: string
            pos: int
            equation: seq[string]
            to_remove: string

    to_go = line
    pos = 0
    echo to_go

    while to_go != "":
        echo "to_go: '", to_go, "'  equation: ", equation
        pos = 0
        if to_go[0] in Digits:
            var numbers: string = $to_go[0]
            pos += 1
            while pos < to_go.len and to_go[pos] in Digits:
                numbers.add($to_go[pos])
                pos += 1

            to_go.removePrefix(numbers)
            equation.add(numbers)
            if to_go.len > 0 and $to_go[0] in variables:
                equation.add("*")

        elif $to_go[0] in variables:
            equation.add(variables[$to_go[0]])
            to_go = to_go.substr(1)
            if to_go.len > 0 and $to_go[0] in variables:
                equation.add("*")

        elif to_go[0] in Equations:
            equation.add($to_go[0])
            to_go = to_go.substr(1)

        else:
            to_go = to_go.substr(1)


    echo &"Finished equation: {equation}"
  
discard parseEquation("a+123/b+4ba-5ba")
