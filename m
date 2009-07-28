Return-Path: <linux-kernel-owner+w=401wt.eu-S1751390AbZG1EWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbZG1EWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZG1EWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:22:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52618 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZG1EWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:22:33 -0400
Date: Tue, 28 Jul 2009 14:22:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: keil@b1-systems.de, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: tree build failure
Message-Id: <20090728142227.e9d90179.sfr@canb.auug.org.au>
In-Reply-To: <20090727.080617.30802851.davem@davemloft.net>
References: <20090727175328.fe3197a5.sfr@canb.auug.org.au>
	<200907271121.34348.keil@b1-systems.de>
	<20090727.080617.30802851.davem@davemloft.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Jul_2009_14_22_27_+1000_A2vag_Rb0S/dv.Tz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Jul_2009_14_22_27_+1000_A2vag_Rb0S/dv.Tz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave, Karsten,

On Mon, 27 Jul 2009 08:06:17 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Karsten Keil <keil@b1-systems.de>
> Date: Mon, 27 Jul 2009 11:21:33 +0200
>=20
> > Sorry for that, yes this fix is correct - I really should test allyesco=
nfig=20
> > more times by myself  :-(.

I don't really expect people to do allyesconfig build very often.

> > ACK.
>=20
> Applied.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Jul_2009_14_22_27_+1000_A2vag_Rb0S/dv.Tz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpufQMACgkQjjKRsyhoI8yjGwCgsbL4fc64OHlfUSRY04NwvBoC
p3UAoJgqmQ23Et4ehssdDljR9jqEJ+DK
=9h4g
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Jul_2009_14_22_27_+1000_A2vag_Rb0S/dv.Tz--
