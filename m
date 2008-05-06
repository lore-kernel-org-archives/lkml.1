Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbYEFFg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbYEFFg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYEFFgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:36:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43934 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759721AbYEFFgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:36:00 -0400
Date: Tue, 6 May 2008 15:35:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, andi@lisas.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mchehab@infradead.org
Subject: Re: Linux 2.6.26-rc1
Message-Id: <20080506153552.805240f3.sfr@canb.auug.org.au>
In-Reply-To: <20080505.165501.62584352.davem@davemloft.net>
References: <20080505053935.GA15734@rhlx01.hs-esslingen.de>
	<20080505073030.GI3350@elte.hu>
	<20080506095122.860796f6.sfr@canb.auug.org.au>
	<20080505.165501.62584352.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_May_2008_15_35_52_+1000_YtD0wdulMCwj/RhJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2008_15_35_52_+1000_YtD0wdulMCwj/RhJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 05 May 2008 16:55:01 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 6 May 2008 09:51:22 +1000
>=20
> > I (and I assume Andrew) have been carrying them since then but noone to=
ok
> > them up.  I guess (as Andrew pointed out to me) I should have pushed th=
em.
>=20
> So what should I do now?
>=20
> I have Ingo's IRDA PNP fixes in my net-2.6 tree and that's already
> publicly visible, so I'd need to add revert changesets if people want
> me to remove it.

Do nothing.  I was just making a point about patches getting lost/ignored.
I have dropped my copies from linux-next today.

At least the fixes are now in a tree headed for Linus, soon.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_May_2008_15_35_52_+1000_YtD0wdulMCwj/RhJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIH+48TgG2atn1QN8RAsvuAJ4pxBtUJoqzQSpZHXoBjLi8TfpQoQCbB4Jv
M+enUV6OrOPcolUTO2CPz+I=
=N4jD
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2008_15_35_52_+1000_YtD0wdulMCwj/RhJ--
