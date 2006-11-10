%define _altdata_dir %_datadir/alterator

Name: alterator-syskbd
Version: 0.1
Release: alt1

Packager: Stanislav Ievlev <inger@altlinux.org>

BuildArch:	noarch

Source:%name-%version.tar

Summary: alterator module for the system keyboard setup
License: GPL
Group: System/Configuration/Other
Requires: alterator >= 2.9, control >= 0.7.1-alt1

BuildPreReq: alterator >= 2.9-alt0.10, alterator-standalone >= 2.5-alt0.3

# Automatically added by buildreq on Mon Jul 11 2005 (-bi)
BuildRequires: alterator

%description
alterator module for system keyboard (both xkb and kbd) setup

%prep
%setup -q

%build
%make_build libdir=%_libdir

%install
%makeinstall DESTDIR=%buildroot
%find_lang %name


%files -f %name.lang
%_sysconfdir/alterator/syskbd
%_altdata_dir/ui/*/
%_alterator_backend3dir/*


%changelog
* Fri Nov 10 2006 Stanislav Ievlev <inger@altlinux.org> 0.1-alt1
- initial release

