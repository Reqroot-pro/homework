terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.yandex_cloud_token
  cloud_id  = "xxx"
  folder_id = "xxx"
  zone      = "ru-central1-b"
}

# Создание двух виртуальных машин
resource "yandex_compute_instance" "vm" {
  count = 2
  name = "vm${count.index}"
  platform_id = "standard-v1"
  boot_disk {
    initialize_params {
      image_id = "fd87j6d92jlrbjqbl32q"
      size = 8
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }
  
  resources {
    core_fraction = 5
    cores = 2
    memory = 2
  }  
 
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_vpc_network" "network1" {
  name = "network1"
}  

resource "yandex_vpc_subnet" "subnet1" {
  name = "subnet1"
  v4_cidr_blocks = [ "172.24.8.0/24" ]
  network_id = yandex_vpc_network.network1.id
}

resource "yandex_lb_target_group" "group1" {
  name = "group1"
  target {
    subnet_id = yandex_vpc_subnet.subnet1.id
    address = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }  
  
  target {
    subnet_id = yandex_vpc_subnet.subnet1.id
    address = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "balancer1" {
  name = "balancer1"
  deletion_protection = "false"
  listener {
    name = "my-lb1"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  
  attached_target_group {
    target_group_id = yandex_lb_target_group.group1.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }  
}

# Вывод IP адресов виртуальных машин
output "lb-ip" {
  value = yandex_lb_network_load_balancer.balancer1.listener
}

output "vm-ips" {
  value = tomap({
    for name, vm in yandex_compute_instance.vm : name => vm.network_interface.0.nat_ip_address
  })
}

