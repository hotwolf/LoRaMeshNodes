<a name="TOP"></a>
# LoRaMeshNodes
These are the assembly instructions for the Mobile Solar Node (Variant A) (MSNvA),
a portable solar powered [Meshtastic](https://meshtastic.org) or
[MeshCore](https://meshcore.co.uk) node.

![Main Assembly](assemblies/MSNvA_assembled.png)

<span></span>

---
## Table of Contents
1. [Parts list](#Parts_list)
1. [MSNvA LEnc Assembly](#MSNvA_lEnc_assembly)
1. [MSNvA Enc Assembly](#MSNvA_enc_assembly)
1. [MSNvA Assembly](#MSNvA_assembly)

<span></span>
[Top](#TOP)

---
<a name="Parts_list"></a>
## Parts list
| <span style="writing-mode: vertical-rl; text-orientation: mixed;">MSNvA&nbsp;LEnc</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">MSNvA&nbsp;Enc</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">MSNvA</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">TOTALS</span> |  |
|---:|---:|---:|---:|:---|
|  |  |  | | **Vitamins** |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Antenna 20cm LoRa Antenna |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Heltec L76K_GNSS Module |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Heltec T144 |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Lithium-Polymer-Akku 3,7V 2500mAh |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Nut M6.25 x 1.8mm  |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Solar Panel 100x100mm² 5V 3W |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Washer star M6.4 x 0.6mm |
| &nbsp;&nbsp;7&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;8&nbsp; | &nbsp;&nbsp;Total vitamins count |
|  |  |  | | **3D printed parts** |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvA_buttons.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvA_cov.stl |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvA_lEnc.stl |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvA_stand.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvA_top.stl |
| &nbsp;&nbsp;3&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp;Total 3D printed parts count |

<span></span>
[Top](#TOP)

---
<a name="MSNvA_lEnc_assembly"></a>
## MSNvA LEnc Assembly
### Vitamins
|Qty|Description|
|---:|:----------|
|1| Antenna 20cm LoRa Antenna|
|1| Heltec L76K_GNSS Module|
|1| Heltec T144|
|1| Lithium-Polymer-Akku 3,7V 2500mAh|
|1| Nut M6.25 x 1.8mm |
|1| Solar Panel 100x100mm² 5V 3W|
|1| Washer star M6.4 x 0.6mm|


### 3D Printed parts

| 1 x [MSNvA_buttons.stl](stls/MSNvA_buttons.stl) | 1 x [MSNvA_lEnc.stl](stls/MSNvA_lEnc.stl) | 1 x [MSNvA_stand.stl](stls/MSNvA_stand.stl) |
|---|---|---|
| ![MSNvA_buttons.stl](stls/MSNvA_buttons.png) | ![MSNvA_lEnc.stl](stls/MSNvA_lEnc.png) | ![MSNvA_stand.stl](stls/MSNvA_stand.png) 



### Assembly instructions
![MSNvA_lEnc_assembly](assemblies/MSNvA_lEnc_assembly.png)

1. Attach the antenna to the enclosure 
2. Connect it to the Heltec T114 board
3. Insert buttons
4. Insert Heltec T114 board
5. Connect and insert the GNSS module (optional)
6. Attach the battery with two zip ties
7. Connect the battery to the Heltec T114 board

![MSNvA_lEnc_assembled](assemblies/MSNvA_lEnc_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="MSNvA_enc_assembly"></a>
## MSNvA Enc Assembly
### Vitamins
|Qty|Description|
|---:|:----------|
|1| Solar Panel 100x100mm² 5V 3W|


### 3D Printed parts

| 1 x [MSNvA_top.stl](stls/MSNvA_top.stl) |
|---|
| ![MSNvA_top.stl](stls/MSNvA_top.png) 



### Sub-assemblies

| 1 x MSNvA_lEnc_assembly |
|---|
| ![MSNvA_lEnc_assembled](assemblies/MSNvA_lEnc_assembled_tn.png) 



### Assembly instructions
![MSNvA_enc_assembly](assemblies/MSNvA_enc_assembly.png)

1. Connect the solar panel to the Heltec T114 board
2. Place the solar panel on the enclosure
3. Attach the top frame

![MSNvA_enc_assembled](assemblies/MSNvA_enc_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="MSNvA_assembly"></a>
## MSNvA Assembly
### 3D Printed parts

| 1 x [MSNvA_cov.stl](stls/MSNvA_cov.stl) |
|---|
| ![MSNvA_cov.stl](stls/MSNvA_cov.png) 



### Sub-assemblies

| 1 x MSNvA_enc_assembly |
|---|
| ![MSNvA_enc_assembled](assemblies/MSNvA_enc_assembled_tn.png) 



### Assembly instructions
![MSNvA_assembly](assemblies/MSNvA_assembly.png)

Slide on the protective cover for transportation.

![MSNvA_assembled](assemblies/MSNvA_assembled.png)

<span></span>
[Top](#TOP)
