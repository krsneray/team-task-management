using System.ComponentModel.DataAnnotations;

namespace TeamTaskManager.DTO.Auth;

public class LoginRequestDto
{
    [Required(ErrorMessage = "E-posta zorunludur.")]
    [EmailAddress(ErrorMessage = "Geçerli bir e-posta adresi giriniz.")]
    public required string Email { get; set; }

    [Required(ErrorMessage = "Şifre zorunludur.")]
    public required string Password { get; set; }
}