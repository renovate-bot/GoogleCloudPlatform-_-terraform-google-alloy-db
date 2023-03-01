/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  project = var.project_id
  region  = var.region
}


 module "alloy-db"{
    source = "../.."
    cluster_id = "alloydb-v6-cluster"
    cluster_location = "us-central1"
    project_id = var.project_id
    cluster_labels = {}
    cluster_display_name = ""
    cluster_initial_user = {
        user = "alloydb-cluster-full",
        password = "alloydb-cluster-full"
    }
    network_self_link = "projects/${var.project_id}/global/networks/${var.network_name}"

    automated_backup_policy = {
        location = "us-central1"
        backup_window ="1800s", 
        enabled =true, 
        weekly_schedule = {
            days_of_week =["FRIDAY"], 
            start_times =["2:00:00:00", ]
        }
        quantity_based_retention_count = null,
        time_based_retention_count = "1.5s",
        labels = {
            test = "alloydb-cluster"
        },
    }

    primary_instance = {
        instance_id = "primary-instance-1", 
        instance_type = "PRIMARY", 
        machine_cpu_count = 2,
        database_flags = {},
        display_name = "alloydb-primary-instance"
    }


    read_pool_instance = [{
        instance_id = "read-instance-1", 
        display_name = "read-pool-instances",
        instance_type = "READ_POOL", 
        node_count = 2,
        database_flags = {},
        availability_type = "Zonal",
        ZONE = "us-central1-a",
        machine_cpu_count = 2
    }]


    depends_on = [google_compute_network.default, google_compute_global_address.private_ip_alloc, google_service_networking_connection.vpc_connection]
}

resource "google_compute_network" "default" {
        name     = var.network_name
        project = var.project_id
}


resource "google_compute_global_address" "private_ip_alloc" {
  project = var.project_id
  name          = "adb-v6"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}
