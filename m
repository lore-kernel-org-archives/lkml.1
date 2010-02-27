Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230Ab0B0V2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:28:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56279 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933277Ab0B0V2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:28:00 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pX7LaaT74zBFAB893/SH"
Date: Sat, 27 Feb 2010 21:27:56 +0000
Message-ID: <1267306076.16186.103.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Please pull 'upstream' branch of
 http://git.decadent.org.uk/git/linux-firmware.git
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pX7LaaT74zBFAB893/SH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit 764d482304e3b13024184b05d907fe4c291faa07=
:
  Reinette Chatre (1):
        Update copyright year for iwlwifi licence

are available in the git repository at:

  http://git.decadent.org.uk/git/linux-firmware.git upstream

I will send patches (missing the binary changes) in reply to this message.

Ben.

Ben Hutchings (6):
      Correct various filenames
      Use 'File:' field name in front of each filename
      Specify drivers using firmware by module/object name
      Update firmware from rt2870sta
      Add RT3090 firmware from rt2860sta
      Add firmware for lgs8g75

 WHENCE     |  182 +++++++++++++++++++++++++++++++++-----------------------=
----
 lgs8g75.fw |  Bin 0 -> 262 bytes
 rt2870.bin |  Bin 4096 -> 4096 bytes
 rt3070.bin |  Bin 0 -> 4096 bytes
 rt3071.bin |  Bin 0 -> 4096 bytes
 rt3090.bin |  Bin 0 -> 8192 bytes
 6 files changed, 101 insertions(+), 81 deletions(-)
 create mode 100644 lgs8g75.fw
 create mode 100644 rt3070.bin
 create mode 100644 rt3071.bin
 create mode 100644 rt3090.bin

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.

--=-pX7LaaT74zBFAB893/SH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS4mOVue/yOyVhhEJAQJlVg/+PwqeKThZs38SiiytbaEiLKpqPgq8a/JX
LnFucd4N42NmeR5zNxda3COpmxLBtw10Q+nFS5Aru9R7cdhQESSHUXyWvS9x7Pvr
jX46gEhJt+XzK8fpGV7nfQXOMkqdYW2Lg5BjO6Gun7Ah3gg57tv2y8X694EHRejs
66kTIrfydt5TqnkY6UFtWw6BWSq85OHS+Rf6SCJghpaWApM2Bd+nOqgWpTWuO0zX
N0eVgs9jGye2PBWT8UdLyTPwRz4pqVAVCGLsr50MPJe/f3O+bcHk+GRWbp/yzOH7
g0S+6IZrKD6bwVxvk203AvZkLCDqxGne/8VJ+HOWsn4QlQrPX77rIZyLCfyZCWeb
5oqYiGOx36d1wWLKLIWkXVV5ZqCxOI+43TKsldpo4cBTYlmo/g7GPp46kFxcpY7e
AbbL6RdioVZYkgEQ0XNbtrdAISdeNfzBWh50LbaQfYdyy5Z4AztaNnpsU3mIlDUd
Y49GyL3hFLCS5oxIRMVrwuVMxKmeUU2P3eWXyWd8RpAAxSAeeOhaJ0dhDQ9laNu+
jVLt2oNZo4nmtRyq55xa9jOprTB+i4ucbMu5DoO1l1m/GN+YxL8yXgleaWaTji+O
OI8KjFIF8TLmvsOeNs5GZPJbqH8tJdnWvkjXr1Awhc9fTKZEuo/nB6sGTSLn1+jj
QKb48umGQnI=
=AYrq
-----END PGP SIGNATURE-----

--=-pX7LaaT74zBFAB893/SH--
