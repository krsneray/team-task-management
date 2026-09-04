namespace TeamTaskManager.DTO
{
    public class CreateTaskCommentDto
    {
        public int TaskItemId { get; set; }

        public string Content { get; set; } = default!;
    }
}