Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0CEXgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 18:36:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58235 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890Ab0CEXgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 18:36:14 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/nGp8HdwWuCaPdYV6Oc5"
Date: Fri, 05 Mar 2010 23:36:10 +0000
Message-ID: <1267832170.2819.368.camel@localhost>
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


--=-/nGp8HdwWuCaPdYV6Oc5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit 764d482304e3b13024184b05d907fe4c291faa07=
:
  Reinette Chatre (1):
        Update copyright year for iwlwifi licence

are available in the git repository at:

  http://git.decadent.org.uk/git/linux-firmware.git upstream

The one new patch will be sent as a reply to this mail.

Ben Hutchings (7):
      Correct various filenames
      Use 'File:' field name in front of each filename
      Specify drivers using firmware by module/object name
      Update firmware from rt2870sta
      Add RT3090 firmware from rt2860sta
      Add firmware for lgs8g75
      Correct attribution and licence of Sierra Wireless CIS files

 GPL-3      |  676 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 WHENCE     |  191 ++++++++++-------
 lgs8g75.fw |  Bin 0 -> 262 bytes
 rt2870.bin |  Bin 4096 -> 4096 bytes
 rt3070.bin |  Bin 0 -> 4096 bytes
 rt3071.bin |  Bin 0 -> 4096 bytes
 rt3090.bin |  Bin 0 -> 8192 bytes
 7 files changed, 786 insertions(+), 81 deletions(-)
 create mode 100644 GPL-3
 create mode 100644 lgs8g75.fw
 create mode 100644 rt3070.bin
 create mode 100644 rt3071.bin
 create mode 100644 rt3090.bin

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-/nGp8HdwWuCaPdYV6Oc5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS5GVW+e/yOyVhhEJAQKIFQ/6Au6J8N3/GWtlfgIu8+oxpgpFZbLnkPBm
njCpiQxBMyUy+hdT+2N7R+Ke9ZAVdQPPuZhRNRzR24V524MdHUIp5tRwCu6liVxN
gm+lDfdp72HMDNkZfB9spVUIcf/yZA+RPOzmzGVE5+HM+lDlQvnR9wKvWl2X9Kl4
H5pLIQVNeWU6j8OgzvtQ9kaq8BLtGWMO963u+gWCP8u1VffrAm9iarhzO7ES7QNZ
4e8Y3Hz0HcORi5XCZybDw1qRO7I46kr4s9t51TS12psXC39pHlSZHH8dZL1vGBVP
EAs5lkfW1q+Iq/SX7o63vPPUBamFewZtzqRBKQ4pggYgGEFpjlpAMxUemsdaoG2o
9CQUgp3st1zHFYTBKaJLQT1IW+JlJOO1c9nr77Uhlg59wfUo8ThEYm9kzTuVl7ad
B1V4LH8D+1zkg8/gnvPWcOobKEL9ztYUxAbtIy7iQIq4HPdCoC7HxrcY+DYirxT6
YlJTXpd3sK9XYpVOAMsURyduNlyGsywHfdiBRGC9PM/APun+F0DipaUINFlLvM9z
z4AZM/xB9NiekUXdN1dHA+oU1rmQh6fqQAUpOJD8rREo5726u6YTEPd4GhghEJLa
K3T4yQbbljrFNJ/l0Y8rFzdm1hRvCaVV6kX6QzhndOO/B4hZ/9mFWlxMfgSLnzip
X8ZI3XQQJDc=
=ooVd
-----END PGP SIGNATURE-----

--=-/nGp8HdwWuCaPdYV6Oc5--
