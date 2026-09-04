namespace TeamTaskManager.DTO
{
    public class TaskAttachmentResponseDto
    {
        public int Id { get; set; }

        public int TaskItemId { get; set; }

        public string OriginalFileName { get; set; } = default!;

        public string ContentType { get; set; } = default!;

        public long FileSize { get; set; }

        public string UploadedByUserId { get; set; } = default!;

        public DateTime CreatedDate { get; set; }
    }
}