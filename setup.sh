#!/bin/bash

# Clear any existing work and reset to just the setup script
echo "=== Cleaning up existing branches and commits ==="

# Store current branch
CURRENT_BRANCH=$(git branch --show-current)

# If we're not on main, checkout main first
if [ "$CURRENT_BRANCH" != "main" ]; then
    git checkout main 2>/dev/null || git checkout -b main
fi

# Delete all branches except main
git branch | grep -v "main" | xargs -r git branch -D 2>/dev/null

# Reset main to just have this setup script
git reset --hard HEAD~$(git rev-list --count HEAD ^$(git rev-list --max-parents=0 HEAD) 2>/dev/null || echo 0) 2>/dev/null || true
git clean -fd

# Now create the stacked PR structure
echo "=== Creating stacked PR demo ==="

# Initial commit on main (if README doesn't exist)
if [ ! -f "README.md" ]; then
    echo "# Application README" > README.md
    echo "Basic application setup" >> README.md
    echo "Version: 0.0.1" >> README.md
    git add README.md
    git commit -m "Initial commit"
    sleep 1.5
fi

# Branch app-v1 from main
echo "Creating app-v1..."
git checkout -b app-v1
sed -i.bak 's/Version: 0.0.1/Version: 1.0.0/' README.md
echo "" >> README.md
echo "## Version 1.0" >> README.md
echo "- Added configuration system" >> README.md
git add README.md
git commit -m "v1: Update README version to 1.0.0"
sleep 1.5

echo "# Database Configuration" > config.txt
echo "database_host=localhost" >> config.txt
echo "database_port=5432" >> config.txt
echo "database_name=app_db" >> config.txt
echo "database_user=admin" >> config.txt
git add config.txt
git commit -m "v1: Add database configuration"
sleep 1.5

# Branch app-v2 from app-v1
echo "Creating app-v2..."
git checkout -b app-v2
sed -i.bak 's/Version: 1.0.0/Version: 2.0.0/' README.md
git add README.md
git commit -m "v2: Bump version to 2.0.0"
sleep 1.5

sed -i.bak 's/database_port=5432/database_port=3306/' config.txt
echo "" >> config.txt
echo "# Cache Configuration" >> config.txt
echo "cache_enabled=true" >> config.txt
echo "cache_ttl=3600" >> config.txt
git add config.txt
git commit -m "v2: Change DB port and add cache config"
sleep 1.5

echo "class Feature" > feature.rb
echo "  def initialize" >> feature.rb
echo "    @enabled = true" >> feature.rb
echo "    @version = 2" >> feature.rb
echo "  end" >> feature.rb
echo "end" >> feature.rb
git add feature.rb
git commit -m "v2: Add feature class"
sleep 1.5

# Branch app-v3 from app-v2
echo "Creating app-v3..."
git checkout -b app-v3
sed -i.bak 's/Version: 2.0.0/Version: 3.0.0/' README.md
git add README.md
git commit -m "v3: Bump version to 3.0.0"
sleep 1.5

sed -i.bak 's/database_host=localhost/database_host=db.production.local/' config.txt
sed -i.bak 's/database_port=3306/database_port=5433/' config.txt
sed -i.bak 's/database_name=app_db/database_name=prod_app/' config.txt
sed -i.bak 's/cache_ttl=3600/cache_ttl=7200/' config.txt
git add config.txt
git commit -m "v3: Update config for production environment"
sleep 1.5

sed -i.bak 's/@version = 2/@version = 3/' feature.rb
sed -i.bak '/^end$/i\
\
  def process\
    puts "Processing v3"\
  end' feature.rb
git add feature.rb
git commit -m "v3: Add process method to feature"
sleep 1.5

# Branch app-v4 from app-v3
echo "Creating app-v4..."
git checkout -b app-v4
sed -i.bak 's/Version: 3.0.0/Version: 4.0.0/' README.md
echo "- Optimized for production" >> README.md
git add README.md
git commit -m "v4: Bump version to 4.0.0"
sleep 1.5

sed -i.bak 's/@version = 3/@version = 4/' feature.rb
sed -i.bak '/@enabled = true/a\
    @optimized = true' feature.rb
sed -i.bak 's/puts "Processing v3"/puts "Processing v4 with optimization"/' feature.rb
git add feature.rb
git commit -m "v4: Optimize feature processing"
sleep 1.5

echo "#!/bin/bash" > deploy.sh
echo "echo 'Deploying application v4'" >> deploy.sh
echo "git push origin app-v4" >> deploy.sh
chmod +x deploy.sh
git add deploy.sh
git commit -m "v4: Add deployment script"
sleep 1.5

git checkout main
sed -i.bak 's/README/README.md/' README.md
git add README.md
git commit -m "main: last change to README.md"


# Clean up backup files
rm -f *.bak

# Show the branch structure
echo ""
echo "=== Branch Structure Created ==="
git log --graph --pretty=oneline --abbrev-commit --all

echo ""
echo "=== Current branches ==="
git branch

echo ""
echo "=== Summary ==="
echo "Created 4 stacked branches:"
echo "  main -> app-v1 -> app-v2 -> app-v3 -> app-v4"
echo ""
echo "Try these commands to explore:"
echo "  git checkout app-v1"
echo "  git rebase main app-v2  # After merging v1 to main"
echo "  git diff app-v1..app-v2"
echo "  git log --graph --oneline --all"
