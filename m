Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZFTHR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZFTHR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 03:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZFTHRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 03:17:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43321 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZFTHRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 03:17:46 -0400
Date: Sat, 20 Jun 2009 17:17:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tero Saarni <tero.saarni@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: input tree build warnings
Message-Id: <20090620171743.1ef11ef2.sfr@canb.auug.org.au>
In-Reply-To: <20090620060559.GA7710@dtor-d630.eng.vmware.com>
References: <20090612170536.109df1d8.sfr@canb.auug.org.au>
	<1244843690.3224.10.camel@hp>
	<20090620060559.GA7710@dtor-d630.eng.vmware.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__20_Jun_2009_17_17_43_+1000_h8.j4nJjPRh73ODE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__20_Jun_2009_17_17_43_+1000_h8.j4nJjPRh73ODE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry, Tero,

On Fri, 19 Jun 2009 23:06:09 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.c=
om> wrote:
>
> On Sat, Jun 13, 2009 at 12:54:50AM +0300, Tero Saarni wrote:
> > On Fri, 2009-06-12 at 17:05 +1000, Stephen Rothwell wrote:
> > > Hi Dmitry,
> > >=20
> > > Today's linux-next build (x86_64 allmodconfig) produced these warning=
s:
> > >=20
> > > drivers/input/evdev.c: In function 'evdev_do_ioctl':
> > > drivers/input/evdev.c:632: warning: comparison of distinct pointer ty=
pes lacks a cast
> > > drivers/input/evdev.c:660: warning: comparison of distinct pointer ty=
pes lacks a cast
> > >=20
> > > Introduced by commit 61c7bfcdf5acee06f58b246d6615989134719d19 ("Input:
> > > synaptics - add support for reporting x/y resolution").
> >=20
> > My mistake, thanks for the heads up!
>=20
> I folded it into the original patch.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__20_Jun_2009_17_17_43_+1000_h8.j4nJjPRh73ODE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko8jRcACgkQjjKRsyhoI8wgowCfVJaBzljsRyQZsSmV38VZ50Mh
BwsAn0v4/hp5ZirmRpHfqM67Eren6ccS
=8Iaa
-----END PGP SIGNATURE-----

--Signature=_Sat__20_Jun_2009_17_17_43_+1000_h8.j4nJjPRh73ODE--
