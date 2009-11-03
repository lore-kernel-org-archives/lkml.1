Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZKCI5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZKCI5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 03:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZKCI5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 03:57:53 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:44599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZKCI5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 03:57:52 -0500
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20091103084744.GH3212@core.coreip.homeip.net>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
	 <1257232587.3420.55.camel@localhost.localdomain>
	 <1257234299.28469.25.camel@johannes.local>
	 <20091103082201.GG3212@core.coreip.homeip.net>
	 <1257237061.28469.43.camel@johannes.local>
	 <20091103084744.GH3212@core.coreip.homeip.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tlsOiG7Ha1iFrFT8JysY"
Date: Tue, 03 Nov 2009 09:57:03 +0100
Message-ID: <1257238623.28469.47.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tlsOiG7Ha1iFrFT8JysY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-03 at 00:47 -0800, Dmitry Torokhov wrote:

> > I just think that it's a matter of courtesy that should be independent
> > from the release cycle to ask the author/maintainer by default, not as =
a
> > second thought ("unless [...] have other solution"). You can always CC
> > Linus and ask him to revert if you don't get a response.
> >=20
> > What's wrong with that? It doesn't actually delay the action, but it
> > makes the discussion much more friendly and cooperative instead of
> > giving the author and maintainer the feeling that their opinion only
> > matters as a second thought.
> >=20
>=20
> I think you are reading too much into who was addressed directly and who
> was "only" CCed...=20

Maybe. But it seems to be happening pretty often recently that people
first ask for a revert and then for a fix, ignoring any thought that
might have gone into a particular commit...

> OK, next time (which I hope won't happen :) )=20

So do I! :)

> I'll just address everyone directly. Will that work?

Much better, at least for me. Hey, I try to respond quickly.

(incidentally, I can't imagine an upstream revert actually helping at
all ... that just creates a merge mess)

johannes

--=-tlsOiG7Ha1iFrFT8JysY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7/BbAAoJEODzc/N7+QmaNLgQAMSl1Ejh/5Dt+PSSAKFt0InI
757zMCa7KNsn0loeNskRKzZXcXpDXDb/WEDRGGoa3tyCrCXnpKNLB6eYxtZp97ZS
f1WzQIY9q5UVMLDfEInHNWHtoN9ZCsexA+SCkKz1Yhtfmjw4geLnSjaqUuAIXmgg
pgf3P7RkHXgrg9sCi6tXAIGs00ZGYz452UXDURYHHEvMRjdGjH6IV7/GUZTLxHae
vN6dX8ceda46cEm5pKB6tKmGBsOFq44I7hFrN9Skk3RvwOEHEEE+o7JS9gUo6tSb
rtuB5fGO6kSj/gh9dioaRWxQNGfLOyFOenVrlXxgSHhGiRirapbAL7oG8K16/Fl9
h+4JnSPuhrsA5EWl6tNuQy93GPE8UneqtkJKU3/r4yW0bCR+h15Llg8PQQ/d0viL
W9f3j78WRYTFai7+L1A9WqkPzaWIwxFNgaDeI/aIGle5GvC/yjyT1X0OuRfnuSlB
/eY/lppyxGb7US3CJnh3MZus8liDyErjFljZLZmM/rDb9pn3L2qe8zG3O4JWQfUs
AxK7FpByU7PCnICUtuTXhETUGqR24vgjvlOGxVMwhZ4K3E1PzoXoseaxdHUp2tRS
lKokZ1KF+BAGKm5fRb/SH+djhRC0iOFS9JDn7Rcgg0rfM+Igtm2hwscIr2V33hRp
LlPjCGrJbw3fkQILF4bD
=ddFN
-----END PGP SIGNATURE-----

--=-tlsOiG7Ha1iFrFT8JysY--

