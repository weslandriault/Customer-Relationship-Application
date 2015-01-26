require_relative './rolodex.rb'
require_relative './contact.rb'

class CRM 

	attr_reader :name

	def initialize(name)
		@name = name
		@rolodex = Rolodex.new
	end

	def clear_screen
		print "\e[H\e[2J"
	end

	def print_main_menu
		puts
		puts "[1] Add a contact"
		puts "[2] Modify a contact"
		puts "[3] Delete a contact"
		puts "[4] Display one contact"
		puts "[5] Display all contacts"
		puts "[6] Display an attribute"
		puts "[7] Delete an attribute"
		puts "[8] Exit"
		print "Enter a number: "
	end

	def main_menu
		
		clear_screen

		puts "Welcome to #{@name}!"
		while true
			print_main_menu
			input = gets.chomp.to_i
			puts
			select_option(input)
			return if input == 8
		end
	end

	def select_option(option)
		case option
		when 1 then add_contact
		when 2 then modify_contact
		when 3 then delete_contact
		when 4 then find_contact
		when 5 then display_contacts
		when 6 then display_attribute
		when 7 then delete_an_attribute
		when 8
			puts "Goodbye!"
		else
			clear_screen
			puts "Incorrect option. Try again!"
		end
	end

	def select_attribute
		
		puts "[1] Contact ID"
		puts "[2] First Name"
		puts "[3] Last Name"
		puts "[4] Email"
		puts "[5] Note"
		puts "[6] Go back to Main Menu"
		puts
		print "Make your selection: "

		input = gets.chomp.to_i
	end

	def are_there_contacts
		contacts = return_contacts

		if contacts.first == nil
			clear_screen
			puts "There are no contacts to display."
			return
		else 
			return true
		end
	end

	def return_contacts
		contacts = @rolodex.return_contacts
	end

	def confirm_changes(change, contact)

		case change
		when "modify"
			puts "Are you sure you want to modify this contact?"
		when "delete"
			puts "Are you sure you want to delete?"
		end

		while true
			print "(Y / N): "
			input = gets.chomp.upcase
			if input == "Y" or input == "N"
				return input
			else
				puts "Incorrect selection please make another choice"
			end
		end
	end

	def add_contact
		clear_screen
		puts "Provide Contact Details"
		print "First Name: "
		first_name = gets.chomp

		print "Last Name: "
		last_name = gets.chomp

		print "Email: "
		email = gets.chomp

		print "Note: "
		note = gets.chomp

		new_contact = Contact.new(first_name, last_name, email, note)
		@rolodex.add_contact(new_contact)
	end


	def modify_contact
		clear_screen

		return if are_there_contacts? == nil

		while true
			
			print "Enter the contact ID of the contact you wish to edit: "
			id = gets.chomp
			if id == "\e"
				clear_screen
				return
			end
			id = id.to_i

			contact_to_modify = @rolodex.find_contact(id)
			
			unless contact_to_modify == nil
				clear_screen
				confirm_modify = confirm_changes("modify", contact_to_modify)

				if confirm_modify == "Y"
					puts "Please make your changes to each attribute"
					print "First Name: "
					contact_to_modify.first_name = gets.chomp

					print "Last Name: "
					contact_to_modify.last_name = gets.chomp

					print "Email: "
					contact_to_modify.email = gets.chomp

					print "Note: "
					contact_to_modify.note = gets.chomp

					@rolodex.modify_contact(contact_to_modify)
					return
				end
			else
				clear_screen
				puts "That contact doesn't exist!!\n\n"
				puts "Press ESC then enter to return to main menu"
			end

		end
	end

	def delete_contact
		clear_screen

			return if are_there_contacts == nil
			while true
			print "Enter the contact ID of the person you wish to delete: "
			id = gets.chomp
			if id == "\e"
				clear_screen
				return
			end

			id = id.to_i
			contact_to_delete	= @rolodex.find_contact(id)

			unless contact_to_delete == nil
				confirm_modify = confirm_changes("delete", contact_to_delete)

				if confirm_modify == "Y"
					@rolodex.delete_contact(contact_to_delete)
					puts "Contact with ID: #{id} has been successfully deleted."
					return
				else
					return
				end
			else
				puts
				puts "That contact doesn't exist in the rolodex!"
				puts "Press ESC then enter to return to main menu"
			end
		end	
	end

	def display_contact(contact)
		puts "ID: #{contact.id}"
		puts "First Name: #{contact.first_name}"
		puts "Last Name: #{contact.last_name}"
		puts "Email: #{contact.email}"
		puts "Note: #{contact.note}"
		puts
	end

	def display_contacts
		clear_screen
		contacts = return_contacts

		puts "Here is your list of contacts:"
		puts
		contacts.each do |contact|
			display_contact(contact)
		end
	end

	def find_contact
		contact = nil
		clear_screen

		return if are_there_contacts == nil

		while contact == nil
			puts "What is the ID of the person you want to see?"
			id = gets.chomp

			if id == "\e"
				clear_screen
				return
			end

			id = id.to_i
			puts
			contact = @rolodex.find_contact(id)

			if contact != nil
				display_contact(contact)
				return
			else
				clear_screen
				puts "Sorry that contact doesn't exist!" 
				puts "Press ESC then enter to return to main menu"
			end
		end
	end

	def display_attribute

		if are_there_contacts == nil
			return
		end

		contacts = return_contacts

		while true
			clear_screen
			puts "What is the attribute of the contact that you would like to display?"		
				input = select_attribute
				contacts.each do |contact|

					case input
						when 1 
							puts contact.id
						when 2 
							puts contact.first_name
						when 3 
							puts contact.last_name
						when 4 
							puts contact.email
						when 5
							puts contact.note
						# when 6
						# 	return
						else
							puts "Invalid selection. Try again!"
							puts "Press 6 to return to main menu."
					end
				end

				if input < 1 || input > 5
					puts "Invalid selection. Try again!"
					puts "Press 6 to return to main menu."
				else
					return
				end
		end
	end

	def delete_an_attribute
		
		return if are_there_contacts? == nil

		while true
			clear_screen		
			print "Enter the contact ID of the contact you wish to edit: "
			id = gets.chomp.to_i

			contact	= @rolodex.find_contact(id)
		
			unless contact == nil
			clear_screen

				while true
					puts "What is the attribute of the contact that you would like to delete"
					
					input = select_attribute

					case input
						when 1 
							# @rolodex.delete_attribute(contact, contact.id)
							contact.id = nil
							return
						when 2
							contact.first_name = nil
							return
						when 3 
							contact.last_name = nil
							return
						when 4 
							contact.email = nil
							return
						when 5
							contact.note = nil
							return
						else
							clear_screen
							return if input == 0
							puts "Invalid selection! Please try again\n\n"
							puts 

					end

				end
				else
					puts "Sorry that contact does not exist!"
					puts "Press 0 to return to main menu."
					
				end
			end

			@rolodex.modify_contact(contact)
	end

end

bitmaker = CRM.new("Test CRM")
bitmaker.main_menu