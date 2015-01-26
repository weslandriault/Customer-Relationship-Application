class Rolodex

    @@ids = 1001
    def initialize
        @contacts = []
        # @ids = 1001
    end

    def add_contact(contact)
      contact.id = @@ids
      @contacts << contact
      @@ids += 1
      contact
    end

    def find_contact(id)
      @contacts.find do |contact|
         return contact if contact.id == id
      end

      return nil
   end

    #Chris' code
   #  def all_attributes(attr_name)
   #    @contacts.map { |c| c.send(attr_name) }
   # end

   def return_contacts
      @contacts.each { |contact| contact }
   end

   def modify_contact(contact_to_edit)
      @contacts.find do |contact|
         if contact.id == contact_to_edit.id
            contact = contact_to_edit
         end
      end    
   end

   def delete_contact(contact_to_delete)
      @contacts.find do |contact|
         if contact.id == contact_to_delete.id
            @contacts.delete(contact)
         end
      end
   end

   def delete_attribute(contact_to_delete_attr, attr_name)
      @contacts[0] = contact
      contact.first_name = ""
   end
end