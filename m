Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZH0Xno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZH0Xno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 19:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZH0Xnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 19:43:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40483 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbZH0Xnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 19:43:42 -0400
Date: Fri, 28 Aug 2009 09:43:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, elendil@planet.nl, zajec5@gmail.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-acpi@vger.kernel.org, kernel-testers@vger.kernel.org,
       torvalds@linux-foundation.org, rui.zhang@intel.com, lenb@kernel.org
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Message-Id: <20090828094330.0f7f75d7.sfr@canb.auug.org.au>
In-Reply-To: <20090827143653.52308d6d.akpm@linux-foundation.org>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
	<200908261833.37310.elendil@planet.nl>
	<20090826123647.e60d9555.akpm@linux-foundation.org>
	<200908272023.21288.rusty@rustcorp.com.au>
	<20090827143653.52308d6d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_Aug_2009_09_43_30_+1000_3fCgz2za9/ojxanB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Aug_2009_09_43_30_+1000_3fCgz2za9/ojxanB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Rusty,

On Thu, 27 Aug 2009 14:36:53 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 27 Aug 2009 20:23:20 +0930 Rusty Russell <rusty@rustcorp.com.au> =
wrote:
> >=20
> > Can you take them?  They're not really at home in my tree.
> >=20
> > arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
> > misc:work_on_cpu-acpi.patch
> > misc:work_on_cpu-acpi-fix.patch
> > misc:work_on_cpu-dcdbas.patch
> >=20
> > You can fetch them from http://ozlabs.org/~rusty/kernel/rr-latest/
> >=20
> > (You'll want to rename the last three something sane...)
>=20
> Those patches are already in today's linux-next so I can't carry them.
>=20
> Please email them over in the traditional fashion once that situation
> has sorted itself out?

Those patches will not be in next-20090828.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_Aug_2009_09_43_30_+1000_3fCgz2za9/ojxanB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqXGiIACgkQjjKRsyhoI8xGYgCdF1tV9fC5DVYLkjUp6rmG22vT
+kkAoKNKhLZYwSQbYUlJFhpl7mwGhxxU
=fWnF
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Aug_2009_09_43_30_+1000_3fCgz2za9/ojxanB--
