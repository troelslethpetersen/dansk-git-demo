# dansk-git-demo

Terminaldemo af Git med danske aliaser, optagelse med asciinema og mobil-render (1080×1920).

## Filer

- `setup-dansk-git.sh` – installerer danske Git-aliasser globalt
- `demo-dansk-git.sh` – kører selve demo-flowet
- `record.sh` – optager demoen til `casts/demo.cast`
- `render-mobile.sh` – konverterer cast til `final/mobile.mp4`

## Krav

### Nødvendigt for optagelse

- `asciinema`

Ubuntu:

```bash
sudo apt update && sudo apt install -y asciinema
```

### Nødvendigt for mobil-render

- `ffmpeg`
- `agg` (asciinema/agg)

Ubuntu (ffmpeg):

```bash
sudo apt update && sudo apt install -y ffmpeg
```

`agg` installeres typisk via Cargo:

```bash
cargo install --locked agg
```

## Kørsel

```bash
chmod +x *.sh
./setup-dansk-git.sh
./record.sh
./render-mobile.sh
```

Output:

- Cast: `casts/demo.cast`
- Mobilvideo: `final/mobile.mp4`

## Fejlfinding

Hvis du får:

- `asciinema: command not found` → installér `asciinema` og kør `./record.sh` igen.
- `Kastfil ikke fundet` i render-trinnet → optagelsen fejlede eller blev ikke lavet; kør `./record.sh` først.
