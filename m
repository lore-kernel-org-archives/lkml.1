Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbZFPGnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbZFPGnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbZFPGnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:43:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53270 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZFPGnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:43:00 -0400
Date: Tue, 16 Jun 2009 16:42:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Roel Kluin <roel.kluin@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 powerpc tree
Message-Id: <20090616164257.d7e8d460.sfr@canb.auug.org.au>
In-Reply-To: <20090616061849.GA32109@kroah.com>
References: <20090616155317.d1f1217e.sfr@canb.auug.org.au>
	<20090616061849.GA32109@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Jun_2009_16_42_57_+1000_.Ru1NNGs2YwIrBQd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jun_2009_16_42_57_+1000_.Ru1NNGs2YwIrBQd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 15 Jun 2009 23:18:49 -0700 Greg KH <greg@kroah.com> wrote:
>
> I pushed out an update a number of hours ago (like 6+), so you should
> have gotten it with this update.
>=20
> When did you pull from my tree?  I also just sent a merge request to
> Linus, so everything should be fixed up now.

OK, thanks.  I fetch the trees usually between 8:30am and 10:00am UTC
+1000 (or +1100 in summer), so about 7 hours ago :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Jun_2009_16_42_57_+1000_.Ru1NNGs2YwIrBQd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko3PvEACgkQjjKRsyhoI8wx0QCdFcBRhrSoIDIYL6XzQvm9BdN9
EOsAn0oiH4BUvXJ1NuivpYnFhMIt0AH5
=uo5E
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jun_2009_16_42_57_+1000_.Ru1NNGs2YwIrBQd--
