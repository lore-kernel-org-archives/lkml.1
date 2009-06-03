Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZFCKrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZFCKrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZFCKrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:47:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54758 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZFCKrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:47:00 -0400
Date: Wed, 3 Jun 2009 20:46:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Craig Shelley <craig@microtron.org.uk>
Subject: Re: linux-next: manual merge of the usb tree with the ttydev tree
Message-Id: <20090603204655.3f431574.sfr@canb.auug.org.au>
In-Reply-To: <20090603095547.1641ca7b@lxorguk.ukuu.org.uk>
References: <20090603180734.f175e04f.sfr@canb.auug.org.au>
	<20090603095547.1641ca7b@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Jun_2009_20_46_55_+1000_xCb6K2znxlgvabHd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jun_2009_20_46_55_+1000_xCb6K2znxlgvabHd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Wed, 3 Jun 2009 09:55:47 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> > As a side issue, the last patch has no SOB from Craig in the ttydev tre=
e.
>=20
> Yes it does...
>=20
>     Signed-off-by: Craig Shelley <craig@microtron.org.uk>
>    =20
>     (Fixed some collisions merging)
>    =20
>     Signed-off-by: Alan Cox <alan@linux.intel.com>

Sorry, going blind in my old age :-)

> > So, I just used the ttydev tree version on the assumption that my
> > reasoning above is correct.
>=20
> and the ttydev tree one is the one to use

Thanks for the confirmation.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Jun_2009_20_46_55_+1000_xCb6K2znxlgvabHd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkomVJ8ACgkQjjKRsyhoI8xCfQCfZlTyMG4zuRZCurnKQTaGYNlq
bboAn0VcY0fc7APw8Nd3ymXOazlC/X9X
=lw5U
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jun_2009_20_46_55_+1000_xCb6K2znxlgvabHd--
