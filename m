Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbZH0LN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbZH0LN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZH0LN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:13:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38873 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbZH0LN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:13:57 -0400
Date: Thu, 27 Aug 2009 21:13:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       zajec5@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-acpi@vger.kernel.org,
       kernel-testers@vger.kernel.org, torvalds@linux-foundation.org,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Message-Id: <20090827211351.f9c96bfc.sfr@canb.auug.org.au>
In-Reply-To: <200908272023.21288.rusty@rustcorp.com.au>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
	<200908261833.37310.elendil@planet.nl>
	<20090826123647.e60d9555.akpm@linux-foundation.org>
	<200908272023.21288.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_Aug_2009_21_13_51_+1000_Q1GFTqHHfNWTZJGe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Aug_2009_21_13_51_+1000_Q1GFTqHHfNWTZJGe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Thu, 27 Aug 2009 20:23:20 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> > Rusty/Len: please work out why the title for that patch went silly.
>=20
> git-quiltimport uses the patch names, and doesn't extract the title.  I
> assume that's what Stephen uses.  I didn't rename the patch when I rewrote
> it not to use work_on_cpu.

git quiltimport assumes "mail-like" patches, so it looks for "From:" and
"Subject:" lines.  I guess it could be made to use the first line of the
patch if there is no subject ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_Aug_2009_21_13_51_+1000_Q1GFTqHHfNWTZJGe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqWam8ACgkQjjKRsyhoI8xc8QCfT+TUq0Dx0zrRIjriHbIp3n+z
9k0An3u12Duw+xLno8qu8+pUYrW0+hmM
=+zdC
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Aug_2009_21_13_51_+1000_Q1GFTqHHfNWTZJGe--
