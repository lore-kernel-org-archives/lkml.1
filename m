Return-Path: <linux-kernel-owner+w=401wt.eu-S2993102AbXDSBhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993102AbXDSBhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 21:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993103AbXDSBhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 21:37:16 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:60936 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993102AbXDSBhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 21:37:15 -0400
Subject: Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Christian Hesse <mail@earthworm.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       suspend2-devel@lists.suspend2.net
In-Reply-To: <200704190022.12315.mail@earthworm.de>
References: <20070413202100.GA9957@elte.hu>
	 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
	 <200704190022.12315.mail@earthworm.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vVBeLUmPWnpDmNG9BDh7"
Date: Thu, 19 Apr 2007 11:37:12 +1000
Message-Id: <1176946632.5906.13.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vVBeLUmPWnpDmNG9BDh7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-19 at 00:22 +0200, Christian Hesse wrote:
> On Thursday 19 April 2007, Ingo Molnar wrote:
> > * Christian Hesse <mail@earthworm.de> wrote:
> > > > although probably your suspend2 problem is still not fixed, it's
> > > > worth a try nevertheless. Which suspend2 patch did you apply, and
> > > > was it against -rc6 or -rc7?
> > >
> > > You are right again. ;-)
> > >
> > > Linux 2.6.21-rc7
> > > Suspend2 2.2.9.11 (applies cleanly to -rc7)
> > > CFS v3 (without any additional patches)
> > >
> > > And it still hangs on suspend.
> >
> > what's the easiest way for me to try suspend2? Apply the patch, reboot
> > into the kernel, then execute what command to suspend? (there's a
> > confusing mismash of initiators of all the suspend variants. Can i driv=
e
> > this by echoing to /sys/power/state?)
>=20
> Perhaps you have to install suspend2-userui as well for the output (I'm n=
ot=20
> shure whether it works without). Then you can trigger the suspend by echo=
ing=20
> to /sys/power/suspend2/do_suspend.
> Useful informations can be found in the Howto:
>=20
> http://www.suspend2.net/HOWTO
>=20
> I dropped some ccs to not abuse Linus and friends.

You can suspend and resume without it.

Regards,

Nigel

--=-vVBeLUmPWnpDmNG9BDh7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJsfIN0y+n1M3mo0RAqBAAKC34iBcTE072yveCxPX+A6gWHQ6fwCg8Xaf
8dNDiZeTRRrFFevSF/YZK8s=
=GPgg
-----END PGP SIGNATURE-----

--=-vVBeLUmPWnpDmNG9BDh7--

