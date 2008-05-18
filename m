Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYERCW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYERCW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 22:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYERCWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 22:22:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60243 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYERCWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 22:22:48 -0400
Date: Sun, 18 May 2008 12:22:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
Message-Id: <20080518122237.0e4ef71d.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.1.10.0805171715540.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
	<20080517015705.GA20375@mit.edu>
	<alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
	<9a8748490805171545j1811edc9ja0cd5f84105b71c4@mail.gmail.com>
	<alpine.LFD.1.10.0805171715540.3020@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__18_May_2008_12_22_37_+1000_ItBYEBLVZBOaSkf."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__18_May_2008_12_22_37_+1000_ItBYEBLVZBOaSkf.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesper,

On Sat, 17 May 2008 17:35:44 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
>    But I'll actually happily handle trivial merges too, so this is by no=
=20
>    means even a requirement - if the merge ends up being non-trivial, I'l=
l=20
>    let people know anyway and either say "ok, that's so complicated, and =
I=20
>    don't know the area well enough, so can you please do it for me", or=20
>    say "ok, I merged it, but can you please double-check the result".

This is also true for linux-next.

> > Once the 2.6.27 merge window opens, ask you to pull the
> > 'for-linux-2.6.27' branch and once you have done so, leave that branch
> > alone forever.
> >
> > Branch off a new 'for-linux-2.6.28' branch and repeat.
>=20
> Yes. That's a good model.

I just have one request: instead of calling it for-linux-2.6.27, call it
for-next.  The when the merge window opens rename it to for-linus or
current or something and reset for-next to where you want to start
collecting stuff for 2.6.28.  That way you don't have to keep telling me
where the tree I fetch into linux-next is.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__18_May_2008_12_22_37_+1000_ItBYEBLVZBOaSkf.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIL5LyTgG2atn1QN8RAubiAJ9n7zXzASHABqHN4/fvsp8k9uIqgQCfWJPd
mMRBgUCaPxloRZptT7T54Vw=
=zcUd
-----END PGP SIGNATURE-----

--Signature=_Sun__18_May_2008_12_22_37_+1000_ItBYEBLVZBOaSkf.--
