Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918Ab0AQOgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0AQOgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844Ab0AQOgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:36:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51244 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853Ab0AQOgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:36:06 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-p5tfOD2Mh1kG7tNpCNJa"
Date: Sun, 17 Jan 2010 14:36:01 +0000
Message-ID: <1263738961.8876.28.camel@localhost>
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


--=-p5tfOD2Mh1kG7tNpCNJa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit c024a251e1dd1a39de610bbdc2af65b36e42637d=
:
  David Woodhouse (1):
        Merge from fixed from-kernel tree to fix Matrox firmware binaries

are available in the git repository at:

  http://git.decadent.org.uk/git/linux-firmware.git upstream

I will send patches (missing the binary changes) in reply to this message.

Ben.

Ben Hutchings (5):
      Correct various filenames
      Use 'File:' field name in front of each filename
      Specify drivers using firmware by module/object name
      Update firmware from rt2870sta
      Add RT3090 firmware from rt2860sta

 WHENCE     |  173 ++++++++++++++++++++++++++++++++------------------------=
----
 rt2870.bin |  Bin 4096 -> 4096 bytes
 rt3070.bin |  Bin 0 -> 4096 bytes
 rt3071.bin |  Bin 0 -> 4096 bytes
 rt3090.bin |  Bin 0 -> 8192 bytes
 5 files changed, 92 insertions(+), 81 deletions(-)
 create mode 100644 rt3070.bin
 create mode 100644 rt3071.bin
 create mode 100644 rt3090.bin

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-p5tfOD2Mh1kG7tNpCNJa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS1MgTOe/yOyVhhEJAQLaQQ/8DJsD2oII/gxmb68kb4BtntONkw2IKTnc
dNXnWMC912J34j4GskKz7vmqPFgnX9ej/9JcAqnC4uXS3p9HXd/B80PJYWte+xe7
l3g0eWaqRXgUtG6BPEzaUP5U0obANGCKyhqN0r/29ZeRIAzpWa94FP8KBUgbjZtB
6VyvXbd0azTcx4RqZa2IIYuAcGTmuDm8oOFQf7NWlYy6C3LjmdBvVU3lx2oSpoC6
nHpyc5JS8zYaRkJqaS4aNJyor+6PgGoX45gn76HSdo7StLclJWcnAR56nZHet+Yx
+0Zx/w8ahYwdtAOFW42pkbrS5cbq6Xkx55CVHNmTYunT0Hu5vXOKG+bWtuBcqdaS
Shl784d0LwC0YrL3CMAg9S5y9o8q1HdCTcZNwVtrrbs5sWG/ZpatKQtUmCKkjyJT
YB/TD7twVkqUTUMBysJ1j5MexBmggptMBtJdVJRibxNlSBvoH3igij34XGx5ANJH
XYQ9I8K0/vWoDK0t0/7J+855PiXQJp/lZivue2NpspRuxM4anXt6+jGJXFtotgF2
4YeUL/5s/5f2EYKP9rmgpgvODxHqBDJ2KfUAabb0vFMx/Nw4jdlgBs28aLuVR7W3
3LmfzzTAucYmpD2yWhagm94lSNreaY9QpIqP6cCLpz1U4GiDfFSw9fmUTumZWgZS
XZn1fRgonoc=
=HFeJ
-----END PGP SIGNATURE-----

--=-p5tfOD2Mh1kG7tNpCNJa--
