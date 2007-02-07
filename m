Return-Path: <linux-kernel-owner+w=401wt.eu-S1161238AbXBGL5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161238AbXBGL5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161246AbXBGL5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:57:42 -0500
Received: from vesl.donpac.ru ([80.254.111.33]:36567 "EHLO vesl.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161238AbXBGL5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:57:39 -0500
Date: Wed, 7 Feb 2007 14:57:35 +0300
To: Michael Leun <ml@newton.leun.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wistron button support for fujitsu-siemens Amilo D88x0
Message-ID: <20070207115734.GA32370@pazke.donpac.ru>
Mail-Followup-To: Michael Leun <ml@newton.leun.net>,
	linux-kernel@vger.kernel.org
References: <20070205103521.0f20779d@xenia.leun.net> <20070205110529.0e4ae6c0@xenia.leun.net> <d120d5000702060837j7382d429ned3fb5a5e47ac76b@mail.gmail.com> <20070206194318.1d8e1fc0@xenia.leun.net> <20070206200748.GA24176@srcf.ucam.org> <20070207072347.7b30781d@xenia.leun.net> <20070207095807.GA15088@srcf.ucam.org> <20070207114346.73eecf40@xenia.leun.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20070207114346.73eecf40@xenia.leun.net>
X-Uname: Linux 2.6.18-1-amd64 x86_64
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andrey Panin <pazke@donpac.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 038, 02 07, 2007 at 11:43:46AM +0100, Michael Leun wrote:
> On Wed, 7 Feb 2007 09:58:07 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>=20
> > On Wed, Feb 07, 2007 at 07:23:47AM +0100, Michael Leun wrote:
> > > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > > Hm. Is there really no PNP id that tends to be associated with
> > > > this wistron hardware? Fujitsu (at least) seem to be quite good at
> > > > exposing a lot of their magic hardware that way.
> > >=20
> > > Sorry, I do not know and I do not know how to find out. If there is
> > > any testing I should do on my machine I will happily do that, but
> > > you would have to tell me what to do.
> >=20
> > cat /sys/bus/pnp/devices/*/id should give a list of the available IDs.
>=20
> ml@xenia:~> cat /sys/bus/pnp/devices/*/id

This list doesn't look promising.

PNP0a03 - PCI bus
PNP0200 - AT DMA controller
PNP0b00 - AT real-time clock
PNP0800 - AT-style speaker sound
PNP0c02 - Motherboard resources
PNP0c04 - Math coprocessor
PNP0303 - IBM enhanced keyboard (101/102-key, PS/2 mouse support)
PNP0f13 - PS/2 port for PS/2-style mice
PNP0700 - PC standard floppy disk controller
PNP0400 - Standard LPT printer port
PNP0501 - 16550A-compatible COM port

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFyb6uIWZCBzwS8mkRAuV9AJ93rAFYLv2XOMf7FO1ZFcKgzhm0TQCdG2Xh
E8ktoM/ErRrOOq1oA07gQJs=
=di60
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
