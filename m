Return-Path: <linux-kernel-owner+w=401wt.eu-S1946834AbXD3Vas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946834AbXD3Vas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423675AbXD3Vas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:30:48 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52629 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423421AbXD3VaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:30:15 -0400
X-Sasl-enc: cxySSKHypH5V2nh6HMVh+5FtQpIYghhO1RfNPVpMe78c 1177968614
Message-ID: <46366082.2090701@imap.cc>
Date: Mon, 30 Apr 2007 23:32:50 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>	<46338AEB.2070109@imap.cc>	<20070428141024.887342bd.akpm@linux-foundation.org>	<4636248E.7030309@imap.cc>	<20070430112130.b64321d3.akpm@linux-foundation.org>	<46364346.6030407@imap.cc> <20070430124638.10611058.akpm@linux-foundation.org>
In-Reply-To: <20070430124638.10611058.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEACE2589D3800D1B7F99AAC8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEACE2589D3800D1B7F99AAC8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 30.04.2007 21:46 schrieb Andrew Morton:

>> 2.6.21-final is fine.
>=20
> Sure, but what about 2.6.21-git3 (or, better, current -git)?

OIC. Sorry for being dense. Will check.

>>>  If that's OK then we need to pick through the difference between
>>> 2.6.21-rc7-mm2's driver tree and the patches which went into mainline=
=2E  And
>>> that's a pretty small set.
>> I'm not quite sure how to determine that difference. Can you just prov=
ide
>> me with a list of patches you'd like me to test?
>=20
> Not really - everything's tangled up.  A bisection search on the
> 2.6.21-rc7-mm2 driver tree would be the best bet.

Ok. No prob. It'll just take a bit of time. (Compiling a kernel on
that machine takes about 4 hours.)

I'll be back. :-)

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- Undetected errors are handled as if no error occurred. (IBM) -


--------------enigEACE2589D3800D1B7F99AAC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNmCOMdB4Whm86/kRAhK/AJ4sbnHVvKJ8vjEzkq49VuvE041C0ACfbKNw
7HwTCKZPYg2HoZqndUrLpJs=
=RASc
-----END PGP SIGNATURE-----

--------------enigEACE2589D3800D1B7F99AAC8--
