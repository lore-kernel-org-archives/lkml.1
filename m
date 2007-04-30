Return-Path: <linux-kernel-owner+w=401wt.eu-S1946718AbXD3TZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946718AbXD3TZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946717AbXD3TZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:25:52 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47651 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946720AbXD3TZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:25:26 -0400
X-Sasl-enc: BQX26he5eCrtXwLItRBVIJfGolI2DBpMQ7QLzaEGCiNt 1177961125
Message-ID: <46364346.6030407@imap.cc>
Date: Mon, 30 Apr 2007 21:28:06 +0200
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
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>	<46338AEB.2070109@imap.cc>	<20070428141024.887342bd.akpm@linux-foundation.org>	<4636248E.7030309@imap.cc> <20070430112130.b64321d3.akpm@linux-foundation.org>
In-Reply-To: <20070430112130.b64321d3.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6850B0B8D4D50A301B397375"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6850B0B8D4D50A301B397375
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 30.04.2007 20:21 schrieb Andrew Morton:
> A lot of Greg's driver tree has gone upstream, so please check current
> mainline.

2.6.21-final is fine.

>  If that's OK then we need to pick through the difference between
> 2.6.21-rc7-mm2's driver tree and the patches which went into mainline. =
 And
> that's a pretty small set.

I'm not quite sure how to determine that difference. Can you just provide=

me with a list of patches you'd like me to test?

Thanks,
Tilman

--=20
Tilman Schmidt                                  E-Mail: tilman@imap.cc
Wehrhausweg 66                                  Fax: +49 228 4299019
53227 Bonn
Germany


--------------enig6850B0B8D4D50A301B397375
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNkNOMdB4Whm86/kRAtHKAJ9Pl1M57E0ot8J4Je7eZzDk10247QCbBLDP
R9dJxM+2y6xZgu9rjy/dEbE=
=K3Ic
-----END PGP SIGNATURE-----

--------------enig6850B0B8D4D50A301B397375--
