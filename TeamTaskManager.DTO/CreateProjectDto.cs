using System.ComponentModel.DataAnnotations;

namespace TeamTaskManager.DTO;

public class CreateProjectDto : IValidatableObject
{
    [Required(ErrorMessage = "Proje adı zorunludur.")]
    [StringLength(150, ErrorMessage = "Proje adı en fazla 150 karakter olabilir.")]
    public string Name { get; set; } = default!;

    [StringLength(1000, ErrorMessage = "Açıklama en fazla 1000 karakter olabilir.")]
    public string? Description { get; set; }

    public DateOnly StartDate { get; set; }

    public DateOnly TargetEndDate { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (TargetEndDate <= StartDate)
        {
            yield return new ValidationResult(
                "Bitiş tarihi, başlangıç tarihinden sonra olmalıdır.",
                new[] { nameof(TargetEndDate) }
            );
        }
    }
}