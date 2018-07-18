output "content" {
  value = "${data.template_file.cluster.rendered}"
}
