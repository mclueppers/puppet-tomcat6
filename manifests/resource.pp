define tomcat6::resource(
  $resource,
  $target,
) {

  concat::fragment { "${name}-resource":
    content => "${resource}\n",
    order   => '40',
    target  => $target,
  }
}
