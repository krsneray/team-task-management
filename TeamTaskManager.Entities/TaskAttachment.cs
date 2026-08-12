namespace TeamTaskManager.Entities;

public class TaskAttachment
{
    public int Id { get; set; }

    public int TaskItemId { get; set; }
    public TaskItem TaskItem { get; set; } = default!;

    public string OriginalFileName { get; set; } = default!;
    public string StoredFileName { get; set; } = default!;
    public string FilePath { get; set; } = default!;
    public string ContentType { get; set; } = default!;
    public long FileSize { get; set; }

    public string UploadedByUserId { get; set; } = default!;
    public ApplicationUser UploadedByUser { get; set; } = default!;

    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
}