Return-Path: <linux-kernel-owner+w=401wt.eu-S1030314AbXDZJdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314AbXDZJdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXDZJdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:33:15 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:38074 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030316AbXDZJdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:33:14 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0704261037250.506@yvahk01.tjqt.qr>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <Pine.LNX.4.61.0704261037250.506@yvahk01.tjqt.qr>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RAGykqOBR+NCG7KiL90F"
Date: Thu, 26 Apr 2007 19:33:15 +1000
Message-Id: <1177579995.5025.237.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RAGykqOBR+NCG7KiL90F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 10:38 +0200, Jan Engelhardt wrote:
> On Apr 26 2007 16:04, Nigel Cunningham wrote:
> >
> >Hi again.
> >
> >So - trying to get back to the original discussion - what (if anything)
> >do you see as the way ahead?
> >
> >The options I can think of are (starting with things I can do):
> >
> >1) [...]
> >2) [...]
> >3) [...]
> >4) [...]
> >5) [...]
> >6) [...]
> >7) [...]
>=20
> Perhaps do it the EVMS way? Do as much in userspace as possible, and
> trying having a simple kernel API at the same time.
> Perhaps (3) would be it, but ask Redhat _first_ before quitting anything =
:)

:) Well, the EVMS way is swsusp. Personally, I agree with Linus that
think putting suspend to disk code in userspace is just a broken idea.

Regards,

Nigel

--=-RAGykqOBR+NCG7KiL90F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMHHaN0y+n1M3mo0RAi5IAJ4xTxldtZdyv3Rm+ud90KOne033cgCgm7b6
/1MuWEfm+6NXJhAQ+flx4g8=
=61Sz
-----END PGP SIGNATURE-----

--=-RAGykqOBR+NCG7KiL90F--

