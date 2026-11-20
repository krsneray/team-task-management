using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using TeamTaskManager.DTO;
using TeamTaskManager.DTO.Common;
using TeamTaskManager.Entities;

namespace TeamTaskManager.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class UserController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _userManager;

    public UserController(UserManager<ApplicationUser> userManager)
    {
        _userManager = userManager;
    }

    [HttpGet]
    public async Task<ActionResult<List<UserResponseDto>>> GetUsers()
    {
        var users = await _userManager.Users
            .OrderBy(u => u.FirstName)
            .ThenBy(u => u.LastName)
            .ToListAsync();

        var result = new List<UserResponseDto>();

        foreach (var user in users)
        {
            var roles = await _userManager.GetRolesAsync(user);

            result.Add(new UserResponseDto
            {
                Id = user.Id,
                Email = user.Email ?? "",
                FullName = $"{user.FirstName} {user.LastName}",
                Roles = roles.ToList(),
                IsActive = user.IsActive
            });
        }

        return Ok(result);
    }

    [Authorize(Roles = "Admin")]
    [HttpPut("{id}/active")]
    public async Task<IActionResult> SetActive(string id, SetUserActiveDto dto)
    {
        var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        if (id == currentUserId && !dto.IsActive)
        {
            return BadRequest(new ApiErrorResponse
            {
                Title = "Hata",
                StatusCode = 400,
                Errors = new List<string> { "Kendi hesabınızı pasif yapamazsınız." }
            });
        }

        var user = await _userManager.FindByIdAsync(id);

        if (user == null)
        {
            return NotFound(new ApiErrorResponse
            {
                Title = "Bulunamadı",
                StatusCode = 404,
                Errors = new List<string> { "Kullanıcı bulunamadı." }
            });
        }

        user.IsActive = dto.IsActive;

        var result = await _userManager.UpdateAsync(user);

        if (!result.Succeeded)
        {
            return BadRequest(new ApiErrorResponse
            {
                Title = "Hata",
                StatusCode = 400,
                Errors = result.Errors.Select(e => e.Description).ToList()
            });
        }

        return NoContent();
    }
}
