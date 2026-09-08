using System.ComponentModel.DataAnnotations;

namespace TeamTaskManager.DTO
{
    public class CreateTaskCommentDto
    {
        [Required(ErrorMessage = "Görev seçimi zorunludur.")]
        public int TaskItemId { get; set; }

        [Required(ErrorMessage = "Yorum içeriği boş olamaz.")]
        [StringLength(1500, ErrorMessage = "Yorum en fazla 1500 karakter olabilir.")]
        public string Content { get; set; } = default!;
    }
}