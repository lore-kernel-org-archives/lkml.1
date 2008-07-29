Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYG2MPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYG2MPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbYG2MPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:15:25 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbYG2MPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:15:25 -0400
Subject: Re: 2.6.27-rc1: zd1211rw association fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
In-Reply-To: <1217333359.10489.38.camel@johannes.berg> (sfid-20080729_140943_166070_07F28935)
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
	 <200807291049.47342.alistair@devzero.co.uk>
	 <1217326195.10489.10.camel@johannes.berg>  <20080729120442.GE9378@mit.edu>
	 <1217333359.10489.38.camel@johannes.berg>
	 (sfid-20080729_140943_166070_07F28935)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y2mQH8GqJmfh6YWhZwqr"
Date: Tue, 29 Jul 2008 14:15:06 +0200
Message-Id: <1217333706.10489.40.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y2mQH8GqJmfh6YWhZwqr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Yeah, it's really too bad -rc1 got released just before you were able
> > to post the fix to this, since if there were 100 million people who
> > were trying out kernels starting with -git7 that use wireless, there
> > will probably be 200 million people trying out -rc1.  :-)
> >=20
> > Thanks for finding and fixing it, though.  I stopped trying out
> > kernels after -git6 since I was travelling at OSCON, and not having
> > wireless was a show-stopper for me....
>=20
> If everybody's going to decide now to hit on _me_, I'll point out that
> davem's MQ TX changes broke it

Of course that's not strictly true, it had been broken forever, it just
happened to never show up before. And I mean forever, the original
devicescape code that got in was already broken.

johannes

--=-Y2mQH8GqJmfh6YWhZwqr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjwnHAAoJEKVg1VMiehFYZ14P/19rawXslWwYfN0YodvWyRcM
2SLXlNog06zelMyR9CpfAzyzkkhHAMBfTCWWLbN4mJ8anLDQprTXuD2/nK/E1WTF
c5Z6WLlWBFoPeR559j0K34f6nL/4moPVilxKfdOANMnyhUhfKCQfG41iei2BE0NA
cIc+MkXBji1FvgSZgyqnVdVDZ7/aO+KeNsEx4+gM+lGgRDeVNDBMVOhMdvRMHkvy
C4WKP09IeyU+0vW4WYNSj6V3lDRNUF6e0Tdp1vYTxUXq75wSFUQoUbSKBekggIcb
0Z6kWIbLO6Cpf/N7Q6LvSeWtcOYdG/2Py+MXAyGK9TiX9t30H6vwlBwcnhGWNwb3
MPA2SFGSkylzTOXyflsqKzpnMWG8JR6pQ9fOs0kk3Mn/1hbT6xV1m4ZqJKpEAO25
YDUd51AY+oTm9yOY1M5HRjgrzlH0yzoTgaKGgUW1tSJSg/aPmybUyhiJiRbWAqKw
UuaIbPoRxvUXBQ8ZEm4JahKUyKCv8gUp2y5+W9dNUbll0NFS7WpY30Beds7b4vvs
qErAxlAaLDRuknHCBpOI4dqX0n7+scH/dShP2K20wanTqzQOw8RzVZqREXHUAD2A
N4jqdYu9hsVenzUpDSaLFN+mhWsBX5Kt8kZIkEoFR3tH8k2lvb+Fvs0SQJoULWOM
FtH4Ay3sUrfYhE6aLMyX
=Saww
-----END PGP SIGNATURE-----

--=-Y2mQH8GqJmfh6YWhZwqr--

