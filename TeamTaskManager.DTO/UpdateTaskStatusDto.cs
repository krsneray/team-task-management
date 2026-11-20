using System.ComponentModel.DataAnnotations;
using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.DTO;

public class UpdateTaskStatusDto
{
    [EnumDataType(typeof(ProjectTaskStatus), ErrorMessage = "Geçersiz görev durumu.")]
    public ProjectTaskStatus Status { get; set; }
}
