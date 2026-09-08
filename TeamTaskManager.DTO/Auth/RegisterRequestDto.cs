using System.ComponentModel.DataAnnotations;

namespace TeamTaskManager.DTO.Auth;

public class RegisterRequestDto
{
    [Required(ErrorMessage = "Ad zorunludur.")]
    [StringLength(50)]
    public required string FirstName { get; set; }

    [Required(ErrorMessage = "Soyad zorunludur.")]
    [StringLength(50)]
    public required string LastName { get; set; }

    [Required(ErrorMessage = "E-posta zorunludur.")]
    [EmailAddress(ErrorMessage = "Geçerli bir e-posta adresi giriniz.")]
    public required string Email { get; set; }

    [Required(ErrorMessage = "Şifre zorunludur.")]
    [StringLength(100, MinimumLength = 6, ErrorMessage = "Şifre en az 6 karakter olmalıdır.")]
    public required string Password { get; set; }
}