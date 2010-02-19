Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0BSGw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:52:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52854 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab0BSGwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:52:25 -0500
Date: Fri, 19 Feb 2010 17:52:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: import of usb series failed
Message-Id: <20100219175218.10025a7a.sfr@canb.auug.org.au>
In-Reply-To: <20100218132221.b15d151f.sfr@canb.auug.org.au>
References: <20100218105500.898ece5e.sfr@canb.auug.org.au>
	<20100218002144.GA17850@kroah.com>
	<20100218132221.b15d151f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Feb_2010_17_52_18_+1100_FgRRwM+U_zlqLOmR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Feb_2010_17_52_18_+1100_FgRRwM+U_zlqLOmR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 18 Feb 2010 13:22:21 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Wed, 17 Feb 2010 16:21:44 -0800 Greg KH <greg@kroah.com> wrote:
> >
> > Very wierd, you must have gotten this just as I updated my tree.  It
>=20
> Yeah, that is possible.
>=20
> > should all be fine tomorrow, if not, please let me know.
>=20
> Great, thanks.

I got the same today.  Is this a case of Git being a bit more picky about
applying patches that quilt?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Feb_2010_17_52_18_+1100_FgRRwM+U_zlqLOmR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt+NSIACgkQjjKRsyhoI8xJCQCfbVj/HknsG2xZL9E5ZYpyCEzn
K58AnjmnqpiqIpB/Gc5srjmwylhVwvzH
=Ewgs
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Feb_2010_17_52_18_+1100_FgRRwM+U_zlqLOmR--
