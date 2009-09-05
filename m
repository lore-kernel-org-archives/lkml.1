Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbZIENnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbZIENnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 09:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZIENnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 09:43:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49378 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZIENnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 09:43:19 -0400
Date: Sat, 5 Sep 2009 15:43:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Frans Pop <elendil@planet.nl>
Cc: Christian =?iso-8859-15?Q?Kr=E4mer?= <christian@kraemer-eu.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Message-ID: <20090905134320.GB3171@pengutronix.de>
References: <200909021856.29565.christian@kraemer-eu.de> <alpine.LFD.2.00.0909031539070.3200@localhost> <20090903195753.GC11097@pengutronix.de> <200909032216.56148.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <200909032216.56148.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 03, 2009 at 10:16:54PM +0200, Frans Pop wrote:
> On Thursday 03 September 2009, Wolfram Sang wrote:
> > I read the thread in which you tried. I will have my try, too. This
> > time, I want to convert the existing users first and then throw the
> > interface away. To me, it looks like there is only one prominent user
> > left, Debian's discover. Even though the PCMCIA-information it collects
> > is hardly useful, I converted it:
> >
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D382425
> >
> > Still working on getting any response from the maintainers :)
>=20
> I'm a Debian Developer and one of the developers of Debian's installation=
=20
> system. My suggestion would be to simply ignore discover. It is not used=
=20
> anymore and the fact that it's un(der)maintained does not surprise me.

Thanks for this clarification! Hopefully it will help the process.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqiavgACgkQD27XaX1/VRsegwCfX+AVrgiGSO185Htvni/9NICh
CFcAnA0/HG1mYxWltXGKwTs9MdGUtQfS
=PU3U
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
