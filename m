Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZHTIZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZHTIZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZHTIZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:25:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59263 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbZHTIZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:25:38 -0400
Date: Thu, 20 Aug 2009 18:25:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: [PATCH V3 linux-next] treewide: remove unnecessary semicolons
Message-Id: <20090820182530.43967787.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LNX.2.00.0908191105570.25797@wotan.suse.de>
References: <1248472866.3498.79.camel@Joe-Laptop.home>
	<alpine.LNX.2.00.0908131155510.25797@wotan.suse.de>
	<1250158868.28285.26.camel@Joe-Laptop.home>
	<alpine.LNX.2.00.0908181359450.25797@wotan.suse.de>
	<1250619515.25478.19.camel@Joe-Laptop.home>
	<alpine.LNX.2.00.0908191105570.25797@wotan.suse.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_Aug_2009_18_25_30_+1000_uO4uPXxsOFlBMCub"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Aug_2009_18_25_30_+1000_uO4uPXxsOFlBMCub
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri, Joe,

On Wed, 19 Aug 2009 11:06:26 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wro=
te:
>
> On Tue, 18 Aug 2009, Joe Perches wrote:
>=20
> > > > > > Previous discussion at: http://lkml.org/lkml/2009/6/28/288
> > > > > > Signed-off-by: Joe Perches <joe@perches.com>
> > > > I could do that or you could "git apply --exclude=3Ddrivers/staging=
/"
> > > > Which do you prefer?
> > > It doesn't apply any more, could you please refresh, resend, and I wi=
ll=20
> > > apply it right away?
> > I used git apply --reject --exclude=3Ddrivers/staging
>=20
> OK, applied, let's see how many conflicts we get.

Suprisingly: none  :-)  (well at least for today)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_Aug_2009_18_25_30_+1000_uO4uPXxsOFlBMCub
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqNCHoACgkQjjKRsyhoI8w1OwCfQV5UzuhNCVevXsh/mVmjue4O
rWEAnAjCSwNJo2rqg9ZgLkHDPGplPIPs
=wBTK
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Aug_2009_18_25_30_+1000_uO4uPXxsOFlBMCub--
