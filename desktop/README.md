
# DeskTop diassembly notes - DESKTOP2.$F1

This is large - 111k. It includes a loader and the DeskTop app with
both main memory and aux memory segments, filling everything from
$4000 to $FFFF (except for I/O space and ProDOS), and still having
more code segments swapped in dynamically.

The file is broken down into multiple segments:

| Purpose       | File Offset | Bank   | Address      | Length | Sources                   |
|---------------|-------------|--------|--------------|--------|---------------------------|
| Loader        | B$000000    | Main   | A$2000-$257F | L$0580 | `loader.s`                |
| MGTK/DeskTop  | B$000580    | Aux    | A$4000-$BFFF | L$8000 | `mgtk.s`, `desktop_aux.s` |
| DeskTop       | B$008580    | Aux LC | A$D000-$ECFF | L$1D00 | `desktop_res.s`           |
| DeskTop       | B$00A280    | Aux LC | A$FB00-$FFFF | L$0500 | `desktop_res.s`           |
| DeskTop       | B$00A780    | Main   | A$4000-$BEFF | L$7F00 | `desktop_main.s`          |
| Initializer   | B$012680    | Main   | A$0800-$0FFF | L$0800 | `desktop_main.s`          |
| Invoker       | B$012E80    | Main   | A$0290-$03EF | L$0160 | `invoker.s`               |
| Disk Copy 1/4 | B$012FE0    | Main   | A$0800-$09FF | L$0200 | `ovl1.s`                  |
| Disk Copy 2/4 | B$0131E0    | Main   | A$1800-$19FF | L$0200 | `ovl1a.s`                 |
| Disk Copy 3/4 | B$0133E0    | Aux LC | A$D000-$F1FF | L$2200 | `ovl1b.s`                 |
| Disk Copy 4/4 | B$0155E0    | Main   | A$0800-$12FF | L$0B00 | `ovl1c.s`                 |
| Format/Erase  | B$0160E0    | Main   | A$0800-$1BFF | L$1400 | `ovl2.s`                  |
| Selector 1/2  | B$0174E0    | Main   | A$9000-$9FFF | L$1000 | `ovl3.s`                  |
| Common        | B$0184E0    | Main   | A$5000-$6FFF | L$2000 | `ovl4.s`                  |
| File Copy     | B$01A4E0    | Main   | A$7000-$77FF | L$0800 | `ovl5.s`                  |
| File Delete   | B$01ACE0    | Main   | A$7000-$77FF | L$0800 | `ovl6.s`                  |
| Selector 2/2  | B$01B4E0    | Main   | A$7000-$77FF | L$0800 | `ovl7.s`                  |

(EOF is $01BCE0)

