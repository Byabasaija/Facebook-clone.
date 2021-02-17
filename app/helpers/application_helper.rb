module ApplicationHelper
  def new_notification(user, notification_id, notification_type)
    notification = user.notifications.build(notification_id: notification_id,   
    notification_type: notification_type)
    user.save
    notification
  end
   
  def notification_find(notification, type)
    return User.find(notification.notification_id) if type == 'friendRequest'
    return Post.find(notification.notification_id) if type == 'comment'
    return Post.find(notification.notification_id) if type == 'like-post'
    return unless type == 'like-comment'
    comment = Comment.find(notification.notification_id)
    Post.find(comment.post_id)
  end
  def liked?(subject, type)
        result = false
        result = Like.where(user_id: current_user.id, post_id:  subject.id).exists? if type == 'post'         
        result = Like.where(user_id: current_user.id, comment_id:  subject.id).exists? if type == 'comment'
                            
        result
    
 end

 def friend_request_sent?(user)
    current_user.friend_sent.exists?(sent_to_id: user.id, status: false)
  end
  
  def friend_request_received?(user)
    current_user.friend_request.exists?(sent_by_id: user.id, status: false)
  end
  
  def possible_friend?(user)
    request_sent = current_user.friend_request_sent.exists?(sent_to_id: user.id)
    request_received = current_user.friend_request_recieved.exists?(sent_by_id: user.id)
    
    return true if request_sent != request_received    
    return true if request_sent == request_received && request_sent == true    
    return false if request_sent == request_received && request_sent == false
  end
end
