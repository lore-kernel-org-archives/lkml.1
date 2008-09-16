Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYIPVom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYIPVom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 17:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYIPVof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 17:44:35 -0400
Received: from white.servertr.net ([65.98.57.242]:56201 "EHLO
	white.servertr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYIPVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 17:44:34 -0400
X-Greylist: delayed 5978 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2008 17:44:34 EDT
Subject: Kernel compile warning message (2.6.26.5)
From: Ozgur Karatas <ozgur@ozgurkaratas.com>
Reply-To: ozgur@ozgurkaratas.com
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BigBurUm8M/wofn0PsA1"
Organization: OZGUR KARATAS
Date: Wed, 17 Sep 2008 02:06:39 +0300
Message-Id: <1221606399.12739.40.camel@okaratas-desktop.karatas.tr>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - white.servertr.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ozgurkaratas.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BigBurUm8M/wofn0PsA1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Warning message list kernel (2.6.26.5)

cpu: Intel Celeron D

1.  CC [M]  drivers/pcmcia/i82365.o
drivers/pcmcia/i82365.c: In function =E2=80=98init_i82365=E2=80=99:
drivers/pcmcia/i82365.c:1296: warning: ignoring return value of
=E2=80=98request_irq=E2=80=99, declared with attribute warn_unused_result


2. CC      drivers/pci/search.o
drivers/pci/search.c:145: warning: =E2=80=98pci_find_slot=E2=80=99 is depre=
cated
(declared at drivers/pci/search.c:134)
drivers/pci/search.c:145: warning: =E2=80=98pci_find_slot=E2=80=99 is depre=
cated
(declared at drivers/pci/search.c:134)
drivers/pci/search.c:173: warning: =E2=80=98pci_find_device=E2=80=99 is dep=
recated
(declared at drivers/pci/search.c:166)
drivers/pci/search.c:173: warning: =E2=80=98pci_find_device=E2=80=99 is dep=
recated
(declared at drivers/pci/search.c:166)
drivers/pci/search.c: In function =E2=80=98pci_get_dev_by_id=E2=80=99:
drivers/pci/search.c:284: warning: passing argument 1 of =E2=80=98pci_dev_p=
ut=E2=80=99
discards qualifiers from pointer target type


  CC      drivers/pci/pci-sysfs.o
  CC      drivers/pci/rom.o
  CC      drivers/pci/setup-res.o
  CC      drivers/pci/proc.o
  LD      drivers/pci/hotplug/built-in.o
  CC [M]  drivers/pci/hotplug/acpiphp_core.o
  CC [M]  drivers/pci/hotplug/acpiphp_glue.o
  CC [M]  drivers/pci/hotplug/cpqphp_core.o
  CC [M]  drivers/pci/hotplug/cpqphp_ctrl.o
  CC [M]  drivers/pci/hotplug/cpqphp_sysfs.o
3.  CC [M]  drivers/pci/hotplug/cpqphp_pci.o
drivers/pci/hotplug/cpqphp_pci.c: In function =E2=80=98cpqhp_configure_devi=
ce=E2=80=99:
drivers/pci/hotplug/cpqphp_pci.c:92: warning: =E2=80=98pci_find_slot=E2=80=
=99 is
deprecated (declared at include/linux/pci.h:515)
drivers/pci/hotplug/cpqphp_pci.c:102: warning: =E2=80=98pci_find_slot=E2=80=
=99 is
deprecated (declared at include/linux/pci.h:515)
drivers/pci/hotplug/cpqphp_pci.c: In function
=E2=80=98cpqhp_unconfigure_device=E2=80=99:
drivers/pci/hotplug/cpqphp_pci.c:126: warning: =E2=80=98pci_find_slot=E2=80=
=99 is
deprecated (declared at include/linux/pci.h:515)
drivers/pci/hotplug/cpqphp_pci.c: In function =E2=80=98cpqhp_save_config=E2=
=80=99:
drivers/pci/hotplug/cpqphp_pci.c:420: warning: =E2=80=98pci_find_slot=E2=80=
=99 is
deprecated (declared at include/linux/pci.h:515)


--=-BigBurUm8M/wofn0PsA1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjQO/wACgkQqWyYzdXfEg+auwCdHwycH1FMoDAtqByiOng2zuU4
ewUAoIv5lcgKdDs8lyNk/3A1WyPleh1p
=tiXG
-----END PGP SIGNATURE-----

--=-BigBurUm8M/wofn0PsA1--

