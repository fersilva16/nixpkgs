{ lib
, buildPythonPackage
, dnspython
, fetchFromGitHub
, ifaddr
, netifaces
, pyroute2
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiodiscover";
  version = "1.4.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KfNf09L8WF8Op+uVLRttROIgXpY79v0HfMv8b2qMSxE=";
  };

  propagatedBuildInputs = [
    dnspython
    netifaces
    pyroute2
    ifaddr
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner>=5.2",' "" \
      --replace "pyroute2>=0.5.18,!=0.6.1" "pyroute2"
  '';

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require access to /etc/resolv.conf
    "test_async_discover_hosts"
  ];

  pythonImportsCheck = [
    "aiodiscover"
  ];

  meta = with lib; {
    description = "Python module to discover hosts via ARP and PTR lookup";
    homepage = "https://github.com/bdraco/aiodiscover";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
