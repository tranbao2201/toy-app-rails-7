module ApplicationHelper
    def full_title page_title
        base_title = "Toy App"
        page_title.present? ? "#{page_title} | #{base_title}" : base_title
    end
end
