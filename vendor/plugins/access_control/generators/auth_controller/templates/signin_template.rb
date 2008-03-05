<%%= start_form_tag :controller => "<%= class_name.downcase %>", :action => "signin" %>
  <label for="user_signin_id">Signin Id:</label>
  <%%= text_field :user, :signin_id %>
  <label for="user_password">Password:</label>
  <%%= password_field :user, :password %>
<%%= end_form_tag %>