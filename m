Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZASOiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZASOiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbZASOiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:38:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48492 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZASOiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:38:10 -0500
Date: Tue, 20 Jan 2009 01:37:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Hannes Eder" <hannes@hanneseder.net>
Cc: "David Howells" <dhowells@redhat.com>, "James Morris" <jmorris@namei.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] creds: suppress warning in get_cred
Message-Id: <20090120013759.d2cba912.sfr@canb.auug.org.au>
In-Reply-To: <154e089b0901190303k46b9a223of08923ee11ed873b@mail.gmail.com>
References: <20090119211031.934b4c19.sfr@canb.auug.org.au>
	<154e089b0901190303k46b9a223of08923ee11ed873b@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__20_Jan_2009_01_37_59_+1100_z6KqffCd4Hjhq.cP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Jan_2009_01_37_59_+1100_z6KqffCd4Hjhq.cP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hannes,

On Mon, 19 Jan 2009 12:03:44 +0100 "Hannes Eder" <hannes@hanneseder.net> wr=
ote:
>
> This is most likly a compiler bug, see
>=20
> http://lkml.org/lkml/2008/11/20/441 and followups.

Thanks.  Time for a new cross compiler. :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Jan_2009_01_37_59_+1100_z6KqffCd4Hjhq.cP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl0kEcACgkQjjKRsyhoI8zOAACfVudcSMpLio2RfLQ59GJEfRXU
MjIAoICH8J4WrAKsqBre2jBH/zp1SDNv
=3xUH
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Jan_2009_01_37_59_+1100_z6KqffCd4Hjhq.cP--
