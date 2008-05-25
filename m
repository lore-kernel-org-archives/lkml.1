Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbYEYTDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbYEYTDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbYEYTD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:03:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:49993 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753412AbYEYTDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:03:25 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX19+LExcVpB+cHwZfGtfKMuuWlmBXu49bQgfdEhJKL
	VZ3/ks7k/SdyrE
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
From: Mirco Tischler <mt-ml@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20080525181118.GG1791@cs181133002.pp.htv.fi>
References: <1211735607.14556.14.camel@mtlp.tischlernetz>
	 <20080525181118.GG1791@cs181133002.pp.htv.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oaNuF9kuDu0/6gqUBWlT"
Date: Sun, 25 May 2008 21:03:22 +0200
Message-Id: <1211742202.14556.25.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oaNuF9kuDu0/6gqUBWlT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On So, 2008-05-25 at 21:11 +0300, Adrian Bunk wrote:
> Works for me with your .config.
>=20
> You are using an unmodified 2.6.26-rc3 kernel?
Yes. I just pulled today.
>=20
> If yes, please:
> - send the output of "bash ./scripts/ver_linux" and
=EF=BB=BF$ ./scripts/ver_linux
=EF=BB=BFIf some fields are empty or look unusual you may have an old versi=
on.
Compare to the current minimal requirements in Documentation/Changes.

Linux mtlp 2.6.26-rc3-experimental #18 SMP PREEMPT Thu May 22 21:17:47
CEST 2008 x86_64 GNU/Linux

Gnu C                  4.3.0-4ubuntu1)
Gnu make               3.81
binutils               2.18.50.20080509
util-linux             2.14-rc2
mount                  support
module-init-tools      3.3-pre11
e2fsprogs              1.40.8
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.9.8
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.8.90
Dynamic linker (ldd)   2.8.90
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               6.10
udev                   117
wireless-tools         29
Modules Loaded         iwl4965 i915 microcode acpi_cpufreq
cpufreq_userspace cpufreq_conservative cpufreq_powersave container sbs
sbshc wmi aes_x86_64 dm_crypt rtc_cmos rtc_core rtc_lib kvm_intel kvm
coretemp hwmon sbp2 snd_hda_intel snd_pcm snd_page_alloc snd_hwdep
snd_seq firewire_ohci snd_timer firewire_core snd_seq_device
tpm_infineon crc_itu_t snd tpm tpm_bios psmouse tifm_7xx1 tifm_core ac
button battery intel_agp soundcore ide_pci_generic pata_acpi ohci1394
ieee1394 ata_generic tg3 ehci_hcd uhci_hcd thermal processor fan fuse
usbcore

> - your drivers/usb/core/usbcore.o
Probably to big for the list. You can download it here: http://www.file-upl=
oad.net/download-874690/usbcore.o.html

> Thanks
> Adrian

Thanks
Mirco

--=-oaNuF9kuDu0/6gqUBWlT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIObf6z+diZ7c2xfgRArmaAJsFIyi99eNLJNL3kNZo3VGHPzhvqwCeKZlC
Z1+ASfnVw5rJZwqx3Fj+HKU=
=0Ixe
-----END PGP SIGNATURE-----

--=-oaNuF9kuDu0/6gqUBWlT--

