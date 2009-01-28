Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbZA1JkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbZA1JkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbZA1Jj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:39:58 -0500
Received: from naru.obs2.net ([84.20.150.76]:51793 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZA1Jj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:39:58 -0500
X-Greylist: delayed 1516 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2009 04:39:57 EST
Date: Wed, 28 Jan 2009 11:14:38 +0200
From: Riku Voipio <riku.voipio@iki.fi>
To: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] Update email Address of Riku voipio
Message-ID: <20090128091438.GA30378@kos.to>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I have no longer access to the movial.fi mailbox.
Update to use the iki.fi permanent redirector service.

Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
---
 drivers/hwmon/f75375s.c     |    4 ++--
 drivers/leds/leds-pca9532.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 1692de3..d9619b1 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -1,7 +1,7 @@
 /*
  * f75375s.c - driver for the Fintek F75375/SP and F75373
  *             hardware monitoring features
- * Copyright (C) 2006-2007  Riku Voipio <riku.voipio@movial.fi>
+ * Copyright (C) 2006-2007  Riku Voipio <riku.voipio@iki.fi>
  *
  * Datasheets available at:
  *
@@ -721,7 +721,7 @@ static void __exit sensors_f75375_exit(void)
 	i2c_del_driver(&f75375_driver);
 }
=20
-MODULE_AUTHOR("Riku Voipio <riku.voipio@movial.fi>");
+MODULE_AUTHOR("Riku Voipio <riku.voipio@iki.fi>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("F75373/F75375 hardware monitoring driver");
=20
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 76ec749..f68cd73 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -1,7 +1,7 @@
 /*
  * pca9532.c - 16-bit Led dimmer
  *
- * Copyright (C) 2008 Riku Voipio <riku.voipio@movial.fi>
+ * Copyright (C) 2008 Riku Voipio <riku.voipio@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -367,7 +367,7 @@ static void __exit pca9532_exit(void)
 	i2c_del_driver(&pca9532_driver);
 }
=20
-MODULE_AUTHOR("Riku Voipio <riku.voipio@movial.fi>");
+MODULE_AUTHOR("Riku Voipio <riku.voipio@iki.fi>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PCA 9532 LED dimmer");
=20
--=20
1.5.6.5


--=20
"rm -rf" only sounds scary if you don't have backups

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJgCH+ibPvMsrqrwMRAtr+AKCFumOPCRvCedvBClLmONtxICEXiwCglmc4
LEe9escVPeDqCEfrMXKyQFI=
=8e+G
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
