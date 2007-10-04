%define _altdata_dir %_datadir/alterator

Name: alterator-sysconfig
Version: 0.4
Release: alt1

%add_findreq_skiplist %_datadir/install2/preinstall.d/*

#save previous version in branch
Conflicts: alterator-syskbd

#replace previous version in branch
#Provides: alterator-syskbd
#Obsoletes: alterator-syskbd

Packager: Stanislav Ievlev <inger@altlinux.org>

BuildArch:	noarch

Source:%name-%version.tar

Summary: alterator module for basic system settings
License: GPL
Group: System/Configuration/Other
Requires: alterator >= 2.9, control >= 0.7.1-alt1

BuildPreReq: alterator >= 2.9-alt0.10, alterator-standalone >= 2.5-alt0.3

# Automatically added by buildreq on Mon Jul 11 2005 (-bi)
BuildRequires: alterator

%description
alterator module for basic system settings ( console and X11 keyboard, console font, system locale)

%prep
%setup -q

%build
%make_build libdir=%_libdir

%install
%makeinstall
%find_lang %name


%files -f %name.lang
%_sysconfdir/alterator/sysconfig
%_altdata_dir/ui/*/
%_alterator_backend3dir/*
%_datadir/install2/preinstall.d/*


%changelog
* Thu Oct 04 2007 Stanislav Ievlev <inger@altlinux.org> 0.4-alt1
- add /sysconfig/language - separate language step
- fix old /sysconfig/lang - wrong translation package

* Thu Sep 20 2007 Stanislav Ievlev <inger@altlinux.org> 0.3-alt1
- join together all basic system setup:
  console font, console and X11 keyboard layout, system locale

* Mon Aug 06 2007 Anton V. Boyarshinov <boyarsh@altlinux.ru> 0.2-alt8
- control switching fixed 

* Fri Jun 22 2007 Anton V. Boyarshinov <boyarsh@altlinux.ru> 0.2-alt7
- added 3-language layput for UA 

* Fri Jun 15 2007 Stanislav Ievlev <inger@altlinux.org> 0.2-alt6
- to sisyphus

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

