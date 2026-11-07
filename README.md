# Rever AV1 for the Steam Frame (kernel module + helper)

**English** · [Español](#español)

An out-of-tree build of the Linux kernel's Qualcomm **iris** video driver (`drivers/media/platform/qcom/iris`, Linux
v7.2) that adds the **AV1 decoder** the Steam Frame's stock driver does not expose. Rever VR Central installs it on a
Steam Frame only when the player chooses AV1; it is loaded while the Rever app runs and Valve's own driver is put back
when the app ends. Nothing is loaded at boot.

This repository is the complete corresponding source of what Rever VR Central 0.71 ships to the headset. The headset
build is made **on the Frame itself** from these files (`helper/rever-av1 build`), against the running kernel's own
headers; Rever does not distribute a prebuilt `.ko`.

## Licence

- `module/`: **GPL-2.0-only** (see `COPYING`). Every source file keeps its upstream SPDX header and copyright
  notice. `v4l2-mem2mem*.c` is GPL-2.0-or-later (Samsung), used under GPL-2.0.
- `helper/` (the install, uninstall, switch and check scripts and the sudo rule): **GPL-2.0-only** as well, so the
  whole folder can be copied and changed under one licence. (Three helper scripts still carry the comment
  "PRIVATE until published" from before this publication; they are published here under GPL-2.0-only.)

## Where the code comes from

