using System.ComponentModel.DataAnnotations;
using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.DTO;

public class CreateTaskDto : IValidatableObject
{
    [Required(ErrorMessage = "Proje seçimi zorunludur.")]
    public int ProjectId { get; set; }

    [Required(ErrorMessage = "Görev başlığı zorunludur.")]
    [StringLength(200, ErrorMessage = "Başlık en fazla 200 karakter olabilir.")]
    public string Title { get; set; } = default!;

    [StringLength(2000, ErrorMessage = "Açıklama en fazla 2000 karakter olabilir.")]
    public string? Description { get; set; }

    [Required(ErrorMessage = "Sorumlu kullanıcı seçimi zorunludur.")]
    public string AssignedUserId { get; set; } = default!;

    public TaskPriority Priority { get; set; }

    public DateOnly? StartDate { get; set; }

    public DateOnly DueDate { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (DueDate < DateOnly.FromDateTime(DateTime.Today))
        {
            yield return new ValidationResult(
                "Bitiş tarihi geçmiş bir tarih olamaz.",
                new[] { nameof(DueDate) }
            );
        }

        if (StartDate.HasValue && StartDate.Value > DueDate)
        {
            yield return new ValidationResult(
                "Başlangıç tarihi, bitiş tarihinden sonra olamaz.",
                new[] { nameof(StartDate) }
            );
        }
    }
}