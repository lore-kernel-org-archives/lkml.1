Return-Path: <linux-kernel-owner+w=401wt.eu-S1763330AbXGFRD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763330AbXGFRD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXGFRDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:03:51 -0400
Received: from systemlinux.org ([83.151.29.59]:41889 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbXGFRDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:03:50 -0400
Date: Fri, 6 Jul 2007 19:00:06 +0200
From: Andre Noll <maan@systemlinux.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
Message-ID: <20070706170006.GA16470@skl-net.de>
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com> <Pine.LNX.4.58.0707061551240.2241@be1.lrz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0707061551240.2241@be1.lrz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:00, Bodo Eggert wrote:

> I've put the complete system into initrams, and I just want the kernel to
> run /sbin/init.

Did you try to exec /sbin/init as the last thing in the init script
of your initramfs? That worked for me some time ago.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGjnUWWto1QDEAkw8RAqujAJ9JBcFe1e5m3DOyT8EGnblNg8otCQCeKSig
UhG8me0cm2P1U8RalRjk/c0=
=NA7u
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
