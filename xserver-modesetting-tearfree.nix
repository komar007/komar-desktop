# This substitutes the xorgserver package with one with backported TearFree support by Sultan Alsawaf.
final: prev: {
  xorg = prev.xorg // {
    xorgserver = prev.xorg.xorgserver.overrideAttrs (old: {
      patches = old.patches ++ [
        (final.fetchpatch
          {
            url = "https://github.com/komar007/xserver/compare/xorg-server-21.1.13...xorg-server-21.1.13_test_no_tear.patch";
            sha256 = "sha256-xMyMMc8St6br+Lq8jS1SD8vOKONhoPJ8IwPU0Y6ct1M=";
          })
      ];
    });
  };
}
