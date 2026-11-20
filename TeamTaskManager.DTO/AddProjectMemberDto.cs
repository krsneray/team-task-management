using System.ComponentModel.DataAnnotations;

namespace TeamTaskManager.DTO;

public class AddProjectMemberDto
{
    [Required(ErrorMessage = "Kullanıcı seçilmelidir.")]
    public string UserId { get; set; } = default!;
}
