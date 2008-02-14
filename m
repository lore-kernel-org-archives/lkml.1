Return-Path: <linux-kernel-owner+w=401wt.eu-S933771AbYBNWY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbYBNWY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYBNWYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:24:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38220 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487AbYBNWYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:24:19 -0500
Date: Fri, 15 Feb 2008 09:24:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-Id: <20080215092414.097bfb15.sfr@canb.auug.org.au>
In-Reply-To: <20080214153850.486f8205@gaivota>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<20080214153850.486f8205@gaivota>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Feb_2008_09_24_14_+1100_cJMtH7GYWm_q0_JN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2008_09_24_14_+1100_cJMtH7GYWm_q0_JN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Thu, 14 Feb 2008 15:38:50 -0200 Mauro Carvalho Chehab <mchehab@infradead=
.org> wrote:
>
> Please add v4l-dvb tree, at:
>=20
> ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
>=20
> The above tree has two branches: 'master' and 'stable'
>=20
> Both branches will have V4L/DVB next patches. The first is against your m=
aster,
> and the second, against your stable.
>=20
> I've opted to have both trees, since probably 'stable' is the better opti=
on for
> you to clone. On the other hand, 'master' allow me to foresee if an "alie=
n"
> patch would conflict with a subsystem patch.

OK, this looks good (I should read ahead in my email before
replying :-)).  I will fetch the stable branch of this tree instead of
the previous tree you sent me, OK?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Feb_2008_09_24_14_+1100_cJMtH7GYWm_q0_JN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtL+STgG2atn1QN8RAkk+AJ9kK79k7f/ZqJYuCpEvtSoYdX8WjwCglin4
Guc9a2x+VPgfvkdSRPlNXN4=
=Tjx5
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2008_09_24_14_+1100_cJMtH7GYWm_q0_JN--
