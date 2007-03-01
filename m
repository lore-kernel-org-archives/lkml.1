Return-Path: <linux-kernel-owner+w=401wt.eu-S1030250AbXCAVAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbXCAVAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030260AbXCAVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:00:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:60252 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030250AbXCAVAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:00:04 -0500
X-Provags-ID: V01U2FsdGVkX18vjlEQWcovkpviAr4vg9uo0vMRO7gRSlGL2CdT4f
	REG7YdtRhElyMO
Date: Thu, 1 Mar 2007 22:00:02 +0100
From: Bernhard Walle <bernhard.walle@gmx.de>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       gernot.hillier@siemens.com
Subject: Re: MOST(Media Oriented Systems Transport) Interface?
Message-ID: <20070301210002.GC5092@mail1.bwalle.de>
Mail-Followup-To: Robin Getz <rgetz@blackfin.uclinux.org>,
	Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
	gernot.hillier@siemens.com
References: <200702231826.30395.rgetz@blackfin.uclinux.org> <45E60EBD.2090806@web.de> <20070301001142.GA6806@strauss.suse.de> <200703011016.08167.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hxkXGo8AKqTJ+9QI"
Content-Disposition: inline
In-Reply-To: <200703011016.08167.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--hxkXGo8AKqTJ+9QI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

* Robin Getz <rgetz@blackfin.uclinux.org> [2007-03-01 16:16]:
> On Wed 28 Feb 2007 19:11, Bernhard Walle pondered:
> > * Jan Kiszka <jan.kiszka@web.de> [2007-03-01 00:22]:
> > > This might be what you are looking for:
> > >
> > > http://most4linux.sourceforge.net/
>=20
> That's it - thanks for the pointer & Bernhard - thanks for the work.
>=20
> What is the plan for this? It looks like you did the work on 2.6.14, what=
 is=20
> the plan going forward? Is this something that you or anyone else wants t=
o=20
> maintain/support newer devices on?

Most testing was done on 2.6.16. It definitively works with 2.6.17. I
just fixed it a few days ago to compile on 2.6.21 (ALSA was changed a
bit ;)). For the other statements, Gernot Hillier jumped in ...

> > It only supports synchronous data transfer. The Most NetServices are
> > in userspace. There's a OpenSource demonstration available, but no
> > full NetServices implementation. You can buy a license from SMC or use
> > the specification to re-write an OSS implementation. However, that's
> > all userspace, so no GPL problem here. :)
>=20
> Is there any effort on making an open source NetServices implementation?

BTW: There _are_ patents on MOST, I think mostly NetServices, so it
might be difficult. :( But IANAL.


Regards,
Bernhard
--=20
OpenPGP Schl=FCssel-ID: B69454FD (kurz) / E8951E8FB69454FD (lang)
Fingerprint: F3BE B2A7 8161 2986 ABA4  9AB9 E895 1E8F B694 54FD

--hxkXGo8AKqTJ+9QI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQCVAwUBRec+zeiVHo+2lFT9AQKFeQP/cwZlLnBJZ0DVDw0jxgdTktnJdpVlg9se
gLAnFcjKXeE9SZt1Z2SSGr0ru9bPaJTGadyLT4/n1ar5GSWQRL86QXvID+15gMQj
QfHta2hmjTUSb2hidmIEhS3AjO9q3qKgLoSSH1eSmJUXwxiwn1SvxTh5EPN2PDgr
/gJk/x4m7ig=
=qEPZ
-----END PGP SIGNATURE-----

--hxkXGo8AKqTJ+9QI--
