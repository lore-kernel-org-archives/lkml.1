Return-Path: <linux-kernel-owner+w=401wt.eu-S934378AbZLFXAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378AbZLFXAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934342AbZLFXAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:00:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58751 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934341AbZLFXAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:00:06 -0500
Date: Mon, 7 Dec 2009 10:00:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?UTF-8?B?RnLDqWTDqXJp?= =?UTF-8?B?Yw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] bkl core patches for 2.6.33
Message-Id: <20091207100006.8700390c.sfr@canb.auug.org.au>
In-Reply-To: <20091206185221.GA16319@elte.hu>
References: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain>
	<alpine.LFD.2.00.0912061044530.3560@localhost.localdomain>
	<20091206185221.GA16319@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Dec_2009_10_00_06_+1100_g2BwkG+s_u3/EO.X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Dec_2009_10_00_06_+1100_g2BwkG+s_u3/EO.X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, 6 Dec 2009 19:52:21 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>=20
> > Hmm. Seeing this, I wonder: has anybody kept track of the reiserfs bkl=
=20
> > removal?
>=20
> I've Cc:-ed Frederic - he's been hacking away on it diligently, for=20
> months meanwhile. Frederic, mind posting the URI to your tree?

The tree in linus-next is:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git#r=
eiserfs/kill-bkl

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Dec_2009_10_00_06_+1100_g2BwkG+s_u3/EO.X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkscN3YACgkQjjKRsyhoI8xQXQCcCLwRyf5KfpJLyh1gka+Cu33U
TfwAn3331Bz01V1gZzsYoF8Q1oXBKoMe
=gz5v
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Dec_2009_10_00_06_+1100_g2BwkG+s_u3/EO.X--
