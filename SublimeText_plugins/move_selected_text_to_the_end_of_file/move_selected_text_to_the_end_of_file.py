import sublime
import sublime_plugin

class MoveSelectedTextToTheEndOfFileCommand(sublime_plugin.TextCommand):
  def run(self, edit):
    (original_line_number, original_column_number) = self.view.rowcol(self.view.sel()[0].begin()) # save original line number so we can move back to it later

    original_clipboard_content=sublime.get_clipboard()                                            # save original clipboard content before we run cut command because cut command will erase original clipboard content. But we will need original clipboard content later

    self.view.run_command("cut")                                                                  # cut current selected text. So it will disappear in original place of file, but will be stored in clipboard
    self.view.run_command("move_to", {"to": "eof"})                                               # move cursor to the end of current file
    self.view.run_command("insert", {"characters": "\n" })                                        # insert newline so we will have some space. Otherwise without inserting newline we can paste clipboard into already existing row glueing content together. But we don't want to glue lines
    self.view.run_command("paste")                                                                # paste selected text from clipboard to end of file
    self.view.run_command("insert", {"characters": "\n" })                                        # insert newline so we will have some space 
    self.view.run_command("goto_line", {"line": original_line_number+1})                          # go to original cursor position after selected text is moved to end of file. We need provide original_line_number+1 because original_line_number starts from 0, but goto_line line argument starts from 1

    sublime.set_clipboard(original_clipboard_content)                                             # restore original clipboard content because we don't want to leave in clipboard the text which was cut and moved to end of file. We want to keep clipboard content as before MoveSelectedTextToTheEndOfFileCommand execution

    
