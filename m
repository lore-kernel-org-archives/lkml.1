Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXEAQ4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXEAQ4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXEAQ4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:56:35 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33471 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754818AbXEAQ4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:56:33 -0400
Subject: Re: 2.6.22 -mm merge plans
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IqQA50TJqOTThI7AJ5O/"
Date: Tue, 01 May 2007 10:56:27 -0600
Message-Id: <1178038587.8420.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IqQA50TJqOTThI7AJ5O/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-30 at 16:20 -0700, Andrew Morton wrote:
[snip]
> Mel's moveable-zone work.
>=20
> I don't believe that this has had sufficient review and I'm sure that it
> hasn't had sufficient third-party testing.  Most of the approbations thus=
 far
> have consisted of people liking the overall idea, based on the changelogs=
 and
> multi-year-old discussions.
>=20
> For such a large and core change I'd have expected more detailed reviewin=
g
> effort and more third-party testing.  And I STILL haven't made time to re=
view
> the code in detail myself.
[snip]

I am a fan of this, but I hadn't really realized that it's in -mm, and
that it has to be enabled with kernelcore=3D

Now that I am, I'm running it on my laptop with kernelcore=3D256M (it
wouldn't boot with 128M or less, weird initscript errors and OOMs).

1 GB single-core laptops are probably not the intended test audience :)
But I'll see what happens.
--=20
Zan Lynx <zlynx@acm.org>

--=-IqQA50TJqOTThI7AJ5O/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGN3E7G8fHaOLTWwgRAhIdAJ9e49Rhfq/+WsyshWSYcmuFVt7aqwCcCRno
2aUmJ77bxGjZbxaCUg7+PMY=
=QvFN
-----END PGP SIGNATURE-----

--=-IqQA50TJqOTThI7AJ5O/--

