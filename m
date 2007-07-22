Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbXGVXmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbXGVXmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762037AbXGVXmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:42:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60902 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759961AbXGVXmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:42:44 -0400
X-Sasl-enc: IVTXhgTJPmXO6YkBA2OjlN/VCVMqN3sQeS83wIcRshO9 1185147760
Message-ID: <46A3EC92.3050504@imap.cc>
Date: Mon, 23 Jul 2007 01:47:30 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.22-git17 boot failure
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig085C44528C9E54DBFA73BA3F"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig085C44528C9E54DBFA73BA3F
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On my test machine with a Pentium D 940 processor, Intel DQ965GF
mainboard and SATA disks, kernel 2.6.22-git17 (32 bit build) fails
to come up because it cannot find the disk drives. Same issue
with a clone of the 'linus' git tree. Anything known?

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig085C44528C9E54DBFA73BA3F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGo+ySMdB4Whm86/kRApedAJ9mH8sIu6dzEwGrqP5TLF53IwJafACfaJMZ
/JrR5FynY8wNiDROJ2sQsA8=
=ORop
-----END PGP SIGNATURE-----

--------------enig085C44528C9E54DBFA73BA3F--
