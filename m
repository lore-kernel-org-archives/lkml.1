Return-Path: <linux-kernel-owner+w=401wt.eu-S967122AbXEHUqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967122AbXEHUqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934320AbXEHUqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:46:47 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44624 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934310AbXEHUqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:46:46 -0400
Message-ID: <4640E17E.7090909@drzeus.cx>
Date: Tue, 08 May 2007 22:45:50 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-28672-1178657204-0001-2"
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-28672-1178657204-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-=
linus

to receive the following updates:

 drivers/misc/tifm_7xx1.c   |   27 ++++++++++++++++++++++++---
 drivers/mmc/Kconfig        |   10 +++++-----
 drivers/mmc/card/Kconfig   |    3 +--
 drivers/mmc/core/Kconfig   |    1 -
 drivers/mmc/core/core.c    |   10 ++++++----
 drivers/mmc/host/Kconfig   |   19 +++++++++----------
 drivers/mmc/host/tifm_sd.c |   13 +------------
 include/linux/tifm.h       |    1 +
 8 files changed, 47 insertions(+), 37 deletions(-)

Alex Dubov (1):
      disable socket power in adapter driver instead of media one

Jan Engelhardt (1):
      mmc: Use menuconfig objects

Pierre Ossman (1):
      mmc: use lock instead of claim in debug check



--=_hera.drzeus.cx-28672-1178657204-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGQOF+7b8eESbyJLgRAqHYAKDQPEMsYw/kyOgwHpbsl8WWzlxwaACfZuYM
2AD3ti9sfexglBQYMRkNALU=
=FEAR
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-28672-1178657204-0001-2--
