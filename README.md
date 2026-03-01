# Eventya Publisher

A production-grade **B2B publishing and advertisement platform** built with Ruby on Rails, designed for managing classified ads through a structured workflow with payments, OCR document processing, and analytics.

The platform enables users to create, manage, publish, and monetize advertisements (notices) through configurable multi-stage workflows. It supports multiple user roles, organization management with hierarchical permissions, and a dynamic pricing model based on content length.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Testing](#testing)
- [Background Jobs](#background-jobs)
- [OCR Document Processing](#ocr-document-processing)
- [Payment Integration](#payment-integration)
- [Database Views](#database-views)
- [Project Structure](#project-structure)
- [Useful Commands](#useful-commands)

---

## Features

### Notice Management & Workflow
- Multi-stage notice lifecycle: **Draft > Sent > Revised (Published)**
- Dynamic form generation based on configurable ad types and fields
- Support for multiple field types: text, date, time, CPV codes, file uploads, dropdowns
- Rich text descriptions via Action Text
- Notice assignment, validation, and publishing actions
- Comments and ratings system

### OCR & Document Processing
- Asynchronous OCR via **Google Cloud Vision** with Sidekiq background jobs
- Multi-page PDF support with automatic page-count detection
- Google Cloud Storage integration for OCR input/output buckets
- Automatic text extraction stored in the database

### Payments & Pricing
- **Stripe** embedded checkout with webhook processing
- Character-based dynamic pricing engine
- Free tier: first 3 notices per user per month at no charge
- Admin bypass for unlimited free publishing

### User & Organization Management
- Multi-role system: person, company, employee, collaborator
- Organization management with fiscal code validation
- Granular permissions (validate ads, manage users, etc.)
- User invitation workflow via Devise Invitable
- Google OAuth2 social login
- Admin masquerade for user experience testing
- Encrypted PII storage (personal documents, passport numbers) via Lockbox

### Analytics & Reporting
- Interactive dashboards with Chartkick
- Revenue tracking by category
- User registration trends
- Notice status distributions and average ratings
- Date range filtering with custom periods

### Notifications
- Multi-channel notifications (database + email) via Noticed
- Notice validation, comment, and update alerts
- Smart delivery with duplicate prevention

### Audit & Compliance
- Complete audit trail on all critical models via Audited
- JSONB-based change logging with user attribution
- GDPR-compliant encrypted storage for personal data

---

## Tech Stack

| Layer              | Technology                                       |
|--------------------|--------------------------------------------------|
| **Framework**      | Ruby on Rails 6.1.4                              |
| **Language**       | Ruby 2.7.6                                       |
| **Database**       | PostgreSQL                                        |
| **Cache / Queue**  | Redis                                             |
| **Background Jobs**| Sidekiq 6.2                                       |
| **Web Server**     | Puma 6                                            |
| **Frontend**       | Bootstrap 5, Hotwire (Turbo + Stimulus)           |
| **JS Bundler**     | Webpacker 5                                       |
| **Payments**       | Stripe                                            |
| **OCR**            | Google Cloud Vision V1                            |
| **File Storage**   | Google Cloud Storage + Active Storage             |
| **Authentication** | Devise + OmniAuth (Google OAuth2)                 |
| **Encryption**     | Lockbox                                           |
| **Notifications**  | Noticed                                           |
| **Audit Trail**    | Audited                                           |
| **Charts**         | Chartkick + Chart.js + Groupdate                  |
| **Pagination**     | Pagy                                              |
| **Locale**         | Romanian (ro)                                     |
| **Timezone**       | Europe/Bucharest                                  |

---

## Prerequisites

- **Ruby** 2.7.6
- **Node.js** (for Webpacker/Yarn)
- **Yarn** (JavaScript dependency management)
- **PostgreSQL** (>= 12 recommended)
- **Redis** (for Sidekiq and ActionCable)
- **Google Cloud** credentials (for Cloud Vision OCR and Cloud Storage)
- **Stripe** account and API keys (for payment processing)

---

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd publisher
```

### 2. Run the setup script

```bash
bin/setup
```

This will:
- Install Ruby dependencies (`bundle install`)
- Install JavaScript dependencies (`yarn install`)
- Prepare the database (`rails db:prepare`)
- Clear logs and temp files
- Restart the application server

### 3. Manual setup (alternative)

```bash
bundle install
yarn install
rails db:create
rails db:migrate
rails db:seed
```

### 4. Set up credentials

Configure your Rails credentials with the required keys:

```bash
bin/rails credentials:edit
```

Required credential keys:
- `stripe.secret_key` / `stripe.publishable_key` / `stripe.webhook_secret`
- `google_oauth.client_id` / `google_oauth.client_secret`
- Google Cloud service account credentials for Vision API and Cloud Storage

---

## Configuration

### Environment Variables

| Variable              | Description                              |
|-----------------------|------------------------------------------|
| `RAILS_MAX_THREADS`  | Puma thread count (default: 5)           |
| `PORT`               | Server port (default: 3000)              |
| `REDIS_URL`          | Redis connection URL                     |
| `RAILS_MASTER_KEY`   | Master key for credentials decryption    |

### Google Cloud Storage (Development)

OCR for PDF and TIFF files requires files stored in a Google Cloud Storage bucket, even in development mode.

To enable CORS for local development, create a `cors.json` configuration and apply it using `gsutil`:

```bash
gsutil cors set cors.json gs://your-bucket-name
```

Reference: [Rails ActiveStorage GCS CORS](https://github.com/rails/rails/issues/40852)

---

## Running the Application

### Using Foreman (recommended)

```bash
foreman start -f Procfile.dev
```

This starts all processes concurrently:
- **Web server** — `rails server` on port 3000
- **Sidekiq worker** — background job processing
- **Webpack dev server** — JavaScript asset compilation with hot reload

### Running processes individually

```bash
# Terminal 1 — Web server
bin/rails server

# Terminal 2 — Sidekiq
bundle exec sidekiq

# Terminal 3 — Webpack dev server
bin/webpack-dev-server
```

---

## Testing

```bash
# Run the full test suite
bin/rails test

# Run a specific test file
bin/rails test test/models/notice_test.rb

# Run tests with verbose output
bin/rails test -v
```

### Code Quality

```bash
# Linting
bin/rubocop

# Security scan
bin/brakeman
```

---

## Background Jobs

Sidekiq processes background jobs including:
- **OcrJob** — Asynchronous OCR processing via Google Cloud Vision
- **Notification delivery** — Email and database notifications
- **View refresh** — Materialized view updates

### Monitoring

Sidekiq Web UI is available at `/sidekiq` for admin users.

### Clearing Jobs

```ruby
# In Rails console
require 'sidekiq/api'

Sidekiq::RetrySet.new.clear      # Clear retry set
Sidekiq::ScheduledSet.new.clear  # Clear scheduled jobs
Sidekiq::DeadSet.new.clear       # Clear dead jobs
Sidekiq::Stats.new.reset         # Reset statistics

# Clear a specific queue
queue = Sidekiq::Queue.new('default')
queue.clear
```

---

## OCR Document Processing

The OCR pipeline processes uploaded documents through Google Cloud Vision:

1. Document is uploaded and stored in Google Cloud Storage
2. PDF metadata (page count) is extracted via `pdf-reader`
3. `OcrJob` sends the document to the Vision API asynchronously
4. Multi-page PDFs are processed in batches (10 pages per batch)
5. OCR results are retrieved from the output bucket and stored in the database

**GCS Buckets:**
- Input: `files-for-ocr`
- Output: `files-ocr-results`

---

## Payment Integration

Stripe handles payment processing for notice publishing:

- **Embedded Checkout** — Stripe Checkout Sessions with embedded UI mode
- **Webhooks** — Processes `charge.updated` events with signature validation
- **Development mode** — Simulated payment success for local testing

Webhook endpoint: `POST /webhooks`

---

## Database Views

The application uses [Scenic](https://github.com/scenic-views/scenic) for PostgreSQL materialized views that optimize analytical queries:

| View                               | Purpose                                         |
|------------------------------------|--------------------------------------------------|
| `views_price_earnings`             | Revenue aggregation by category                  |
| `views_search_notices`             | Denormalized notice data for full-text search    |
| `views_notices_by_dates`           | Notices indexed by date field values             |
| `views_average_ratings_of_notices` | Pre-calculated average ratings by ad type        |

Views are automatically refreshed via `after_commit` hooks on notice creation.

---

## Project Structure

```
app/
├── controllers/
│   ├── admin/          # Admin namespace (audits)
│   ├── auth/           # Custom Devise controllers
│   ├── notices_controller.rb
│   ├── reports_controller.rb
│   ├── stripe_checkouts_controller.rb
│   └── webhooks_controller.rb
├── jobs/
│   └── ocr_job.rb      # Async OCR processing
├── models/
│   ├── views/          # Materialized view models
│   ├── notice.rb       # Core business model
│   ├── ad_type.rb      # Dynamic form configuration
│   └── organization.rb # Multi-tenant organizations
├── notifications/      # Noticed notification classes
├── services/
│   └── ocr/            # OCR service objects
└── views/
    └── ...             # ERB templates with Turbo Streams

db/
├── migrate/            # Database migrations
├── views/              # Scenic SQL view definitions
└── schema.rb           # Database schema

config/
├── routes.rb           # Application routes
├── locales/            # Romanian (ro) translations
└── ...
```

---

## Useful Commands

```bash
# Start the application
foreman start -f Procfile.dev

# Rails console
bin/rails console

# Database operations
bin/rails db:migrate
bin/rails db:seed
bin/rails db:rollback

# Generate ERD diagram
bin/rails erd

# Test ActionMailbox locally
# Visit: http://localhost:3000/rails/conductor/action_mailbox/inbound_emails/

# Restart in production
passenger-config restart-app
```

---

## License

All rights reserved. This is proprietary software.