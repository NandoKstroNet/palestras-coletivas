require "spec_helper"

describe "Create talk", :type => :request, :js => true do
  let!(:user)         { create(:user, :paul) }
  let!(:invited_user) { create(:user, :luis, name: "Luis XIV", username: "@username_luis") }
  let!(:other_user)   { create(:user, :billy, name: "Billy Boy", username: "@username_billy") }

  context "with valid data from slideshare" do
    before do
      login_as(user)
      visit root_path

      click_link "Palestras"
      click_link "Adicionar palestra"

      fill_in "Link da palestra", :with => "http://www.slideshare.net/luizsanches/compartilhe"
      fill_in "Descrição", :with => "Palestra que fala sobre o compartilhamento de conhecimento na era da informação"
      fill_in "Tags", :with => "conhecimento, compartilhamento"
      fill_in "Link do vídeo", :with => "http://www.youtube.com/watch?v=wGe5agueUwI"
      check("Quero publicar")

      fill_autocomplete('invitee_username', with: '@us', select: "Luis XIV (@username_luis)")
      click_button :add_user

      click_button "Adicionar palestra"
    end

    it "redirects to the talk page" do
      expect(current_path).to match(%r[/talks/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("A palestra foi adicionada!")
    end

    it "invites the right co-author" do
      expect(page).to     have_content("Luis XIV")
      expect(page).to_not have_content("Billy Boy")
    end
  end

  context "with valid data from speakerdeck" do
    before do
      login_as(user)
      visit root_path

      click_link "Palestras"
      click_link "Adicionar palestra"

      fill_in "Link da palestra", :with => "https://speakerdeck.com/luizsanches/ruby-praticamente-falando"
      fill_in "Descrição", :with => "Indrodução à linguagem Ruby"
      fill_in "Tags", :with => "ruby, programação"
      fill_in "Link do vídeo", :with => "https://vimeo.com/46879129"
      check("Quero publicar")

      click_button "Adicionar palestra"
    end

    it "redirects to the talk page" do
      expect(current_path).to match(%r[/talks/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("A palestra foi adicionada!")
    end
  end

  context "with valid data but no link" do
    before do
      login_as(user)
      visit root_path

      click_link "Palestras"
      click_link "Adicionar palestra"

      fill_in "Título", :with => "A linguagem C"
      fill_in "Descrição", :with => "Indrodução à linguagem C"
      fill_in "Tags", :with => "C, programação"
      fill_in "Link do vídeo", :with => "http://www.youtube.com/invalid"
      check("Quero publicar")

      click_button "Adicionar palestra"
    end

    it "redirects to the talk page" do
      expect(current_path).to match(%r[/talks/\w+])
    end

    it "displays success message" do
      expect(page).to have_content("A palestra foi adicionada!")
    end
  end

  context "with invalid data" do
    before do
      login_as(user)
      visit root_path

      click_link "Palestras"
      click_link "Adicionar palestra"

      click_button "Adicionar palestra"
    end

    it "renders form page" do
      expect(current_path).to eql(talks_path)
    end

    it "displays error messages" do
      expect(page).to have_content("Verifique o formulário antes de continuar:")
    end
  end

  context "when the slides are not found" do
    before do
      login_as(user)
      visit root_path

      click_link "Palestras"
      click_link "Adicionar palestra"

      fill_in "Link da palestra", :with => "http://www.slideshare.net/luizsanches/invalid"
      fill_in "Título", :with => "Compartilhe!"
    end

    it "displays error message" do
      expect(page).to have_content("Palestra não encontrada")
    end
  end
end
