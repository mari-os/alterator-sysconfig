%define _altdata_dir %_datadir/alterator

Name: alterator-syskbd
Version: 0.2
Release: alt5

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
* Mon Jun 04 2007 Anton V. Boyrshonov <boyarsh@altlinux.ru> 0.2-alt5
- added alt-shift toggle 

* Wed May 02 2007 Stanislav Ievlev <inger@altlinux.org> 0.2-alt4
- update Ukrainian translation

* Mon Apr 23 2007 Stanislav Ievlev <inger@altlinux.org> 0.2-alt3
- add Ukrainian translation

* Wed Jan 31 2007 Stanislav Ievlev <inger@altlinux.org> 0.2-alt2
- add default action

* Wed Jan 31 2007 Stanislav Ievlev <inger@altlinux.org> 0.2-alt1
- add support for autoinstall backend
- automatically select single keyboard variant

* Wed Dec 13 2006 Stanislav Ievlev <inger@altlinux.org> 0.1-alt5
- really change system files

* Mon Dec 11 2006 Stanislav Ievlev <inger@altlinux.org> 0.1-alt4
- improve interface for low resolution screens

* Mon Dec 04 2006 Stanislav Ievlev <inger@altlinux.org> 0.1-alt3
- auto skip in both directions
- save translations in utf8 encodings to avoid iconv usage on installer's stage2 

* Wed Nov 29 2006 Stanislav Ievlev <inger@altlinux.org> 0.1-alt2
- enable wizard callbacks

* Fri Nov 10 2006 Stanislav Ievlev <inger@altlinux.org> 0.1-alt1
- initial release

