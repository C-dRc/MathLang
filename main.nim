import tables
import strutils
import strformat
import math
import os

#Main var
var
    equations: set[char] = {'+', '-', '*', '/'}

#Variables
var variables = initTable[string, string]()

#Functions
var function = initTable[string, string]()


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


#Solve an equation
proc getEquation(line: string): string =
    var
            temp_out: string
            resolved: string
            content: seq[string]
            to_remove: string
            cleaned_line: string
            prev_letter: char
            index: int

    temp_out = line
    for chars in line:

            if chars in equations:
                case chars
                of '+':
                    content = temp_out.split(equations, 2)
                    resolved = $(resolveValue(content[0], variables) + resolveValue(content[1], variables))
                    to_remove = "" & $content[0] & "+" & $content[1]

                of '-':
                    content = temp_out.split(equations, 2)
                    resolved = $(resolveValue(content[0], variables) - resolveValue(content[1], variables))
                    to_remove = "" & $content[0] & "-" & $content[1]

                of '*':
                    content = temp_out.split(equations, 2)
                    resolved = $(resolveValue(content[0], variables) * resolveValue(content[1], variables))
                    to_remove = "" & $content[0] & "*" & $content[1]
                
                of '/':
                    content = temp_out.split(equations, 2)
                    resolved = $(resolveValue(content[0], variables) / resolveValue(content[1], variables))
                    to_remove = "" & $content[0] & "/" & $content[1]

                else:
                    echo "Something is sirously wrong"
                    
                cleaned_line = temp_out
                cleaned_line.removePrefix(to_remove)
                temp_out = &"{resolved}{cleaned_line}"
                echo &"|{to_remove}|"

            else:
                if $chars in variables:
                    index = line.find(chars)
                    if index > 0:

                        if $line[index - 1] in variables:

                            resolved = $(variables[$chars].parseFloat() * variables[$line[index - 1]].parseFloat())
                            to_remove = &"{variables[$chars]}{variables[$line[index - 1]]}"

                        elif line[index - 1] in equations:
                            continue

                        else:
                            content  = line.split(Letters)
                            resolved = $(content[0].parseFloat() * variables[$chars].parseFloat())

                    elif index >= 0 and index + 1 > line.len():

                        if $line[index + 1] in variables:
                            echo "found0"
                            resolved = $(variables[$chars].parseFloat() * variables[$line[index + 1]].parseFloat())
                            to_remove = &"{variables[$chars]}{variables[$line[index + 1]]}"

                        elif line[index + 1] in equations:
                            continue
                        
                        else:
                            echo &"Error with char: {chars}. Misplaced"
                    
                    cleaned_line = temp_out
                    cleaned_line.removePrefix(to_remove)
                    temp_out = &"{resolved}{cleaned_line}"
                    echo &"|{to_remove}|"




    if equations notin line:
        if line in variables:
            temp_out = variables[line]
    temp_out



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
        if equations in line:
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