The DeskTop segments loaded into the Aux bank switched ("language
card") memory can be used from both main and aux, so contain relay
routines, resources, and buffers. More details below.

## Structure

### Loader

`loader.s`

Invoked at $2000; patches the ProDOS QUIT routine (at LC2 $D100) then
invokes it. That gets copied to $1000-$11FF and run by ProDOS.

The invoked code stashes the current prefix and re-patches ProDOS with
itself. It then (in a convoluted way) loads in the second $200 bytes of
`DESKTOP2` at $2000 and invokes that.

This code then loads the rest of the file as a sequence of segments,
moving them to the appropriate destination in aux/banked/main memory.

There's fourth chunk of code, which expects to live at $280 so it
can't co-exist with the Invoker; it may be temporary code, as there is
no sign that it is ever moved into place. It's also unclear how it
would be hooked in. The routine detects OA+SA+P and prints the DHR
screen to an ImageWriter II printer attached to Slot 1. (This may have
been used to produce screenshots during development for manuals.)

### Invoker

`invoker.s`

Loaded at $290-$03EF, this small routine is used to invoke a target,
e.g. a double-clicked file. System files are loaded/run at $2000,
binary files at the location specified by their aux type, and BASIC
files loaded by searching for BASIC.SYSTEM and running it with the
pathname passed at $2006 (see ProDOS TLM).

### Initializer

(in `desktop_main.s`)

Loaded at $800-$FFF, this does one-time initialization of the
DeskTop. It is later overwritten when any desk accessories are
run.

### MouseGraphics ToolKit (MGTK)

`mgtk.s`

Aux $4000-$851E is the [MouseGraphics ToolKit](../mgtk/MGTK.md) - a
GUI library used for the DeskTop application.

Since this resides in Aux memory, DeskTop spends most of its time
with Aux read/write enabled. The state and logic for rendering
the desktop and window contents resides in Aux to avoid proxying
data.

### "DeskTop" Application

`desktop.s` which includes in:
* `desktop_aux.s`
* `desktop_lc.s` (which pulls in `desktop_res.s`)
* `desktop_main.s`

DeskTop application code is in the lower 48k of both Aux and Main:

* Aux $851F-$BFFF - sitting above the GUI library (`desktop_aux.s`)
* Main $4000-$BEFF (`desktop_main.s`)

...and in the Aux language card area (accessible from both aux and
main code) are relays, buffers and resources:

* Aux $D000-$ECFF - relays and other aux/main helpers, resources (menus, strings, window)
* Aux $ED00-$FAFF - hole for data buffer - entries for each icon on desktop/in windows
* Aux $FB00-$FFFF - more resources (file types, icons)

($C000-$CFFF is reserved for I/O, and main $BF page and language card is ProDOS)

`desktop_res.s` defines these common resources. It is built as part of
`desktop.s`. Early in the build process it is also built as part of
`desktop_res_build.s` which is processed to produce `out/desktop_res.inc`,
which is used by the overlay sources.

Aux $1B00-$1F7F holds lists of icons, one for the desktop then one for up
to 8 windows. First byte is a count, up to 127 icon entries. Icon numbers
map indirectly into a table at $ED00 that holds the type, coordinates, etc.
Aux $1F80-$1FFF is a map of used/free icon numbers, as they are reassigned
as windows are opened and closed.

### Overlays

`ovl1.s` etc

Interactive commands including disk copy/format/erase, file
copy/delete, and Selector add/edit/delete/run all dynamically load
main memory code overlays. When complete, any original code above
$4000 is reloaded (unless a full restart is required.)

Several of the overlays also use a common file selector dialog overlay
`ovl4.s` ($5000-$6FFF).

#### Disk Copy Overlay

The Disk Copy command replaces large chunks of memory and is best
thought of as a separate application.

The first part (`ovl1.s`, $800-$9FF) loads into main memory the other
overlays, but in turn it loads a second short ($200-byte) overlay
(`ovl1a.s`, $1800-$19FF). This then loads a replacement for the
resources in the aux language card area (`ovl1b.s`, Aux LC
$D000-$F1FF) and another block of code in main memory (`ovl1c.s`, Main
$0800-$12FF). When exiting, the DeskTop is restarted from the
beginning.

#### Disk Format/Disk Erase

Simple overlay: `ovl2.s`, loaded into Main A$0800-$1BFF.

#### Selector - Delete Entry / Run Entry

Simple overlay: `ovl3.s` ($9000-$9FFF).

#### Selector - Add Entry / Edit Entry

Also uses `ovl3.s` ($9000-$9FFF) but additionally uses overlay
`ovl7.s` ($7000-$77FF) and the file selector dialog `ovl4.s`
($5000-$6FFF).

#### File Copy

Overlay `ovl5.s` ($7000-$77FF), uses file selector dialog `ovl4.s`
($5000-$6FFF).

#### File Delete

Overlay `ovl6.s` ($7000-$77FF), uses file selector dialog `ovl4.s`
($5000-$6FFF).


## Memory Map

```
       Main                  Aux                    ROM
$FFFF +-------------+       +-------------+       +-------------+
      | ProDOS      |       | DeskTop     |       | Monitor     |
$F800 |             |       | Resources/  |       +-------------+
      |             |       | Buffers     |       | Applesoft   |
      |             |Bank2  |             |Bank2  |             |
$E000 |             +----+  |             +----+  |             |
      |             | PD |  |             | xx |  |             |
$D000 +-------------+----+  +-------------+----+  +-------------+
                                                  | I/O         |
                                                  |             |
$C000 +-------------+       +-------------+       +-------------+
      | ProDOS GP   |       | DeskTop     |
$BF00 +-------------+       | App Code    |
      | DeskTop     |       |             |
      | App Code    |       |             |
      |             |       |             |
      |             |       |             |
      |             |       |             |
      |             |       |             |
$A000 |      +------+       |             |
      |      | Ovl  |       |             |
      |      |      |       |             |
      |      |      |       |             |
$9000 |      +------+       |             |
      |             |       |             |
$8E00 |             |       | Entry Point |
      |             |       |             |
$8800 |             |       | Font        |
      |             |       |             |
$851F |             |       +-------------+
      |             |       | MGTK        |
      |             |       |             |
      |             |       |             |
      |             |       |             |
$7800 |      +------+       |             |
      |      | Ovl  |       |             |
$7000 |      +------+       |             |
      |      | Ovl  |       |             |
      |      |      |       |             |
      |      |      |       |             |
      |      |      |       |             |
      |      |      |       |             |
      |      |      |       |             |
      |      |      |       |             |
      |      |      |       |             |
$5000 |      +------+       |             |
      |             |       |             |
      |             |       |             |
      |             |       |             |
      |             |       |             |
$4000 +-------------+       +-------------+
      | Graphics    |       | Graphics    |
      |             |       |             |
      |             |       |             |
      |             |       |             |
      |             |       |             |
      |             |       |             |
      |             |       |             |
      |             |       |             |
$2000 +-------------+       +-------------+
      | Initializer |       | Win/Icn Map |
$1B00 | & Desk Acc  |       +-------------+
      | & Overlays  |       | Desk Acc &  |
      |             |       | Save Area   |
      |             |       |             |
$0800 +-------------+       +-------------+
      | Drawing     |       | Drawing     |
      | Temp Buffer |       | Temp Buffer |
$0400 +-------------+       +-------------+
      | Invoker     |       |             |
$0300 +-------------+       +-------------+
      | Input Buf   |       | Input Buf   |
$0200 +-------------+       +-------------+
      | Stack       |       | Stack       |
$0100 +-------------+       +-------------+
      | Zero Page   |       | Zero Page   |
$0000 +-------------+       +-------------+
```

Memory use by the Disk Copy overlay is not shown.
