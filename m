Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYGRX7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYGRX7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYGRX7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:59:17 -0400
Received: from server.drzeus.cx ([85.8.24.28]:38526 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753493AbYGRX7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:59:16 -0400
Date: Sat, 19 Jul 2008 01:59:11 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates for 2.6.27-rc1
Message-ID: <20080719015911.02faddf6@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-24260-1216425555-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-24260-1216425555-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 drivers/mmc/host/au1xmmc.c |   54 ++++++++++++++++++++++++++++++++++------=
---
 drivers/mmc/host/pxamci.c  |    2 +-
 drivers/mmc/host/s3cmci.c  |   50 +++++++++++++++++++++++++---------------
 3 files changed, 74 insertions(+), 32 deletions(-)

Ben Dooks (2):
      s3cmci: fixes for section mismatch warnings
      s3cmci: ensure host stopped on machine shutdown

Karl Beldan (1):
      pxamci: trivial fix of DMA alignment register bit clearing

Manuel Lauss (1):
      au1xmmc: suspend/resume implementation

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-24260-1216425555-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiBLlIACgkQ7b8eESbyJLhIcACgjzPeSfgtq3scU2hLdEPxJMgL
NEwAoIi+RAR6LfK6gDM9Z3wBw9XYHDso
=i8Ys
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-24260-1216425555-0001-2--
