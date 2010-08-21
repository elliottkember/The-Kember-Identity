'Kember Identity Brute Force Finder
'Version 1.0.1
'Public Domain August 2010
'Written in VB.NET 2.0 by Smallman

Imports System.Security.Cryptography
Imports System.Text
Imports System.IO

Module Module1

    Dim testhash As String = Nothing '= "00000000000000000000000000000000"

    'http://github.com/elliottkember/The-Kember-Identity/blob/master/csharp/csharp-Jostein-Kj%C3%B8nigsen.cs
    Public Function hash(ByVal input As String)
        Dim tmpSource As Byte() = ASCIIEncoding.ASCII.GetBytes(input)
        Dim tmpHash As Byte() = New MD5CryptoServiceProvider().ComputeHash(tmpSource)
        Dim hashString As String = bytesToHex(tmpHash)
        Return hashString
    End Function

    'http://github.com/elliottkember/The-Kember-Identity/blob/master/csharp/csharp-Jostein-Kj%C3%B8nigsen.cs
    Private Function bytesToHex(ByVal bytes As Byte()) As String
        Dim sb As New StringBuilder()

        For Each b As Byte In bytes
            sb.AppendFormat("{0:x2}", b)
        Next

        Return sb.ToString()
    End Function


    Public Sub search64bit(ByVal startvalue As Long, ByVal endvalue As Long)

        Dim blankhash = "00000000000000000000000000000000"
        Dim counter As Long = startvalue

        Do
            counter += 1
            'http://msdn.microsoft.com/en-us/library/6wse73s4.aspx up to 64-bit
            'http://msdn.microsoft.com/en-us/library/b1kwkfdz.aspx up to 32-bit
            Dim thehash = Convert.ToString(counter, 16) 'http://www.xtremedotnettalk.com/showthread.php?t=86681
            thehash = blankhash.Substring(thehash.Length) + thehash 'prepend the 0's
            'Console.WriteLine(thehash + "|" + hash(thehash) + "|" + counter.ToString)'debug
            'If counter Mod 10000 = 0 Then
            'Console.WriteLine(counter.ToString)
            'End If
            If (thehash = hash(thehash)) Then
                found(thehash)
            End If

        Loop While (counter < endvalue)

    End Sub

    Public Sub search128bit(ByRef startvalue As String, ByRef endvalue As String)
        'pad the hashes
        Dim blankhash = "00000000000000000000000000000000"
        If (startvalue.Length <> 32) Then
            startvalue = blankhash.Substring(startvalue.Length) + startvalue 'prepend the 0's
        End If
        If (endvalue.Length <> 32) Then
            endvalue = blankhash.Substring(endvalue.Length) + endvalue 'prepend the 0's
        End If

        Dim currenthash As String = startvalue
        Do
            If (currenthash = hash(currenthash)) Then
                found(currenthash)
            End If
            currenthash = hexadecimalup(currenthash)
        Loop While (currenthash <> endvalue)

    End Sub

    Public Function hexadecimalup(ByRef input As String) 'increase the hexadecimal by one
        Dim blankhash = "00000000000000000000000000000000"
        Dim hexadecimal = "0123456789abcdef"
        Dim counter = 32
        Dim replacecounter = -1
        Do
            counter -= 1
            replacecounter += 1
        Loop While (Input.Substring(counter, 1) = "f")

        'replace the last non f with that character + 1
        'testhash(counter) = hexadecimal(hexadecimal.IndexOf(testhash(counter)) + 1)
        Input = Input.Remove(counter, 1).Insert(counter, hexadecimal(hexadecimal.IndexOf(Input(counter)) + 1))

        'replace after the new character all 0's if there's something to replace
        If (replacecounter > 0) Then
            input = input.Remove(counter + 1)
            input = input.Insert(counter + 1, blankhash.Substring(0, replacecounter)) 'remove after the updated character and replace with 0's
        End If
        Return input
    End Function

    Public Sub found(ByVal input As String)

        Console.WriteLine("WORKS! : " + input)
        'Maybe clipboard someday
        Dim appbase As String = AppDomain.CurrentDomain.SetupInformation.ApplicationBase()
        Try
            Dim objWriter As New System.IO.StreamWriter(appbase + "\Kember Identity found.txt")
            objWriter.WriteLine(input)
            objWriter.Close()
        Catch e As Exception
            Console.WriteLine(e.Message)
        End Try
        System.Threading.Thread.Sleep(20000000)

    End Sub

    Sub Main()
        Console.WriteLine("======================================")
        Console.WriteLine("* Kember Identity Brute Force Finder *")
        Console.WriteLine("*            Version 1.0.1           *")
        Console.WriteLine("*     Public Domain August 2010      *")
        Console.WriteLine("* Written in VB.NET 2.0 by Smallman  *")
        Console.WriteLine("======================================")

        Console.WriteLine()
        Console.WriteLine()
        Console.WriteLine()

        Console.WriteLine("PURPOSE")
        Console.WriteLine("This application tests for the Kember Identity for MD5 via brute-force")
        Console.WriteLine("This identity is a fixed point for MD5 in which the hash will equal the input")
        Console.WriteLine("More information can be found at http://elliottkember.com/kember_identity.html")

        Console.WriteLine()

        Console.WriteLine("================================================================================")
        Console.WriteLine("1 - Start testing from 0 to ad infinitum")
        Console.WriteLine("2 - Start testing from one integer to another (both in the 64-bit signed range)")
        Console.WriteLine("3 - Start testing from one hexadecimal to another hexadecimal")
        Console.WriteLine("4 - Test speed by testing 11m - 11.5m in decimal and hexadecimal ")
        Console.WriteLine("5 - Quit")
        Console.Write("Please enter the number of your choice: ")
        Dim choicenumber As Integer = Console.ReadLine()
        If (choicenumber = "5") Then
            End
        End If

        Console.WriteLine()
        Console.WriteLine("I will now see how long it will take to check 1 million hashes.")
        Console.WriteLine("This may take up to a minute (or 2 for older PCs).")
        Console.WriteLine("Press any key to continue...")
        Console.ReadLine()
        Console.Clear()


        If (choicenumber = "4") Then
            'Check 64-bit integer
            Console.WriteLine("Checking 64-bit integer...")
            Dim start_timea As DateTime = Now
            search64bit(11000000, 11500000)
            Dim stop_timea As DateTime = Now
            Dim elapsed_timea As TimeSpan
            elapsed_timea = stop_timea.Subtract(start_timea)
            Console.WriteLine("Time Taken for 64-bit: " + (elapsed_timea.TotalSeconds * 2).ToString("0.000000") + "seconds.")

            Console.WriteLine()

            'Check 128-bit hexadecimal string
            Console.WriteLine("Checking 128-bit hexadecimal string...")
            Dim start_timeb As DateTime = Now
            search128bit("00000000000000000000000000a7d8c0", "00000000000000000000000000af79e0")
            Dim stop_timeb As DateTime = Now
            Dim elapsed_timeb As TimeSpan
            elapsed_timeb = stop_timeb.Subtract(start_timeb)
            Console.WriteLine("Time Taken for 128-bit hexadecimal string: " + (elapsed_timeb.TotalSeconds * 2).ToString("0.000000") + "seconds.")
            Console.WriteLine("Press any key to quit...")
            Console.ReadLine()
            End
        End If

        Console.WriteLine()
        Console.WriteLine()
        Console.WriteLine()

        'Whether or not to begin
        Console.WriteLine("================================================================================")
        Console.WriteLine("Please enter 'y' (without ') to begin.")
        Console.WriteLine("Entering anything else will quit the program.")
        Console.WriteLine("You may press CRTL+C to break the loop in the program.")
        Console.WriteLine("Nothing will be displayed while the program is searching...")
        Console.WriteLine("If a Kember Identity is found, the identidy will be written to a file")
        Console.WriteLine("and the program will pause indefinitely")
        Console.Write("Enter choice: ")
        Dim tobeornottobe As String = Console.ReadLine()
        If (tobeornottobe.ToLower <> "y") Then
            End
        End If
        Console.WriteLine()

        'Console.WriteLine("The program will begin in 5 seconds...")
        'System.Threading.Thread.Sleep(50000)
        Console.Clear()
        Console.ForegroundColor = ConsoleColor.Green 'Make it green


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        'Begin the brute forces

        If (choicenumber = 1) Then
            'Do the search
            Static start_time As DateTime = Now
            search64bit(0, 9223372036854775807) '= '0x7FFFFFFFFFFFFFFF http://msdn.microsoft.com/en-us/library/ee621251.aspx
            search128bit("00000000000000008000000000000000", "ffffffffffffffffffffffffffffffff")
            Static stop_time As DateTime = Now
            Dim elapsed_time As TimeSpan
            elapsed_time = stop_time.Subtract(start_time)

            'Report
            Console.WriteLine("-------------------------------------------------------------------------------")
            Console.WriteLine("Search from: 0 to 0xffffffffffffffffffffffffffffffff complete.")
            Console.WriteLine("No Kember Identity found.")
            Console.WriteLine("Time Taken: " + elapsed_time.TotalSeconds.ToString("0.000000") + "seconds.")
            Console.Write("Press enter to continue...")
            Console.ReadLine()
            End
        End If

        If (choicenumber = 2) Then
            'Get Range
            Dim startnumber, endnumber As Long
            Console.Write("Enter the number to start with (in decimal format): ")
            startnumber = Console.ReadLine()
            Console.Write("Enter the number to end with (in decimal format): ")
            endnumber = Console.ReadLine()

            'Do the search
            Static start_time1 As DateTime = Now
            search64bit(startnumber, endnumber)
            Static stop_time1 As DateTime = Now
            Dim elapsed_time As TimeSpan
            elapsed_time = stop_time1.Subtract(start_time1)

            'Report
            Console.WriteLine("-------------------------------------------------------------------------------")
            Console.WriteLine("Search from: " + startnumber.ToString + " to " + endnumber.ToString + " complete.")
            Console.WriteLine("No Kember Identity found.")
            Console.WriteLine("Time Taken: " + elapsed_time.TotalSeconds.ToString("0.000000") + "seconds.")
            Console.Write("Press enter to continue...")
            Console.ReadLine()
            End
        End If

        If (choicenumber = 3) Then
            'Get Range
            Dim startnumber, endnumber As String
            Console.Write("Enter the hex to start with (it will automatically be padded): ")
            startnumber = Console.ReadLine()
            Console.Write("Enter the hex to end with (it will automatically be padded): ")
            endnumber = Console.ReadLine()

            'Do the search
            Static start_time2 As DateTime = Now
            search128bit(startnumber, endnumber)
            Static stop_time2 As DateTime = Now
            Dim elapsed_time As TimeSpan
            elapsed_time = stop_time2.Subtract(start_time2)

            'Report
            Console.WriteLine("-------------------------------------------------------------------------------")
            Console.WriteLine("Search from: " + startnumber + " to " + endnumber + " complete.")
            Console.WriteLine("No Kember Identity found.")
            Console.WriteLine("Time Taken: " + elapsed_time.TotalSeconds.ToString("0.000000") + "seconds.")
            Console.Write("Press enter to continue...")
            Console.ReadLine()
            End
        End If

    End Sub

End Module

'Resources
'Time elapsed:         'http://www.vb-helper.com/howto_net_measure_elapsed_time.html

'Other
'if output displayed:
'58.67' all of them
'18.677 '10
'13.58 '100
'13.028 '1000
'13.402 '10000
'12.811 'none displayed
