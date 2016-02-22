###
# Page options, layouts, aliases and proxies
###
#set :layout, :article

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false


set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :with_toc_data => true
set :markdown_engine, :redcarpet

activate :external_pipeline,
  name: :webpack,
  command: build? ? './node_modules/webpack/bin/webpack.js --bail' : './node_modules/webpack/bin/webpack.js --watch -d',
  source: ".tmp/dist",
  latency: 1

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do

  # "Ignore" JS so webpack has full control.
  ignore { |path| path =~ /\/(.*)\.js$/ && $1 != 'site' }

  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  set :http_prefix, '/portal'
end

activate :blog do |blog|
  blog.permalink = "blog/{year}-{month}-{day}-{title}.html"
  blog.sources = "blog/{year}-{month}-{day}-{title}.html"
  blog.layout = "blog_layout"
end

activate :deploy do |deploy|
  deploy.build_before = true # runs build before deploying
  deploy.deploy_method = :git
  deploy.remote = 'pages'
  deploy.branch = 'master'
end

helpers do
  def active_link_to(caption, url, options = {})
    if current_page.url == "#{url}/"
      options[:class] = "doc-item-active"
    end

    link_to(caption, url, options)
  end

  def sub_pages(dir)
    sitemap.resources.select do |resource|
      File.dirname(resource.path).start_with?(dir)
      #resource.path.start_with?(dir)
    end
  end
end
