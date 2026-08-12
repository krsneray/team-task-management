using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.Entities;

public class Project
{
    public int Id { get; set; }
    public string Name { get; set; } = default!;
    public string? Description { get; set; }
    public DateOnly StartDate { get; set; }
    public DateOnly TargetEndDate { get; set; }
    public ProjectStatus Status { get; set; }

    public string ManagerUserId { get; set; } = default!;
    public ApplicationUser ManagerUser { get; set; } = default!;

    public DateTime CreatedTime { get; set; }
    public DateTime UpdatedTime { get; set; }

    public ICollection<ProjectMember> Members { get; set; } = new List<ProjectMember>();
    public ICollection<TaskItem> Tasks { get; set; } = new List<TaskItem>();
}