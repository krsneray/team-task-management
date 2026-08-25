namespace TeamTaskManager.DTO;

public class CreateProjectDto
{
    public string Name { get; set; } = default!;

    public string? Description { get; set; }

    public DateOnly StartDate { get; set; }

    public DateOnly TargetEndDate { get; set; }
}