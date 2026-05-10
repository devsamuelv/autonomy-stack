{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:flox/nixpkgs";
  };

  outputs = { self, nixpkgs }: {
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.flox.dev"
    ];
    extra-trusted-public-keys = [
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
    ];
  };
}
