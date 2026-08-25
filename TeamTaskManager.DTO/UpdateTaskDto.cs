using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.DTO;

public class UpdateTaskDto
{
    public string Title { get; set; } = default!;

    public string? Description { get; set; }

    public string AssignedUserId { get; set; } = default!;

    public TaskPriority Priority { get; set; }

    public ProjectTaskStatus Status { get; set; }

    public DateOnly? StartDate { get; set; }

    public DateOnly DueDate { get; set; }
}