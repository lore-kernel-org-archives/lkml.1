Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXHOOxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXHOOxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932381AbXHOOxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:53:17 -0400
Received: from iucha.net ([209.98.146.184]:43685 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbXHOOxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:53:15 -0400
Date: Wed, 15 Aug 2007 09:53:14 -0500
From: Florin Iucha <florin@iucha.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
	v2.6.23-rc3-50-g28e8351
Message-ID: <20070815145313.GC7124@iucha.net>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 15, 2007 at 04:49:02PM +0200, Jiri Kosina wrote:
> On Wed, 15 Aug 2007, Florin Iucha wrote:
>=20
> > Today my USB keyboard stopped working in the middle of composing and
> > e-mail.  I unplugged it and plugged it back, with no success.  I
> > logged in remotely and found this lovely message:
>=20
> The error message seems unrelated to your keyboard becoming dead.

Yes, it was related to me unplugging it in the hopes that a re-plug
will make it work again ;)

> > I am testing each rcX kernel, and I did not see this problem so far.=20
> > Smells like a new regression.
>=20
> Is that reproducible, or did it happen just once? Any error message=20
> present in log prior to that sysfs dump please?

[See my message to Alan]: It happened twice, within 15 minutes of
boot+login, with 2.6.23-rc3-$whatever .  I does not happen with
2.6.2[123](-rc*)?  After the two incidents, I rebooted in 2.6.23-rc2
and it is working for an hour now.

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGwxNZND0rFCN2b1sRAt+cAJ9jN0QzwxHXlYTULvx/Y7DagdCvpACglEAz
C3D4rErpTSVXPpvA/iu4wBw=
=+9yM
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
