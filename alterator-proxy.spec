%define _altdata_dir %_datadir/alterator

Name: alterator-proxy
Version: 0.1
Release: alt1

Summary: alterator module for client-side proxy configuration
License: GPL
Group: System/Configuration/Other

Source:%name-%version.tar
Packager: Michael Shigorin <mike@altlinux.org>
BuildArch: noarch

Requires: alterator >= 2.9 gettext

BuildPreReq: alterator >= 2.9-alt0.10, alterator-standalone >= 2.5-alt0.3

BuildRequires: alterator

%description
%summary

%prep
%setup -q

%build
%make_build libdir=%_libdir

%install
%makeinstall
%find_lang %name

%files -f %name.lang
%_altdata_dir/applications/*
%_altdata_dir/ui/*/
%_alterator_backend3dir/*

%changelog
* Thu Jan 17 2008 Michael Shigorin <mike@altlinux.org> 0.1-alt1
- initial release
