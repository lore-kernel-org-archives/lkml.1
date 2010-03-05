Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0CEQTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:19:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab0CEQTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:19:15 -0500
Subject: Re: [git pull] drm request 3
From: Adam Jackson <ajax@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <alpine.LFD.2.00.1003041458140.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	 <20100304185002.GA23532@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	 <20100304190450.GA23807@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
	 <1267741697.1316.16.camel@atropine.boston.devel.redhat.com>
	 <alpine.LFD.2.00.1003041458140.3751@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5lFdl5JhIfysyjrfGkKB"
Date: Fri, 05 Mar 2010 11:18:16 -0500
Message-Id: <1267805896.1316.112.camel@atropine.boston.devel.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5lFdl5JhIfysyjrfGkKB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-03-04 at 15:03 -0800, Linus Torvalds wrote:
> On Thu, 4 Mar 2010, Adam Jackson wrote:
> > On Thu, 2010-03-04 at 11:14 -0800, Linus Torvalds wrote:=20
> > > Two wrong choices don't make a right.
> >=20
> > So unmerge it.
>=20
> That's what I told people I can do (I'd just revert that commit).

Read it more strongly: drop nouveau from your tree entirely.

Don't give me any "not a solution" nonsense about that.  The problem is
entirely that your expectations for interface stability [1] in your tree
do not match nouveau's development model and will not for the forseeable
future.  Yes, they should htfu and version interfaces like real men.
But they're not going to, so either enforce your rule or don't.

[1] - apparently ignorable when it's inconvenient, but let's not turn
this into a sysfs argument.

- ajax

--=-5lFdl5JhIfysyjrfGkKB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuRLscACgkQW4otUKDs0NM/dQCg397L6F70SPP28ln9cFxezw6E
2fYAnRQP/is2kRpFgP4nF9gUwX0Hf+qX
=dKvM
-----END PGP SIGNATURE-----

--=-5lFdl5JhIfysyjrfGkKB--

