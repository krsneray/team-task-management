using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.Entities;

public class ProjectMember
{
    public int Id { get; set; }

    public required int ProjectId { get; set; }
    public Project Project { get; set; } = default!;     // required kaldırıldı

    public required string UserId { get; set; }
    public ApplicationUser User { get; set; } = default!; // required kaldırıldı

    public ProjectRole MemberRole { get; set; }
    public DateTime JoinedDate { get; set; } = DateTime.UtcNow;
    public bool IsActive { get; set; } = true;
}