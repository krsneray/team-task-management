using System.ComponentModel.DataAnnotations;
using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.DTO;

public class UpdateTaskDto : IValidatableObject
{
    [Required(ErrorMessage = "Görev başlığı zorunludur.")]
    [StringLength(200, ErrorMessage = "Başlık en fazla 200 karakter olabilir.")]
    public string Title { get; set; } = default!;

    [StringLength(2000, ErrorMessage = "Açıklama en fazla 2000 karakter olabilir.")]
    public string? Description { get; set; }

    [Required(ErrorMessage = "Sorumlu kullanıcı seçimi zorunludur.")]
    public string AssignedUserId { get; set; } = default!;

    public TaskPriority Priority { get; set; }

    public ProjectTaskStatus Status { get; set; }

    public DateOnly? StartDate { get; set; }

    public DateOnly DueDate { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (StartDate.HasValue && StartDate.Value > DueDate)
        {
            yield return new ValidationResult(
                "Başlangıç tarihi, bitiş tarihinden sonra olamaz.",
                new[] { nameof(StartDate) }
            );
        }
    }
}