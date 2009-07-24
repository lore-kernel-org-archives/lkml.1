Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZGXBMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZGXBMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 21:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZGXBMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 21:12:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55842 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbZGXBMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 21:12:46 -0400
Date: Fri, 24 Jul 2009 11:12:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chaithrika U S <chaithrika@ti.com>,
       Pavel Kiryukhin <pkiryukhin@ru.mvista.com>,
       Naresh Medisetty <naresh@ti.com>, Steve Chen <schen@mvista.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Subject: Re: linux-next: manual merge of the sound tree with the davinci
 tree
Message-Id: <20090724111242.4156c6f9.sfr@canb.auug.org.au>
In-Reply-To: <s5h7hxzngg5.wl%tiwai@suse.de>
References: <20090723112110.e42430e9.sfr@canb.auug.org.au>
	<s5hvdlkvsk6.wl%tiwai@suse.de>
	<873a8ni8t7.fsf@deeprootsystems.com>
	<s5h7hxzngg5.wl%tiwai@suse.de>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Jul_2009_11_12_42_+1000_9np3rPAK7dAgHe31"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Jul_2009_11_12_42_+1000_9np3rPAK7dAgHe31
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi, Kevin,

On Fri, 24 Jul 2009 01:10:50 +0200 Takashi Iwai <tiwai@suse.de> wrote:
>
> At Thu, 23 Jul 2009 10:54:44 -0700,
> Kevin Hilman wrote:
> >=20
> > I've taken care of this in the DaVinci for-next branch.
> >=20
> > I dropped the davinci changes that change code that were then dropped
> > by the asoc changes.
>=20
> Ah, great.  Then I revert a fix merge in my for-next branch and keep
> only pure ASoC things.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Jul_2009_11_12_42_+1000_9np3rPAK7dAgHe31
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkppCooACgkQjjKRsyhoI8zlewCgjWKJ8COez0EMIqm9VMx+1hRa
U/QAoIydR+qbBZhG/92ZREQNR/f2XKnO
=UNQR
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jul_2009_11_12_42_+1000_9np3rPAK7dAgHe31--
