variable "REPO" {
  default = "hominsu"
}

variable "AUTHOR_NAME" {
  default = "Homing So"
}

variable "AUTHOR_EMAIL" {
  default = "hominsu@foxmail.com"
}

variable "VERSION" {
  default = ""
}

group "default" {
  targets = [
    "moses-base",
    "moses-devel",
    "moses-runtime",
  ]
}

target "moses-base" {
  context    = "."
  dockerfile = "base/Dockerfile"
  args       = {
    AUTHOR_NAME  = "${AUTHOR_NAME}"
    AUTHOR_EMAIL = "${AUTHOR_EMAIL}"
    REPO         = "${REPO}"
    VERSION      = "$(VERSION)"
  }
  platforms = ["linux/amd64"]
}

target "moses-devel" {
  context    = "."
  dockerfile = "devel/Dockerfile"
  args       = {
    AUTHOR_NAME  = "${AUTHOR_NAME}"
    AUTHOR_EMAIL = "${AUTHOR_EMAIL}"
    REPO         = "${REPO}"
    VERSION      = "$(VERSION)"
  }
  tags = [
    notequal("", VERSION) ? "${REPO}/moses:devel-${VERSION}" : "",
    "${REPO}/moses:devel",
  ]
  platforms = ["linux/amd64"]
}

target "moses-runtime" {
  contexts = {
    "${REPO}/moses:base"  = "target:moses-base"
    "${REPO}/moses:devel" = "target:moses-devel"
  }
  dockerfile = "runtime/Dockerfile"
  args       = {
    AUTHOR_NAME  = "${AUTHOR_NAME}"
    AUTHOR_EMAIL = "${AUTHOR_EMAIL}"
    REPO         = "${REPO}"
    VERSION      = "$(VERSION)"
  }
  tags = [
    notequal("", VERSION) ? "${REPO}/moses:runtime-${VERSION}" : "",
    "${REPO}/moses:runtime",
    "${REPO}/moses:latest",
  ]
  platforms = ["linux/amd64"]
}