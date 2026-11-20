import { z } from 'zod'

const dateString = (message: string) => z.string().min(1, message).regex(/^\d{4}-\d{2}-\d{2}$/, message)

export const loginSchema = z.object({
  email: z.string().trim().min(1, 'E-posta zorunludur.').email('Geçerli bir e-posta adresi giriniz.'),
  password: z.string().min(1, 'Şifre zorunludur.'),
})
export type LoginValues = z.infer<typeof loginSchema>

export const projectSchema = z
  .object({
    name: z
      .string()
      .trim()
      .min(3, 'Proje adı en az 3 karakter olmalıdır.')
      .max(150, 'Proje adı en fazla 150 karakter olabilir.'),
    description: z.string().trim().max(1000, 'Açıklama en fazla 1000 karakter olabilir.').optional(),
    startDate: dateString('Başlangıç tarihi zorunludur.'),
    targetEndDate: dateString('Hedef bitiş tarihi zorunludur.'),
  })
  .refine((v) => !v.startDate || !v.targetEndDate || v.targetEndDate >= v.startDate, {
    path: ['targetEndDate'],
    message: 'Hedef bitiş tarihi başlangıç tarihinden önce olamaz.',
  })
export type ProjectValues = z.infer<typeof projectSchema>

export const taskSchema = z
  .object({
    projectId: z.number({ invalid_type_error: 'Proje seçiniz.' }).int().positive('Proje seçiniz.'),
    title: z
      .string()
      .trim()
      .min(3, 'Görev başlığı en az 3 karakter olmalıdır.')
      .max(200, 'Görev başlığı en fazla 200 karakter olabilir.'),
    description: z.string().trim().max(2000, 'Açıklama en fazla 2000 karakter olabilir.').optional(),
    assignedUserId: z.string().min(1, 'Görevin atanacağı kişiyi seçiniz.'),
    priority: z.number().int().min(0).max(3),
    status: z.number().int().min(0).max(4),
    startDate: z.string().regex(/^(\d{4}-\d{2}-\d{2})?$/, 'Geçerli bir tarih giriniz.').optional(),
    dueDate: dateString('Bitiş tarihi zorunludur.'),
  })
  .refine((v) => !v.startDate || v.dueDate >= v.startDate, {
    path: ['dueDate'],
    message: 'Bitiş tarihi başlangıç tarihinden önce olamaz.',
  })
export type TaskValues = z.infer<typeof taskSchema>

export const commentSchema = z.object({
  content: z
    .string()
    .trim()
    .min(1, 'Yorum boş olamaz.')
    .max(2000, 'Yorum en fazla 2000 karakter olabilir.'),
})
export type CommentValues = z.infer<typeof commentSchema>

export const registerSchema = z.object({
  firstName: z.string().trim().min(2, 'Ad en az 2 karakter olmalıdır.').max(50, 'Ad en fazla 50 karakter olabilir.'),
  lastName: z.string().trim().min(2, 'Soyad en az 2 karakter olmalıdır.').max(50, 'Soyad en fazla 50 karakter olabilir.'),
  email: z.string().trim().min(1, 'E-posta zorunludur.').email('Geçerli bir e-posta adresi giriniz.'),
  password: z.string().min(8, 'Şifre en az 8 karakter olmalıdır.').max(100, 'Şifre en fazla 100 karakter olabilir.'),
})
export type RegisterValues = z.infer<typeof registerSchema>

export const ALLOWED_UPLOAD_EXTENSIONS = [
  '.pdf', '.png', '.jpg', '.jpeg', '.gif', '.txt', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.zip',
]
export const MAX_UPLOAD_BYTES = 10 * 1024 * 1024

/** Dosya yüklemeden önce sunucudakiyle aynı kuralları denetler. Hata varsa mesaj döndürür. */
export function validateUpload(file: { name: string; size: number }): string | null {
  const dot = file.name.lastIndexOf('.')
  const ext = dot >= 0 ? file.name.slice(dot).toLowerCase() : ''
  if (!ALLOWED_UPLOAD_EXTENSIONS.includes(ext)) return 'Bu dosya türüne izin verilmiyor.'
  if (file.size === 0) return 'Dosya boş.'
  if (file.size > MAX_UPLOAD_BYTES) return 'Dosya boyutu en fazla 10 MB olabilir.'
  return null
}
