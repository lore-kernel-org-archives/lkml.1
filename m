Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbYFOPPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbYFOPPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 11:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbYFOPPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 11:15:07 -0400
Received: from impaqm1.telefonica.net ([213.4.149.61]:20505 "EHLO
	IMPaqm1.telefonica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbYFOPPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 11:15:06 -0400
Date: Sun, 15 Jun 2008 17:15:01 +0200
From: =?ISO-8859-1?Q?Jes=FAs?= Guerrero <i92guboj@terra.es>
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: update ntfs help text
Message-Id: <20080615171501.8b3a18f5.i92guboj@terra.es>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__15_Jun_2008_17_15_01_+0200_vuMANE3ML5XQpC1A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__15_Jun_2008_17_15_01_+0200_vuMANE3ML5XQpC1A
Content-Type: multipart/mixed;
 boundary="Multipart=_Sun__15_Jun_2008_17_15_01_+0200_bitpAx/E=vjLBQBR"


--Multipart=_Sun__15_Jun_2008_17_15_01_+0200_bitpAx/E=vjLBQBR
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,=20

I think that the url in the help text for ntfs should be updated.

Trivial patch attached.

--=20
Jes=FAs Guerrero <i92guboj@terra.es>

--Multipart=_Sun__15_Jun_2008_17_15_01_+0200_bitpAx/E=vjLBQBR
Content-Type: text/x-patch;
 name="ntfs-linux.patch"
Content-Disposition: attachment;
 filename="ntfs-linux.patch"
Content-Transfer-Encoding: quoted-printable

--- fs/Kconfig.orig	2008-06-15 17:11:04.000000000 +0200
+++ fs/Kconfig	2008-06-15 17:11:40.000000000 +0200
@@ -803,7 +803,7 @@
 	  from the project web site.
=20
 	  For more information see <file:Documentation/filesystems/ntfs.txt>
-	  and <http://linux-ntfs.sourceforge.net/>.
+	  and <http://www.linux-ntfs.org/doku.php>.
=20
 	  To compile this file system support as a module, choose M here: the
 	  module will be called ntfs.

--Multipart=_Sun__15_Jun_2008_17_15_01_+0200_bitpAx/E=vjLBQBR--

--Signature=_Sun__15_Jun_2008_17_15_01_+0200_vuMANE3ML5XQpC1A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhVMfoACgkQXJ+pkIOP8Dw9TQCfTidliA6N55L5JovkoHm/dvL3
x5YAn3R019VBIheFUGH/H379rqdg277W
=vVr3
-----END PGP SIGNATURE-----

--Signature=_Sun__15_Jun_2008_17_15_01_+0200_vuMANE3ML5XQpC1A--
