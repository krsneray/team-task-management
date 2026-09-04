namespace TeamTaskManager.DTO
{
    public class TaskCommentResponseDto
    {
        public int Id { get; set; }

        public int TaskItemId { get; set; }

        public string UserId { get; set; } = default!;

        public string Content { get; set; } = default!;

        public DateTime CreatedDate { get; set; }

        public DateTime? UpdatedDate { get; set; }
    }
}