class Colors():
	#NORMAL
	C_RED="\033[31m"
	C_GREEN="\033[32m"
	C_YELLOW="\033[33m"
	C_BLUE="\033[34m"
	#BOLD
	C_RED_BOLD="\033[1;31m"
	C_GREEN_BOLD="\033[1;32m"
	C_YELLOW_BOLD="\033[1;33m"
	C_BLUE_BOLD="\033[1;34m"
	#OTHER
	C_END="\033[0m"
	C_BOLD="\033[1m"

	def diable(self):
		#NORMAL
		self.C_RED=""
		self.C_GREEN=""
		self.C_YELLOW=""
		self.C_BLUE=""
		#BOLD
		self.C_RED_BOLD=""
		self.C_GREEN_BOLD=""
		self.C_YELLOW_BOLD=""
		self.C_BLUE_BOLD=""
		#OTHER
		self.C_END=""
		self.C_BOLD=""
        
print (Colors.C_BLUE +'HOLA-HOLA!'+ Colors.C_END)
print (Colors.C_BLUE_BOLD +'HOLA-HOLA!'+ Colors.C_END)
print (Colors.C_RED +'HOLA-HOLA!'+ Colors.C_END)
print (Colors.C_RED_BOLD +'HOLA-HOLA!'+ Colors.C_END)
print("PROBANDOOOO")
