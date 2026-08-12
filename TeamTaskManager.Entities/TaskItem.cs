using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.Entities;

public class TaskItem
{
    public int Id { get; set; }

    public int ProjectId { get; set; }
    public Project Project { get; set; } = default!;

    public string Title { get; set; } = default!;
    public string? Description { get; set; }

    public string AssignedUserId { get; set; } = default!;
    public ApplicationUser AssignedUser { get; set; } = default!;

    public TaskPriority Priority { get; set; }
    public ProjectTaskStatus Status { get; set; }

    public DateOnly? StartDate { get; set; }
    public DateOnly DueDate { get; set; }
    public DateTime? CompletedDate { get; set; }

    public string CreatedByUserId { get; set; } = default!;
    public ApplicationUser CreatedByUser { get; set; } = default!;

    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedDate { get; set; }

    public ICollection<TaskComment> Comments { get; set; } = new List<TaskComment>();
    public ICollection<TaskAttachment> Attachments { get; set; } = new List<TaskAttachment>();
}