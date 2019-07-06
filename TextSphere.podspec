Pod::Spec.new do |spec|

  spec.name         = "TextSphere"
  spec.version      = "1.0"
  spec.summary      = "TextSphere is a small framework for customized TextView"

  spec.homepage     = "https://nscolak.com/"

  spec.license      = "MIT"

  spec.author             = { "CAGRI COLAK" => "work@cagricolak.com.tr" }
  spec.social_media_url   = "https://twitter.com/cgcolak"
  spec.platform     = :ios, "9.0"
  spec.swift_version       = "4.2"
  spec.source       = { :git => "https://github.com/cagricolak/TextSphere.git", :tag => "#{spec.version}" }
  spec.source_files  = "TextSphere.swift"

end
