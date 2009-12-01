Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbZLAK5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbZLAK5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZLAK5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:57:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53200 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZLAK5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:57:06 -0500
Date: Tue, 1 Dec 2009 21:57:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 1
Message-Id: <20091201215701.9e121809.sfr@canb.auug.org.au>
In-Reply-To: <20091201102900.GA11715@sirena.org.uk>
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
	<20091201102900.GA11715@sirena.org.uk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Dec_2009_21_57_01_+1100_khADc9Aigv.f8r+4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Dec_2009_21_57_01_+1100_khADc9Aigv.f8r+4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, 1 Dec 2009 10:29:01 +0000 Mark Brown <broonie@opensource.wolfsonmic=
ro.com> wrote:
>
> On Tue, Dec 01, 2009 at 07:03:01PM +1100, Stephen Rothwell wrote:
>=20
> > Merging sound/for-next
> > Applying: ASoC: tlv320dac33: Change RT wq to singlethread wq
>=20
> According to this the sound tree should be being merged into the next
> tree but when I look in the master branch of your git I'm not seeing any
> sign of it - am I missing something here?  The head of your master
> branch that I see is 16aa56906ae11bfdb145676a5fb5c5f43394148d "Add
> linux-next specific files for 20091201".
>=20
> The same thing happened yesterday.

Thanks for letting me know.  A bug in my procedures.  It will be fixed
tomorrow, sorry for the inconvenience.

Because the above patch is no longer needed all the changes in the sound
tree have been applied in the merge of the crypto tree, so all the
changes are there, just not very obvious.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Dec_2009_21_57_01_+1100_khADc9Aigv.f8r+4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksU9n0ACgkQjjKRsyhoI8xRFACdFwGR3sxGKV+CuJPP1jIPU4Ct
pcoAoIvPDh2uKVxFxSQL/HZbC4nUZ0wT
=0tR1
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Dec_2009_21_57_01_+1100_khADc9Aigv.f8r+4--
