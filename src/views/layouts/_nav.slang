nav.nav
  - active = context.request.path == "/" || context.request.path =~ /^\/quiz/ ? "active" : ""
  a class="nav-item #{active}" href="/" Quiz
  - active = context.request.path == "/kanji" ? "active" : ""
  a class="nav-item #{active}" href="/kanji" 漢字
  - active = context.request.path == "/cards" ? "active" : ""
  a class="nav-item #{active}" href="/cards" Cards
  - active = context.request.path == "/progress" ? "active" : ""
  a class="nav-item #{active}"  href="/progress" Progress
  a.nav-item href="/cards.tsv?download=true" 暗記
