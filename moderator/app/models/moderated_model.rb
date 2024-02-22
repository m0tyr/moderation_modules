class ModeratedModel < ApplicationRecord
    include Moderable
    def index
      end
    def attributes_to_moderate
        [:content, :title]
    end