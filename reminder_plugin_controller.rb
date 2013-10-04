 def create_reminder
    begin
    @user = current_user
    @departments = EmployeeDepartment.find(:all)
    @new_reminder_count = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false")
    @reminder = Reminder.new
    @reminder.message_addl_attachments.build
     # sender = params[:reminder][:email]
    unless params[:send_to].nil?
      recipients_array = params[:send_to].split(",").collect{ |s| s.to_i }
      @recipients = User.active.find(recipients_array)
    end
    if request.post?
      #@reminder = MessageAddlAttachment.new
      #@reminder.update_attributes(params[[:reminder][:message_addl_attachments]])

      @addl = @reminder.message_addl_attachments.build(params[:reminder][:message_addl_attachments])
      @addl.save

      @recipients = User.active.find_all_by_id(recipients_array).sort_by{|a| a.full_name.downcase}
      unless params[:reminder][:body] == "" or params[:recipients] == ""
        recipients_array = params[:recipients].split(",").reject{|a| a.strip.blank?}.collect{ |s| s.to_i }
        Delayed::Job.enqueue(DelayedReminderJob.new(:sender_id  => @user.id,:recipient_ids => recipients_array,:subject=>params[:reminder][:subject],:body=>params[:reminder][:body]))
        #unless params[:reminder][:email].blank?
        #  ReminderMailer.deliver_reminder_email(@user.id,params[:reminder][:email],params[:reminder][:subject],params[:reminder][:body],params[:attachments])
        #end

        #@reminder.save
        #flash[:notice] = "#{t('flash12')} #{recipient_list.join(', ')}"
        flash[:notice] = "Message Sent Sucessfully"
        redirect_to :controller=>"reminder", :action=>"create_reminder"
      else
        flash[:notice]="Please fill the required fields"
        redirect_to :controller=>"reminder_plugin", :action=>"create_reminder"
      end
    end
    rescue Exception=> e
      puts "Inside create action.........",e.backtrace
      end
  end
