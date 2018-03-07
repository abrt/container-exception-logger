Name: container-exception-logger
Version: 1.0.0
Release: 1%{?dist}
Summary: Logging from a container to a host

License: GPLv2+
URL: https://github.com/abrt/container-exception-logger
Source0: https://github.com/abrt/%{name}/archive/%{version}/%{name}-%{version}.tar.gz

BuildRequires: gcc
BuildRequires: asciidoc
BuildRequires: libxslt

%description
%{name} is a tool designed to run inside of
a container which is able to get its input outside of the container.

%prep
%setup -q

%build
gcc %{optflags} src/container-exception-logger.c -o src/container-exception-logger
a2x -d manpage -f manpage man/container-exception-logger.1.asciidoc

%install
mkdir -p %{buildroot}%{_bindir}
cp src/container-exception-logger %{buildroot}/%{_bindir}/container-exception-logger

mkdir -p %{buildroot}/%{_mandir}/man1
cp man/container-exception-logger.1 %{buildroot}/%{_mandir}/man1/container-exception-logger.1

%files
%attr(6755, root, root) %{_bindir}/container-exception-logger
%{_mandir}/man1/container-exception-logger.1.*

%changelog
* Thu Mar 08 2018 Matej Habrnal <mhabrnal@redhat.com> 1.0.0-1
- init
