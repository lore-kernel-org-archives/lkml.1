Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYF3De3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYF3De3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 23:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYF3DeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 23:34:19 -0400
Received: from smtp.rutgers.edu ([128.6.72.243]:46256 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751667AbYF3DeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 23:34:18 -0400
X-Greylist: delayed 2007 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jun 2008 23:34:18 EDT
From: Michael Wu <flamingice@sourmilk.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Comment out duplicate device entry
Date: Sun, 29 Jun 2008 23:04:52 -0400
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ben Collins <ben.collins@canonical.com>,
       Linus Torvalds <torvalds@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
References: <1214495838.7150.10.camel@cunning> <20080626161152.GE22025@cs181140183.pp.htv.fi>
In-Reply-To: <20080626161152.GE22025@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart41893139.k7kBxD6hNI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200806292304.58429.flamingice@sourmilk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart41893139.k7kBxD6hNI
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 26 June 2008 12:11:52 Adrian Bunk wrote:
> But it shouldn't be listed as both version 1 and version 2 device.
>
It could be both! They're a bit lazy about changing usb/pci ids with differ=
ent=20
cards anyway so I wouldn't be surprised. The driver differentiates the devi=
ce=20
version using a more reliable method anyway so it doesn't matter. This devi=
ce=20
id list was just copied from the islsm driver so I can't say for sure if=20
there's both version 1 and version 2 devices sharing the same usb id.

=2DMichael Wu

--nextPart41893139.k7kBxD6hNI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIaE1aT3Oqt9AH4aERAvNaAJ95oDEvidMJdzz0s/7wL0UmI7Z02gCeKFD9
8AZsrQeSviJM72Y+K9umHvg=
=xL9Z
-----END PGP SIGNATURE-----

--nextPart41893139.k7kBxD6hNI--
