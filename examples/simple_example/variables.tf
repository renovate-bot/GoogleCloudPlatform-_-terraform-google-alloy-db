/**
 * Copyright 2025 Google LLC
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

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "network_name" {
  description = "The ID of the network in which to provision resources."
  type        = string
  default     = "simple-adb"
}


variable "region_central" {
  default     = "us-central1"
  description = "The region for cluster in central us"
  type        = string
}

variable "region_east" {
  default     = "us-east1"
  description = "The region for cluster in east us"
  type        = string
}
