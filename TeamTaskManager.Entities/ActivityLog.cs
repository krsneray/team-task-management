
namespace TeamTaskManager.Entities;

public class ActivityLog
{
    public long Id { get; set; }

    public string UserId { get; set; } = default!;
    public ApplicationUser User { get; set; } = default!;

    public string EntityType { get; set; } = default!; 
    public int EntityId { get; set; }
    public string Action { get; set; } = default!;       
    public string Description { get; set; } = default!;

    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
}