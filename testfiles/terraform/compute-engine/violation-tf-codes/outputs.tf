output "vm_names_and_regions" {
  value = [
    for i in google_compute_instance.multi_region_vms :
    "${i.name} in ${i.zone}"
  ]
}
