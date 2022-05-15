# Purpose
This plugin will move selected text to the end of file. Works only in Sublime Text editor https://www.sublimetext.com/

# Use case
This can be particularly useful if you use text file as a task list.
For example you have file my_current_task.txt
<pre>
do something 2

do something 3

do something 4


done
--------------

do something 1

</pre>

You did your second item and want to mark it as done. Therefore you have to move this item into done section (you don't want to just remove completed item because you want to keep history of completed items).
Done section is in the end of document. So manually you would have to cut second item (Ctrl+X), move cursor to the end of file (Ctrl+End), paste (Ctrl+V) selection and then move back cursor to the original line.
It is quite a routine to do all those manual steps. Therefore you can just run it as a single command.
Running it as a single command is a use case of current plugin.
You can map the command of current plugin to some keyboard combination (e.g. to F1) and do it by just pressing one keyboard combination.

# Deployment
* Open folder "C:\Users\username\AppData\Roaming\Sublime Text\Packages\User" and copy here move_selected_text_to_the_end_of_file.py file.
* Open Sublime Text -> Preferences -> Key Bindings. Modify "Default (Windows).sublime-keymap" (in User folder) file to map some keyboard combination to new command. E.g. in order to map for F1 add the following entry:
<pre>
{ "keys": ["f1"], "command": "move_selected_text_to_the_end_of_file"}
</pre>
* use plugin via pressing F1 on selected text so it will be moved into end of file and cursor will be back at original place

# Implementation details
Originally this macro was implemeted as simple move_text_to_the_end_of_file.sublime-macro file with the following content
<pre>
[
	{
		"args": null,
		"command": "cut"
	},
	{
		"args":
		{
			"extend": false,
			"to": "eof"
		},
		"command": "move_to"
	},
	{
		"args":
		{
			"characters": "\n"
		},
		"command": "insert"
	},
	{
		"args": null,
		"command": "paste"
	},
	{
		"args":
		{
			"characters": "\n"
		},
		"command": "insert"
	},
	{
		"args": null,
		"command": "jump_back"
	}
]
</pre>
But the issue with such implementation is unstable behavior of jump_back command. jump_back command has complex algorithm to add new entry into its history. For example when you are on tab A and then move on tab B, then paste some text into tab B, hightlight selection for pasted text and execute macro in tab B then jump_back command will most likely jump back to tab A.
This is definitively not behavior you want. You want jump_back into tab B to original cursor position where pasted text was.
The issue here is because in order jump_back remember current line position in its history, you have to do some actions on this line. The type of actions are different (e.g. wait some seconds, move cursor somewhere etc) and not fully known (as I didn't want to reverse engineer jump_back code). Therefore it is a bit challenge to match some behavior in my macro to satisfy jump_back command remember current line.
So decision was made to not use jump_back prebuilt command, but implement my own jump_back logic with stable and predictable behavior: remember original line number, move selection to end of file and then go to remembered line.
