Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZDNOlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZDNOlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZDNOl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:41:29 -0400
Received: from mxpdbe1.wincor-nixdorf.com ([80.154.98.129]:41647 "EHLO
	mxpdbe1.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbZDNOl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:41:28 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 10:41:28 EDT
Message-ID: <49E49E25.6060601@wincor-nixdorf.com>
Date: Tue, 14 Apr 2009 16:31:01 +0200
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: trivial@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] serial: remove contact data
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig623B2C7C64914979B607C0B7"
X-OriginalArrivalTime: 14 Apr 2009 14:34:43.0529 (UTC) FILETIME=[26D27B90:01C9BD0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig623B2C7C64914979B607C0B7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Remove my name and emailaddress from note in the source. Wincor Nixdorf
only has some ITE-chips on their mainboards, other chips are not
available for me for testing.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
---
 drivers/serial/8250_pci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 533f820..9d646b0 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -612,8 +612,6 @@ static int pci_netmos_init(struct pci_dev *dev)
 }
=20
 /*
- * ITE support by Niels de Vos <niels.devos@wincor-nixdorf.com>
- *
  * These chips are available with optionally one parallel port and up to=

  * two serial ports. Unfortunately they all have the same product id.
  *
--=20
1.5.5.6



--------------enig623B2C7C64914979B607C0B7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJ5J4l5KAkGQPO/QoRAnwiAKCL6pQ6yEcaDiNBa/0ChH7aB1S3OACfU/FI
P14/agJUFgGihYe5h2s8swg=
=Qe5H
-----END PGP SIGNATURE-----

--------------enig623B2C7C64914979B607C0B7--
