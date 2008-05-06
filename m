Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbYEFFtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbYEFFtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762611AbYEFFss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:48:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36097 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762592AbYEFFsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:48:46 -0400
Date: Tue, 6 May 2008 15:48:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Mohr <andi@lisas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Linux 2.6.26-rc1
Message-Id: <20080506154830.aa7e1b2d.sfr@canb.auug.org.au>
In-Reply-To: <20080506001751.GA22499@elte.hu>
References: <8287f540805041818g534c4e02qaadb0e749c5f3439@mail.gmail.com>
	<20080505053935.GA15734@rhlx01.hs-esslingen.de>
	<20080505073030.GI3350@elte.hu>
	<20080506095122.860796f6.sfr@canb.auug.org.au>
	<20080506001751.GA22499@elte.hu>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_May_2008_15_48_30_+1000_nEr/skdXXMzJ1AHz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2008_15_48_30_+1000_nEr/skdXXMzJ1AHz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Tue, 6 May 2008 02:17:52 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > This was discovered in linux-next and a patch posted on March 28 ...
>=20
> hm, i do searches on lkml before posting patches but i cannot do=20
> searches on _every_ mailing list where patches might show up. There's=20
> just 30 hours in a day ;-)

They were both posted on lkml ... and I do appreciate your efforts.

> perhaps linux-next should propagate all add-on fix patches it is=20
> carrying against subsystem trees if they are still relevant to -git,=20
> once the subsystem tree goes to -git, and re-post them to lkml in that=20
> case, to avoid duplicative work? Once it's on lkml i think most=20
> subsystem maintainers will find any missing patches.

See above and what you quoted below.

> > I (and I assume Andrew) have been carrying them since then but noone=20
> > took them up.  I guess (as Andrew pointed out to me) I should have=20
> > pushed them.
>=20
> yeah.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_May_2008_15_48_30_+1000_nEr/skdXXMzJ1AHz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIH/E6TgG2atn1QN8RAj/pAJ4u3zXPqFEN5M/bQhl4FGpB0tw+swCeIdiC
B7+F9+2ddKiB5Fv9y8EqFHw=
=mG8l
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2008_15_48_30_+1000_nEr/skdXXMzJ1AHz--
