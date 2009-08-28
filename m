Return-Path: <linux-kernel-owner+w=401wt.eu-S1751455AbZH1Cjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbZH1Cjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 22:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZH1Cjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 22:39:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49392 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbZH1Cji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 22:39:38 -0400
Date: Fri, 28 Aug 2009 12:39:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       zajec5@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-acpi@vger.kernel.org,
       kernel-testers@vger.kernel.org, torvalds@linux-foundation.org,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Message-Id: <20090828123930.4678f9a4.sfr@canb.auug.org.au>
In-Reply-To: <200908281132.19765.rusty@rustcorp.com.au>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
	<200908272023.21288.rusty@rustcorp.com.au>
	<20090827211351.f9c96bfc.sfr@canb.auug.org.au>
	<200908281132.19765.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_Aug_2009_12_39_30_+1000_fTsk0x5/pU9Nep88"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Aug_2009_12_39_30_+1000_fTsk0x5/pU9Nep88
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Fri, 28 Aug 2009 11:32:18 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> On Thu, 27 Aug 2009 08:43:51 pm Stephen Rothwell wrote:
> >=20
> > git quiltimport assumes "mail-like" patches, so it looks for "From:" and
> > "Subject:" lines.  I guess it could be made to use the first line of the
> > patch if there is no subject ...
>=20
> My scripts should all handle Subject: prefixes, I can just start using th=
at.

Thanks, that would be good.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_Aug_2009_12_39_30_+1000_fTsk0x5/pU9Nep88
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqXQ2IACgkQjjKRsyhoI8z4YACgwFxIdfodZI0QK5USteGdBnZ9
NvoAoJt7qbLohkVVihVzZ0QzNkqjlVho
=Bh0w
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Aug_2009_12_39_30_+1000_fTsk0x5/pU9Nep88--
