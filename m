Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXKLT0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXKLT0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbXKLTZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:25:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:36808 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751133AbXKLTZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:25:57 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX185EdQFvq05hXw6PP9VLv59/O7omfLd645lrhqu2R
	SaJs2mEPZnoKBG
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: build #338 failed for 2.6.24-rc2-g6e800af in linux/drivers/md/dm-mpath-hp-sw.c
Date: Mon, 12 Nov 2007 20:25:49 +0100
User-Agent: KMail/1.9.7
References: <200711121333.24398.toralf.foerster@gmx.de> <20071112152100.GA22847@agk.fab.redhat.com>
In-Reply-To: <20071112152100.GA22847@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2346727.1e5LIsNFWz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711122025.53221.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2346727.1e5LIsNFWz
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 12. November 2007 schrieb Alasdair G Kergon:
> On Mon, Nov 12, 2007 at 01:33:21PM +0100, Toralf F=F6rster wrote:
> > the build with the attached .config failed, make ends with:
> > drivers/built-in.o: In function `hp_sw_end_io':
> > dm-mpath-hp-sw.c:(.text+0xb0596): undefined reference to `__scsi_print_=
sense'
> > make: *** [.tmp_vmlinux1] Error 1
> =20
> Does this patch fix it?
>   http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/d=
m-mpath-hp-requires-scsi.patch
>=20
> Alasdair
>=20

Oh yes :-)

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart2346727.1e5LIsNFWz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHOKi9hyrlCH22naMRAg4GAKCqPVhcCiC8TwV/hSBsUO7nDKCKewCfZU3k
TiIhP0mdph3wiOVrlLkN/7Q=
=W8nR
-----END PGP SIGNATURE-----

--nextPart2346727.1e5LIsNFWz--
