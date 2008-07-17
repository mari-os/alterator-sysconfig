%define _altdata_dir %_datadir/alterator

Name: alterator-proxy
Version: 0.3
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
This is an alterator module for client-side proxy configuration:
it creates or modifies an /etc/profile.d/proxy.sh file to hold
the specified values in a set of environment variables.

Please note that you might need to relogin for applications 
to "notice" the updated environment.

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
%doc TODO

%changelog
* Sat Mar 29 2008 Michael Shigorin <mike@altlinux.org> 0.3-alt1
- applied patch by Denis Yagofarov <denyago rambler ru>
  to enable clearing proxy settings (#15144)

* Fri Jan 18 2008 Michael Shigorin <mike@altlinux.org> 0.2-alt1
- added proxy auth support
- improved write_settings() to use shell_add_or_subst()
  instead of overwriting the configuration snippet

* Thu Jan 17 2008 Michael Shigorin <mike@altlinux.org> 0.1-alt1
- initial release
