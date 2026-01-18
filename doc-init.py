import os

# 마크다운 렌더링 깨짐 방지를 위한 백틱 플레이스홀더
# 스크립트 실행 시 실제 백틱(```)으로 자동 변환됩니다.
BT = "```"

files = {
    "README.md": f"""# [Project Name]

[One-line description of the project]

## Features

- **Feature 1**: Description
- **Feature 2**: Description
- **Feature 3**: Description

## Tech Stack

- **Frontend**: [e.g., React, Vue]
- **Backend**: [e.g., Node.js, Python]
- **Database**: [e.g., PostgreSQL, MongoDB]
- **Infrastructure**: [e.g., Docker, AWS]

## Quick Start

### Development

{BT}bash
# Install dependencies
npm install

# Start development server
npm run dev
{BT}

| Service  | URL                       |
|----------|---------------------------|
| Frontend | `http://localhost:5173`   |
| API      | `http://localhost:3000`   |

### Production (Docker)

{BT}bash
# Build and start containers
docker-compose up -d --build
{BT}

## Scripts

| Script | Purpose |
|--------|---------|
| `npm run dev` | Start development environment |
| `npm run build` | Build for production |
| `npm run start` | Start production server |
| `npm run lint` | Run code linting |

## Project Structure

{BT}text
root/
├── src/                    # Frontend source code
├── backend/                # Backend source code
├── docs/                   # Documentation
└── public/                 # Static assets
{BT}

## Documentation Links

- [Frontend Architecture](./docs/structure/FRONTEND_STRUCTURE.md)
- [Backend Architecture](./docs/structure/BACKEND_STRUCTURE.md)

## License

MIT License
""",

    "docs/structure/FRONTEND_STRUCTURE.md": f"""# Frontend Structure

Last Updated: YYYY-MM-DD

## Technology Stack

| Category   | Technology          |
|------------|---------------------|
| Framework  | [e.g. React 18]     |
| Build Tool | [e.g. Vite]         |
| State      | [e.g. Zustand/Redux]|
| Styling    | [e.g. Tailwind CSS] |
| Routing    | [e.g. React Router] |

## Project Structure

{BT}text
src/
├── app/                   # App setup (router, providers)
├── api/                   # API integration logic
├── assets/                # Static files (images, fonts)
├── components/            # Shared UI components
│   ├── common/            # Buttons, Inputs, etc.
│   └── layout/            # Header, Footer, Sidebar
├── features/              # Feature-based modules
│   └── [FeatureName]/
│       ├── components/    # Feature-specific UI
│       └── hooks/         # Feature-specific logic
├── hooks/                 # Shared custom hooks
├── lib/                   # Utility libraries & helpers
├── store/                 # Global state management
└── types/                 # TypeScript definitions
{BT}

## Key Components

### [MainComponent Name]
- **Role**: [Description of role]
- **State**: [Key state managed]
- **Interactions**: [Key user interactions]

### [SecondaryComponent Name]
- **Role**: [Description of role]

## Data Flow Architecture

{BT}text
[Input/Event] -> [Action/Handler] -> [State Update] -> [UI Render]
{BT}

1. **Trigger**: User performs action X.
2. **Process**: Data is validated and sent to API via `api/`.
3. **State**: Global store updates status (loading -> success).
4. **Update**: UI reflects the new data.

## Routes

| Path        | Component      | Description      |
|-------------|----------------|------------------|
| `/`         | Home           | Main landing page|
| `/dashboard`| Dashboard      | User dashboard   |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `VITE_API_URL` | Backend API Base URL |
""",

    "docs/structure/BACKEND_STRUCTURE.md": f"""# Backend Structure

Last Updated: YYYY-MM-DD

## Technology Stack

| Category    | Technology           |
|-------------|----------------------|
| Framework   | [e.g. Express/NestJS]|
| Database    | [e.g. PostgreSQL]    |
| ORM         | [e.g. Prisma/Drizzle]|
| Auth        | [e.g. JWT/OAuth]     |

## Project Structure

{BT}text
backend/
├── src/
│   ├── config/            # Environment config
│   ├── controllers/       # Request handlers
│   ├── db/                # Database connection & schema
│   ├── middlewares/       # Express middlewares
│   ├── routes/            # API route definitions
│   ├── services/          # Business logic
│   └── utils/             # Helper functions
└── test/                  # Test files
{BT}

## API Endpoints

### [Resource Name] API

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/api/resource` | Get list of resources |
| POST   | `/api/resource` | Create new resource |
| GET    | `/api/resource/:id` | Get detail |

## Database Schema

### [Table Name]

| Column | Type | Description |
|--------|------|-------------|
| `id`   | UUID | Primary Key |
| `name` | VARCHAR | User name |
| `created_at` | TIMESTAMP | Creation time |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | 3000 | Server port |
| `DATABASE_URL` | - | DB Connection String |

## Error Handling

- **400**: Bad Request (Validation Error)
- **401**: Unauthorized
- **404**: Not Found
- **500**: Internal Server Error
""",

    "docs/AI_MAINTENANCE_PROMPT.md": """# Documentation Update Protocol

You are the documentation maintainer for this project. The project maintains three key structure files:
1. `README.md` (General overview)
2. `FRONTEND_STRUCTURE.md` (Frontend details)
3. `BACKEND_STRUCTURE.md` (Backend details)

**YOUR TASK:**
Based on the code changes and refactoring I have just requested (or the current state of the codebase), please review and update these three documentation files.

**CHECKLIST:**
1. **Sync Project Structure:** If I added, moved, or deleted files, update the ASCII tree structure in the corresponding file.
2. **Update Tech Stack:** If `package.json` changed (new libraries), update the Tech Stack table.
3. **Reflect API Changes:** If backend routes changed, update the 'API Endpoints' table in `BACKEND_STRUCTURE.md`.
4. **Reflect Component Changes:** If major frontend components were created/renamed, update 'Key Components' in `FRONTEND_STRUCTURE.md`.
5. **Database Schema:** If the DB schema (e.g., Prisma/Drizzle) changed, update the Schema section.
6. **Date:** Update the "Last Updated" date at the top of the file.

**IMPORTANT:**
- Do not rewrite the entire file. Only update sections that have changed.
- Keep the existing formatting (Tables, Code blocks) strictly.
- If no changes are needed for a specific file, state "No changes required for [Filename]".

Please verify the current codebase and provide the updated content for the necessary files.
"""
}

def create_files():
    # 현재 위치 출력
    current_dir = os.getcwd()
    print(f"Creating documentation files in: {current_dir}")

    for file_path, content in files.items():
        # 디렉토리 경로 추출
        dir_path = os.path.dirname(file_path)
        
        # 디렉토리가 있고 존재하지 않으면 생성
        if dir_path and not os.path.exists(dir_path):
            os.makedirs(dir_path)
            print(f"Created directory: {dir_path}")
            
        # 파일 쓰기
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(content.strip())
        
        print(f"Created file: {file_path}")

    print("\\n✅ All documentation templates generated successfully!")

if __name__ == "__main__":
    create_files()