<a name="TOP"></a>
# LoRaMeshNodes
These are the assembly instructions for the Mobile Solar Node (Variant A) (MSNvB),
a portable solar powered [Meshtastic](https://meshtastic.org) or
[MeshCore](https://meshcore.co.uk) node.

![Main Assembly](assemblies/MSNvB_assembled.png)

<span></span>

---
## Table of Contents
1. [Parts list](#Parts_list)
1. [MSNvB LEnc Assembly](#MSNvB_lEnc_assembly)
1. [MSNvB Enc Assembly](#MSNvB_enc_assembly)
1. [MSNvB Assembly](#MSNvB_assembly)

<span></span>
[Top](#TOP)

---
<a name="Parts_list"></a>
## Parts list
| <span style="writing-mode: vertical-rl; text-orientation: mixed;">MSNvB&nbsp;LEnc</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">MSNvB&nbsp;Enc</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">MSNvB</span> | <span style="writing-mode: vertical-rl; text-orientation: mixed;">TOTALS</span> |  |
|---:|---:|---:|---:|:---|
|  |  |  | | **Vitamins** |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; 1S 3.7V battery protection board |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Antenna 20cm LoRa Antenna |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Battery negative contact |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Battery positive contact |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Cell Samsung 25R 18650 LION |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Heltec L76K_GNSS Module |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Heltec T144 |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Nut M6.25 x 1.8mm  |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;2&nbsp; | &nbsp;&nbsp; Solar Panel 100x100mm² 5V 3W |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp; Washer star M6.4 x 0.6mm |
| &nbsp;&nbsp;10&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;11&nbsp; | &nbsp;&nbsp;Total vitamins count |
|  |  |  | | **3D printed parts** |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvB_buttons.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvB_cov.stl |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvB_lEnc.stl |
| &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvB_stand.stl |
| &nbsp;&nbsp;.&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;.&nbsp; |  &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;MSNvB_top.stl |
| &nbsp;&nbsp;3&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;1&nbsp; | &nbsp;&nbsp;5&nbsp; | &nbsp;&nbsp;Total 3D printed parts count |

<span></span>
[Top](#TOP)

---
<a name="MSNvB_lEnc_assembly"></a>
## MSNvB LEnc Assembly
### Vitamins
|Qty|Description|
|---:|:----------|
|1| 1S 3.7V battery protection board|
|1| Antenna 20cm LoRa Antenna|
|1| Battery negative contact|
|1| Battery positive contact|
|1| Cell Samsung 25R 18650 LION|
|1| Heltec L76K_GNSS Module|
|1| Heltec T144|
|1| Nut M6.25 x 1.8mm |
|1| Solar Panel 100x100mm² 5V 3W|
|1| Washer star M6.4 x 0.6mm|


### 3D Printed parts

| 1 x [MSNvB_buttons.stl](stls/MSNvB_buttons.stl) | 1 x [MSNvB_lEnc.stl](stls/MSNvB_lEnc.stl) | 1 x [MSNvB_stand.stl](stls/MSNvB_stand.stl) |
|---|---|---|
| ![MSNvB_buttons.stl](stls/MSNvB_buttons.png) | ![MSNvB_lEnc.stl](stls/MSNvB_lEnc.png) | ![MSNvB_stand.stl](stls/MSNvB_stand.png) 



### Assembly instructions
![MSNvB_lEnc_assembly](assemblies/MSNvB_lEnc_assembly.png)

1. Clamp the stand on to the enclosure 
1. Attach the antenna to the enclosure 
2. Connect it to the Heltec T114 board
3. Insert buttons
4. Insert Heltec T114 board
5. Connect and insert the GNSS module (optional)
6. Attach the battery with two zip ties
7. Connect the battery to the Heltec T114 board

![MSNvB_lEnc_assembled](assemblies/MSNvB_lEnc_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="MSNvB_enc_assembly"></a>
## MSNvB Enc Assembly
### Vitamins
|Qty|Description|
|---:|:----------|
|1| Solar Panel 100x100mm² 5V 3W|


### 3D Printed parts

| 1 x [MSNvB_top.stl](stls/MSNvB_top.stl) |
|---|
| ![MSNvB_top.stl](stls/MSNvB_top.png) 



### Sub-assemblies

| 1 x MSNvB_lEnc_assembly |
|---|
| ![MSNvB_lEnc_assembled](assemblies/MSNvB_lEnc_assembled_tn.png) 



### Assembly instructions
![MSNvB_enc_assembly](assemblies/MSNvB_enc_assembly.png)

1. Connect the solar panel to the Heltec T114 board
2. Place the solar panel on the enclosure
3. Attach the top frame

![MSNvB_enc_assembled](assemblies/MSNvB_enc_assembled.png)

<span></span>
[Top](#TOP)

---
<a name="MSNvB_assembly"></a>
## MSNvB Assembly
### 3D Printed parts

| 1 x [MSNvB_cov.stl](stls/MSNvB_cov.stl) |
|---|
| ![MSNvB_cov.stl](stls/MSNvB_cov.png) 



### Sub-assemblies

| 1 x MSNvB_enc_assembly |
|---|
| ![MSNvB_enc_assembled](assemblies/MSNvB_enc_assembled_tn.png) 



### Assembly instructions
![MSNvB_assembly](assemblies/MSNvB_assembly.png)

Slide on the protective cover for transportation.

![MSNvB_assembled](assemblies/MSNvB_assembled.png)

<span></span>
[Top](#TOP)
