Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbXGVQqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbXGVQqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXGVQpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:45:52 -0400
Received: from 85.8.2.253.se.wasadata.net ([85.8.2.253]:59482 "EHLO
	ittma-hohah.kibibyte.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755589AbXGVQpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:45:51 -0400
X-Greylist: delayed 3561 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jul 2007 12:45:51 EDT
From: Magnus Holmgren <holmgren@lysator.liu.se>
Organization: Lysator ACS
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Date: Sun, 22 Jul 2007 17:46:21 +0200
User-Agent: KMail/1.9.5
In-Reply-To: <20070618110849.GA2450@ff.dom.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1423659.mMMJhYsT45";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707221746.25816@proffe.kibibyte.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1423659.mMMJhYsT45
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'd like to add that the same thing happens to me, though I went directly f=
rom=20
2.6.18 to 2.6.21. Debian-built (-k7) kernel, ne2k_pci NIC, but no skge.

=2D-=20
Magnus Holmgren        holmgren@lysator.liu.se
                       (No Cc of list mail needed, thanks)

  "Exim is better at being younger, whereas sendmail is better for=20
   Scrabble (50 point bonus for clearing your rack)" -- Dave Evans

--nextPart1423659.mMMJhYsT45
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGo3vRk7mRNn1h4+YRAk34AKD92j9jCxV9pd7A1URxR8RScVPohQCeMdnC
sBu0/iS0S5RJSt4jGDKnZgk=
=BsoR
-----END PGP SIGNATURE-----

--nextPart1423659.mMMJhYsT45--
