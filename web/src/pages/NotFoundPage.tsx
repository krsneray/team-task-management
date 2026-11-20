import { Link } from 'react-router-dom'
import { EmptyState } from '../components/ui'

export function NotFoundPage() {
  return (
    <EmptyState
      title="Sayfa bulunamadı"
      description="Aradığınız sayfa mevcut değil ya da taşınmış olabilir."
      action={
        <Link to="/" className="text-sm font-medium text-primary hover:underline">
          Ana sayfaya dön
        </Link>
      }
    />
  )
}
