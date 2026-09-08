using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using TeamTaskManager.Business;
using TeamTaskManager.DTO.Auth;
using TeamTaskManager.DTO.Common;
using TeamTaskManager.Entities;

namespace TeamTaskManager.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly JwtTokenService _jwtTokenService;

    public AuthController(UserManager<ApplicationUser> userManager, JwtTokenService jwtTokenService)
    {
        _userManager = userManager;
        _jwtTokenService = jwtTokenService;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterRequestDto request)
    {
        var existingUser = await _userManager.FindByEmailAsync(request.Email);
        if (existingUser != null)
        {
            return BadRequest(new ApiErrorResponse { Title = "Kayıt Hatası", StatusCode = 400, Errors = new List<string> { "Bu e-posta adresi zaten kayıtlı." } });
        }

        var user = new ApplicationUser
        {
            FirstName = request.FirstName,
            LastName = request.LastName,
            Email = request.Email,
            UserName = request.Email
        };

        var result = await _userManager.CreateAsync(user, request.Password);

        if (!result.Succeeded)
        {
            var errors = result.Errors.Select(e => e.Description).ToList();
            return BadRequest(new ApiErrorResponse { Title = "Kayıt Hatası", StatusCode = 400, Errors = errors });
        }

        await _userManager.AddToRoleAsync(user, "TeamMember");

        return Ok(new { Message = "Kayıt başarılı." });
    }

    [HttpPost("login")]
    public async Task<ActionResult<AuthResponseDto>> Login(LoginRequestDto request)
    {
        var user = await _userManager.FindByEmailAsync(request.Email);
        if (user == null)
        {
            return BadRequest(new ApiErrorResponse { Title = "Giriş Hatası", StatusCode = 400, Errors = new List<string> { "E-posta veya şifre hatalı." } });
        }

        var passwordValid = await _userManager.CheckPasswordAsync(user, request.Password);
        if (passwordValid == false)
        {
            return BadRequest(new ApiErrorResponse { Title = "Giriş Hatası", StatusCode = 400, Errors = new List<string> { "E-posta veya şifre hatalı." } });
        }

        var roles = await _userManager.GetRolesAsync(user);
        var (token, expiresAt) = _jwtTokenService.GenerateToken(user, roles);

        return Ok(new AuthResponseDto
        {
            Token = token,
            Email = user.Email!,
            FullName = $"{user.FirstName} {user.LastName}",
            Roles = roles,
            ExpiresAt = expiresAt
        });
    }

    [Authorize(Roles = "Admin")]
    [HttpPost("assign-role")] 
    public async Task<IActionResult> AssignRole(AssignRoleRequestDto request)
    {
        var validRoles = new[] { "Admin", "ProjectManager", "TeamMember" };
        if (!validRoles.Contains(request.Role))
        {
            return BadRequest(new ApiErrorResponse { Title = "Geçersiz Rol", StatusCode = 400, Errors = new List<string> { "Geçersiz rol. Geçerli roller: Admin, ProjectManager, TeamMember" } });
        }

        var user = await _userManager.FindByEmailAsync(request.UserEmail);
        if (user == null)
        {
            return NotFound(new ApiErrorResponse { Title = "Kullanıcı Bulunamadı", StatusCode = 404, Errors = new List<string> { "Kullanıcı bulunamadı." } });
        }

        var alreadyInRole = await _userManager.IsInRoleAsync(user, request.Role);
        if (alreadyInRole)
        {
            return BadRequest(new ApiErrorResponse { Title = "Rol Atama Hatası", StatusCode = 400, Errors = new List<string> { "Kullanıcıya bu rol zaten atanmış." } });
        }

        var result = await _userManager.AddToRoleAsync(user, request.Role);
        if (!result.Succeeded)
        {
            var errors = result.Errors.Select(e => e.Description).ToList();
            return BadRequest(new ApiErrorResponse { Title = "Rol Atama Hatası", StatusCode = 400, Errors = errors });
        }

        return Ok(new { Message = $"{user.Email} kullanıcısına {request.Role} rolü atandı." });
    }
}