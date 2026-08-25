using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.DTO;

public class ProjectResponseDto
{
    public int Id { get; set; }

    public string Name { get; set; } = default!;

    public string? Description { get; set; }

    public DateOnly StartDate { get; set; }

    public DateOnly TargetEndDate { get; set; }

    public ProjectStatus Status { get; set; }

    public string ManagerUserId { get; set; } = default!;

    public DateTime CreatedTime { get; set; }

    public DateTime UpdatedTime { get; set; }
}