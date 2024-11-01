# frozen_string_literal: true

class UpdatePostStateWorker < BaseWorker
  sidekiq_options queue: :default, retry: 1

  def perform(post_id, status)
    post = Post.find(post_id)

    post.aasm.fire(status)
    post.published_at = DateTime.current if status.to_sym == :published
    post.save!
  end
end
