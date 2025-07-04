{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "flannel";
  version = "0.27.0";
  rev = "v${version}";

  vendorHash = "sha256-vwv7B3G9v9FNDS/RWTZwA5uqW2/GQLtUgylFsi0Dldo=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-GVbDmRXyZjWXHi9eHiQ28RDi1N//ro3AnKb0txvA8yA=";
  };

  ldflags = [ "-X github.com/flannel-io/flannel/pkg/version.Version=${rev}" ];

  # TestRouteCache/TestV6RouteCache fail with "Failed to create newns: operation not permitted"
  doCheck = false;

  passthru.tests = { inherit (nixosTests) flannel; };

  meta = with lib; {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = "https://github.com/flannel-io/flannel";
    maintainers = with maintainers; [
      johanot
      offline
    ];
    platforms = with platforms; linux;
    mainProgram = "flannel";
  };
}
