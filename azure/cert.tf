#Gen Certs
resource "null_resource" "ssl_gen" {

  provisioner "local-exec" {
    command = <<EOF
${ path.module }/init-cfssl \
${ var.data_dir }/.cfssl \
${ azurerm_resource_group.cncf.location } \
${ var.internal_tld } \
${ var.k8s_service_ip }
EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
rm -rf ${ var.data_dir }/.cfssl
EOF
  }

}

resource "null_resource" "dummy_dependency" {
  depends_on = [ "null_resource.ssl_gen" ]
}

