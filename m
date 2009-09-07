Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbZIGJh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbZIGJh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZIGJh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:37:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46161 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZIGJhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:37:25 -0400
Date: Mon, 7 Sep 2009 19:37:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com
Subject: Re: linux-next: net tree build warning
Message-Id: <20090907193720.f4c2a509.sfr@canb.auug.org.au>
In-Reply-To: <20090907.020423.151248729.davem@davemloft.net>
References: <20090904144232.1f6ccf45.sfr@canb.auug.org.au>
	<20090907.020423.151248729.davem@davemloft.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Sep_2009_19_37_20_+1000_Ra=D=RZ+.ajaVuRR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Sep_2009_19_37_20_+1000_Ra=D=RZ+.ajaVuRR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave, Stephen,

On Mon, 07 Sep 2009 02:04:23 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> Thanks for the report, I'll commit the fix below.
>=20
> Also, Stephen Hemminger has fixed the dlci WAN driver warning
> you reported too.

Thanks for both of these.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Sep_2009_19_37_20_+1000_Ra=D=RZ+.ajaVuRR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqk1FAACgkQjjKRsyhoI8xeDQCfc9JySFWchtsGxEVPjkZ/F6CT
n+YAn2LfTPqeMS5CXzUdQUKVTl2lwJAK
=0qNh
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Sep_2009_19_37_20_+1000_Ra=D=RZ+.ajaVuRR--
