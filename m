Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbXHZRob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbXHZRob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 13:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXHZRoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 13:44:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56416 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbXHZRoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 13:44:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: parisc-linux@lists.parisc-linux.org
Subject: Re: [parisc-linux] errno codes intertwined
Date: Sun, 26 Aug 2007 13:45:42 -0400
User-Agent: KMail/1.9.7
Cc: Jan Engelhardt <jengelh@computergmbh.de>, sparclinux@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       parisc-linux@parisc-linux.org
References: <Pine.LNX.4.64.0708241815540.28540@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708241815540.28540@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1819878.TuRHXF6Vkq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708261345.43165.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1819878.TuRHXF6Vkq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 24 August 2007, Jan Engelhardt wrote:
> So I'm just asking: can I rely on the same errno across Linuxes?

nope

> And should the errno values be fixed up?

i guess that depends on whether you think it's even broken :)

no spec requires any errno symbol have an exact numeric value ... i'm guess=
ing=20
your FUSE is only cross-Linux and you're not planning on dipping into any=20
other OS ?
=2Dmike

--nextPart1819878.TuRHXF6Vkq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iQIVAwUARtG8R0FjO5/oN/WBAQLNaBAAgL/r99LpXcw78k3iY24nKFWFk87IUaeK
HIgQMg2IQm+6LfFvB2iZXdeFjjFIXRgdTMnfXs1G+6W1gR5cXPg0DXzLR98Z5cuU
NPxpS4k2DQq36tnKCekLkV5cM7BzVtzcgJIEuHvxhxBnNavfqCBMkz6BGxHGcfBI
FlNuBWZ/5W/RC0jhJBfTIn7Bz20xJ+PLZ8VDl5a3mmPPq/lJyxG8UBRmffF76B3A
THo85UG1/J48GyNFgTlBz7pNsjDx1U5+xUPEeRRTZcmPsipLuesCn2OHlUcsv2H8
1z73y0DGJUXlKOWrEL0MoH0qbLQNHQHWjZogfyjOd4CxOmFs6Yqire6HPoJ0c3IE
vv4PIn4nGv6LVbsvqWHb/d0x+vBL0jz5d1T/gvS4O8i2mVy91Xpdk6zGxBCsKjo+
w3NS8G9RNxDQTCV594hmeRDdCOoX3DBXp8oKlVKGDSq6uqlA0a8ZxYe5HNvn3C7d
1wxGnhc3wUqDLLPY4vfWBcOGiO+mkR+VUDrFYSKVwAuPZCrpbnj4S/JAfd3swmtP
+u4Y7paErUhVKfM1BsOZ1bAmVetPdKnU+A053sCljPh17Ld6WyoOIG8fYi+KV0qa
0e/0Dpb39nTdxNwCQ0WAnGJJjq4ayOEbcmUTxKMga81giIFbUjPQai1LLNq9Opva
u2c7NlXE12E=
=C4n6
-----END PGP SIGNATURE-----

--nextPart1819878.TuRHXF6Vkq--
