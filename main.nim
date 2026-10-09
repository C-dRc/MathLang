import tables
import strutils
import strformat
import math
import os

#Main var
const
    Equations: set[char] = {'+', '-', '*', '/'}

#Variables
var variables: Table[system.string, system.string] = initTable[string, string]()

#Functions
var function: Table[system.string, system.string] = initTable[string, string]()


#Helping procedures
proc stripBare(line: string, list: seq = @[""]): string =
    var newline = line.replace(" ").replace("\t").replace("\"")
    for i in list:
        newline = newline.replace(i)
    newline

#Resolves the value
proc resolveValue(value: string, variables: Table[string, string]): float =
    if value in variables:
        return variables[value].parseFloat()
    else:
        return value.parseFloat()

proc deleteLastEquationItem(equation: var seq[string]) =
    if equation.len > 0:
        equation.setLen(equation.len - 1)


#Solve an equation
proc parseEquation(line: string): seq[string] =
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
    equation


proc getEquation(line_to_solve: string): string =
    var 
        equation: seq[string] = parseEquation(line_to_solve)
        equationResult: string

    for i in equation:

        case i
        of "+":
            var pos: int = equation.find("+") 
            equationResult = $(equation[pos - 1].parseFloat() + equation[pos + 1].parseFloat())

        of "-":
            var pos: int = equation.find("+") 
            equationResult = $(equation[pos - 1].parseFloat() - equation[pos + 1].parseFloat())

        of "*":
            var pos: int = equation.find("+") 
            equationResult = $(equation[pos - 1].parseFloat() * equation[pos + 1].parseFloat())
 
        of "/":
            var pos: int = equation.find("+") 
            equationResult = $(equation[pos - 1].parseFloat() / equation[pos + 1].parseFloat())
            
        else:
            echo "Action not recongnized in the equation"

    equationResult


    
        
        



#Check for the file to run
if paramCount() < 1:
    echo "Problem with command: No files were given to run"
    quit(1)

let file = paramStr(1)

#Code
for line in lines(file):

    #Declare a variable
    if "=" in line:
        var 
            content: seq[string]
            value: string

        #If the value is made of an euqation
        if Equations in line:
            content = line.strip_bare().split("=")
            value = content[1].getEquation()
            if value.parseFloat() == trunc(value.parseFloat()):
                value = $trunc(value.parseFloat()).toInt()
            else:
                value = $value

            variables[content[0]] = value
            echo &"{content[0]} is equal to {value}"

        else:
            content = line.strip_bare().split("=")
            variables[content[0]] = content[1]
            echo &"{content[0]} is equal to {content[1]}"



    #Output an equation
    elif "?" in line:
        var 
            output: float
            temp_out: string
            new_line: string = line.stripBare(@["?"])
            line_w_q: string = line.replace("?")

        temp_out = new_line.getEquation()
        

        output = temp_out.parseFloat()
        #Make the output a float or a int
        if output == trunc(output):
            echo &"{line_w_q} = {output.toInt()}"
        else:
            echo &"{line_w_q} = {output}"
        
    #Check if line isn't understandable
    else:
        if line.stripBare() != "":
            echo &"Problem with a line: Unregonizable pattern at line: {line}"

