Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbXFKWof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbXFKWof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXFKWo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:44:27 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:35573 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbXFKWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:44:26 -0400
Subject: Re: A kexec approach to hibernation
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <466CAD2D.3070607@zytor.com>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	 <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	 <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz>
	 <20070604122054.GB26615@srcf.ucam.org> <20070604131000.GD1971@elf.ucw.cz>
	 <20070604131624.GA27565@srcf.ucam.org>  <466CAD2D.3070607@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ns5EmZVdH8WauoA6ZItr"
Date: Tue, 12 Jun 2007 08:44:29 +1000
Message-Id: <1181601870.5064.5.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ns5EmZVdH8WauoA6ZItr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sun, 2007-06-10 at 19:02 -0700, H. Peter Anvin wrote:
> Matthew Garrett wrote:
> > No, it only supports ext2 (and reading ext3 as if it's ext2). Right now=
,=20
> > the assumption that syncing during suspend will cause data to hit=20
> > something grub can read isn't a safe one.
>=20
> I brought this issue up quite a few years ago at an OLS BOF.  We pretty
> much need a "supersync" system call; you can do this by bmapping any
> file on ext3, but having something supported across filesystems would be
> good.

Sounds like a good idea to me.

Regards,

Nigel

--=-Ns5EmZVdH8WauoA6ZItr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGbdBNN0y+n1M3mo0RApQcAJ48Q+mPUYhvM4XHaqdNg+azlb5E7QCg2/pN
1b+P4KUJisXfm3ihsExhn+0=
=PR1y
-----END PGP SIGNATURE-----

--=-Ns5EmZVdH8WauoA6ZItr--