| Part | Origin |
| --- | --- |
| `iris_*.c`, `iris_*.h`, `Makefile` | Linux **v7.2** (`torvalds/linux` tag `v7.2`, commit `8d3ae59288f1e7d58d76558a6ee96d533bc5019f`), path `drivers/media/platform/qcom/iris`. `module/provenance.json` lists each upstream file with its SHA-256 and git blob id. |
| `v4l2-mem2mem-k72.c` | Linux v7.2 `drivers/media/v4l2-core/v4l2-mem2mem.c`, **unchanged** (the Frame's kernel is built without `CONFIG_V4L2_MEM2MEM_DEV`). |
| `v4l2-mem2mem.c` | Linux **v6.18** `drivers/media/v4l2-core/v4l2-mem2mem.c`, **unchanged** (SHA-256 `0b3d3509...7947b8f`); used only on 6.x kernels. |
| `frame_firmware_no_tz.c/.h`, `frame_av1_compat.h`, `frame-port.patch` | The Steam Frame board port from **SteamFrame-Advanced-Options** by elliotttate (<https://github.com/elliotttate/SteamFrame-Advanced-Options>, `Frame/AV1/`; those files are GPL-2.0-only), with Rever's changes listed in `REVER_CHANGES.md`. |
| Rever's changes | `REVER_CHANGES.md` (what and when) and `patches/0001-rever-changes-to-linux-v7.2-iris.patch` (the exact diff of the 17 changed upstream files). |

## Build and install (on a Steam Frame)

Requirements: SteamOS on the Steam Frame (kernel 6.18 or 7.2), developer mode, `sudo`. The only download is the
headers package of the running kernel, from the headset's own configured SteamOS repository (`pacman -Sp`); the
compiler is the gcc the SteamOS image already carries. The decoder firmware (`qcom/vpu/vpu33_4v.mbn`) is the
headset's own and is not part of this repository.

```sh
# copy this folder to the Frame, then:
sudo sh helper/install-rever-av1.sh        # installs the helper and the sudo rule, builds the module
/home/.rever-av1/rever-av1-check           # state=ok when the helper, the rule and a module for this kernel exist
sudo -n /etc/rever/av1/rever-av1 on        # Valve's iris unbound, this module loaded
sudo -n /etc/rever/av1/rever-av1 off       # this module removed, Valve's iris bound again
sudo sh helper/uninstall-rever-av1.sh      # removes everything the installer put in place
```

Manual build without the helper (kernel headers in `/lib/modules/$(uname -r)/build`):

```sh
make -C /lib/modules/$(uname -r)/build M=$PWD/module modules   # -> module/steam-frame-av1-lab.ko
```

Module parameters: `arm_av1_lab` (the AV1 decoder; off unless set), `max_clock`, `rever_let_go`,
`rever_clock_margin`, `rever_vr_fps`, `rever_rate_floor_pct`, `rever_vsp_factor` (`modinfo` describes each).

**No warranty** (GPL-2.0 sections 11 and 12). This driver touches the headset's video hardware: a SteamOS update can
change the kernel, and the helper then asks for a rebuild (`rever-av1-check` says `state=update`).

## How it relates to Rever VR Central

The Rever apps (the Windows PC app and the Steam Frame app) are separate programs. They never link this code: the
Frame app uses the standard V4L2 interface of the Linux kernel (system calls), and the PC app copies this folder to the
headset and runs the scripts over SSH.

---

## Español

Una compilación fuera del árbol del driver de vídeo **iris** de Qualcomm del núcleo Linux
(`drivers/media/platform/qcom/iris`, Linux v7.2) que añade el **decodificador AV1** que el driver de serie del Steam
Frame no ofrece. Rever VR Central lo instala en un Steam Frame solo si el jugador elige AV1; se carga mientras la app de
Rever está abierta y, al cerrarla, vuelve el driver de Valve. Nunca se carga al arrancar.

Este repositorio es el código fuente correspondiente completo de lo que Rever VR Central 0.71 lleva al visor. El módulo
se compila **en el propio Frame** a partir de estos archivos (`helper/rever-av1 build`), con las cabeceras del núcleo
que esté en marcha; Rever no distribuye ningún `.ko` ya compilado.

### Licencia

- `module/`: **GPL-2.0-only** (ver `COPYING`). Cada archivo conserva su cabecera SPDX y su aviso de copyright
  originales. `v4l2-mem2mem*.c` es GPL-2.0-or-later (Samsung), usado bajo GPL-2.0.
- `helper/` (los scripts de instalar, desinstalar, activar y comprobar y la regla de sudo): también
  **GPL-2.0-only**, para que toda la carpeta se pueda copiar y modificar con una sola licencia. (Tres scripts del
  ayudante aún llevan el comentario "PRIVATE until published" de antes de esta publicación; se publican aquí con
  GPL-2.0-only.)

### De dónde viene el código

- `iris_*`, `Makefile`: Linux **v7.2** (commit `8d3ae59288f1`), con la lista de archivos y sus SHA-256 en
  `module/provenance.json`.
- `v4l2-mem2mem-k72.c` (Linux v7.2) y `v4l2-mem2mem.c` (Linux v6.18): **sin cambios**.
- `frame_firmware_no_tz.*`, `frame_av1_compat.h`, `frame-port.patch`: el port a la placa del Steam Frame de
  **SteamFrame-Advanced-Options** (elliotttate, archivos GPL-2.0-only), con los cambios de Rever.
- Los cambios de Rever: `REVER_CHANGES.md` (qué y cuándo) y `patches/0001-rever-changes-to-linux-v7.2-iris.patch` (el
  diff exacto de los 17 archivos de upstream que cambian).

### Compilar e instalar (en un Steam Frame)

Las órdenes de arriba. Hace falta SteamOS en el Steam Frame (núcleo 6.18 o 7.2), modo desarrollador y `sudo`. El
instalador no descarga nada de Internet salvo el paquete de cabeceras del núcleo desde el repositorio de SteamOS.

**Sin garantía** (secciones 11 y 12 de la GPL-2.0). Una actualización de SteamOS puede cambiar el núcleo: entonces
`rever-av1-check` dice `state=update` y hay que recompilar.

### Relación con Rever VR Central

Las apps de Rever (la del PC con Windows y la del Steam Frame) son programas aparte y nunca enlazan este código: la app
del Frame usa la interfaz V4L2 estándar del núcleo (llamadas al sistema) y la del PC copia esta carpeta al visor y
ejecuta los scripts por SSH.
