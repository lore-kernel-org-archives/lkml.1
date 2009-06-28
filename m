Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZF1N5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZF1N5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZF1N53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:57:29 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:38659 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZF1N52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:57:28 -0400
Date: Sun, 28 Jun 2009 09:57:31 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Staging: vt6656 ?
Message-ID: <20090628135731.GA9143@alittletooquiet.net>
References: <a4423d670906090331o6363fe56g34374967f21552e8@mail.gmail.com> <20090609105101.GB15378@suse.de> <20090609113343.GA13779@alittletooquiet.net> <200906281543.12745.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <200906281543.12745.bzolnier@gmail.com>
X-PGP-Key: http://www.alittletooquiet.net/media/forest.pubkey.asc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jun 28, 2009 at 03:43:12PM +0200, Bartlomiej Zolnierkiewicz wrote:
>=20
> Hi,
>=20
> On Tuesday 09 June 2009 13:33:43 Forest Bond wrote:
> > Hi,
> >=20
> > On Tue, Jun 09, 2009 at 03:51:01AM -0700, Greg KH wrote:
> > > On Tue, Jun 09, 2009 at 02:31:30PM +0400, Alexander Beregalov wrote:
> > > > Hi Greg, Forest
> > > >=20
> > > > Are you going to merge driver for VT6656 also?
> > >=20
> > > If someone sends me some patches for it, sure, I will.
> >=20
> > I have patches almost ready.  I'll send them by the end of next week at=
 the
> > latest.  Busy week here.
>=20
> Did I miss the patch?  There are people already doing cleanups for VT6655
> driver (which seems to share a great deal of code with VT6656 driver) so
> it would greatly help to get VT6656 merged ASAP and merge the shared code
> first to not duplicate efforts.
>=20
> Also if you need some help with integrating the driver or hosting patches
> in git tree at kernel.org before Greg picks them up [ he seems to be buri=
ed
> alive by patches at the moment :) ] I'll be happy to help..

I sent it to Greg about two weeks ago.  I assume it is in his queue somewhe=
re.

Let me know if you think I ought to do something else with them.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKR3bLRO4fQQdv5AwRAvwLAJ9Frf7OkD4iS33nkOksBqKusrH6+ACgs70n
nwdqLGE+/OUbptXkE5g4kjo=
=Sp6M
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
