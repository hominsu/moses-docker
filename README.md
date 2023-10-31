<!-- PROJECT SHIELDS -->
<p align="center">
<a href="https://github.com/hominsu/moses-docker/graphs/contributors"><img src="https://img.shields.io/github/contributors/hominsu/moses-docker.svg?style=for-the-badge" alt="Contributors"></a>
<a href="https://github.com/hominsu/moses-docker/network/members"><img src="https://img.shields.io/github/forks/hominsu/moses-docker.svg?style=for-the-badge" alt="Forks"></a>
<a href="https://github.com/hominsu/moses-docker/stargazers"><img src="https://img.shields.io/github/stars/hominsu/moses-docker.svg?style=for-the-badge" alt="Stargazers"></a>
<a href="https://github.com/hominsu/moses-docker/issues"><img src="https://img.shields.io/github/issues/hominsu/moses-docker.svg?style=for-the-badge" alt="Issues"></a>
<a href="https://github.com/hominsu/moses-docker/blob/master/LICENSE"><img src="https://img.shields.io/github/license/hominsu/moses-docker.svg?style=for-the-badge" alt="License"></a>
<a href="https://github.com/hominsu/moses-docker/actions/workflows/docker-publish.yml"><img src="https://img.shields.io/github/actions/workflow/status/hominsu/moses-docker/docker-deploy.yml?branch=main&style=for-the-badge" alt="Deploy"></a>
</p>

<!-- PROJECT LOGO -->
<br/>
<div align="center">

<h3 align="center">moses-docker</h3>

  <p align="center">
    This project prepares a minimalist Docker image with mosesdecoder.
    <br/>
    <br/>
    <a href="#Examples">Examples</a>
    ·
    <a href="#Building">Building</a>
    ·
    <a href="#License">License</a>
  </p>
</div>

## Examples

All the scripts and binaries are placed in `/moses/script/` and `/moses/bin/`.

```bash
mkdir -p workspace
docker pull hominsu/moses:latest
docker run -v ./workspace:/workspace -it --rm hominsu/moses:latest /bin/bash
```

For examples.

- Use `multi-bleu.perl` to evaluate bleu.

  ```bash
  /moses/scripts/generic/multi-bleu.perl -lc ../corpus/tst.clean.en < tst.translated.en
  ```

- Use `moses` to translate the test set.

  ```bash
  /moses/bin/moses -f ./filtered-corpus/moses.ini < ../corpus/tst.clean.zh > tst.translated.en 2> tst.out
  ```

### Notice!!!

Use `Multi-threaded GIZA++` as the word alignment tool here, so while you are training, you need to specify the word
alignment tool as MGIZA.

```bash
/moses/scripts/training/train-model.perl -root-dir train -corpus ../corpus/train.clean -f zh -e en -alignment grow-diag-final-and -reordering msd-bidirectional-fe -lm 0:3:$(pwd)/../lm/train.blm.en:8 -mgiza -mgiza-cpus 64 -cores 64 -external-bin-dir /usr/local/bin >& training.out
```

## Building

This project requires Docker.

With the `platform` option, build any platform you want.

```shell
docker buildx bake --file ./docker-bake.hcl --load --set "*.platform=linux/amd64"
```

## License

Distributed under the MIT license. See `LICENSE` for more information.
