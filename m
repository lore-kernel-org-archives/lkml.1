Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYEHAqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYEHAqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYEHAqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:46:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54146 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbYEHAqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:46:24 -0400
Date: Thu, 8 May 2008 10:45:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gentle reminder
Message-Id: <20080508104559.2aa90c7c.sfr@canb.auug.org.au>
In-Reply-To: <20080507132103.574f8778.akpm@linux-foundation.org>
References: <20080507132103.574f8778.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_May_2008_10_45_59_+1000_TXWS6H9vfzAeOdW_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_May_2008_10_45_59_+1000_TXWS6H9vfzAeOdW_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 7 May 2008 13:21:03 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> When adding
>=20
> - new Makefile entries
> - new Kconfig entries
> - new #includes
> - new Documentation/feature-removal-schedule.txt records
> - etc
>=20
> you usually don't *have* to place your new entry right at the end of the
> list.  Doing this maximises the probability of causing collisions with
> other people's work.
>=20
> So, to make life simpler for those who integrate your work, please consid=
er
> putting these entries somewhere other than where-everyone-else-puts-their=
s.
>=20
> You may even find that right-at-the-end wasn't the most appropriate place
> anyway.  But random insertion works well too.

Strongly seconded ....

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_May_2008_10_45_59_+1000_TXWS6H9vfzAeOdW_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIIk1VTgG2atn1QN8RAhI3AJsHhBKSaGP7VEHoPz1VDSRemviSHACfaSt1
VEQEMc/3kX5DCSoF5wamVqU=
=gfub
-----END PGP SIGNATURE-----

--Signature=_Thu__8_May_2008_10_45_59_+1000_TXWS6H9vfzAeOdW_--
