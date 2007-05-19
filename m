Return-Path: <linux-kernel-owner+w=401wt.eu-S1765157AbXESXiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765157AbXESXiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbXESXiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:38:13 -0400
Received: from griffon26.demon.nl ([82.161.57.89]:3397 "EHLO
	griffon26.kfk4ever.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbXESXiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:38:12 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 19:38:11 EDT
Date: Sun, 20 May 2007 01:27:37 +0200
From: Maurice van der Pot <griffon26@kfk4ever.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Uwe Bugla <uwe.bugla@gmx.de>, xfs-masters@oss.sgi.com,
       David Chinner <dgc@sgi.com>, "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       Christoph Lameter <clameter@sgi.com>, Indan Zupancic <indan@nul.nu>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: [2/5] 2.6.22-rc2: known regressions
Message-ID: <20070519232736.GD23900@kfk4ever.com>
References: <464F6DC9.80805@googlemail.com> <464F74C4.5070404@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="89VDYHnQ8ukgENkm"
Content-Disposition: inline
In-Reply-To: <464F74C4.5070404@googlemail.com>
X-PGP-Key: http://www.kfk4ever.com/~griffon26/pubkey.asc
X-URL: http://www.kfk4ever.com/
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--89VDYHnQ8ukgENkm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 20, 2007 at 12:05:56AM +0200, Michal Piotrowski wrote:
> File systems
>=20
> Subject    : File on XFS is truncated at reboot with 2.6.22-rc1
> References : http://bugzilla.kernel.org/show_bug.cgi?id=3D8503
> Submitter  : Maurice van der Pot <griffon26@kfk4ever.com>
> Status     : Unknown

I just noticed the earlier report of this issue in your list of
regressions with patches:

  File systems

  Subject    : 2.6.21-git10/11: files getting truncated on xfs
  References : http://lkml.org/lkml/2007/5/9/410
  Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
  Handled-By : David Chinner <dgc@sgi.com>
  Patch      : http://lkml.org/lkml/2007/5/12/93
  Status     : patch available

I tried the patch and it solves the problem for me as well.

Regards,
Maurice.

--=20
Maurice van der Pot

Gentoo Linux Developer   griffon26@gentoo.org     http://www.gentoo.org
Creator of BiteMe!       griffon26@kfk4ever.com   http://www.kfk4ever.com


--89VDYHnQ8ukgENkm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFGT4foMGnpIbeahxwRApCuAJ96I//uRRhIGnwe6L70DbRVERhsdACfRX3X
R3D2VUz2s+MSjAN4zx4609I=
=u4xV
-----END PGP SIGNATURE-----

--89VDYHnQ8ukgENkm--
