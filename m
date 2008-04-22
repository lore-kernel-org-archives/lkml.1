Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbYDVG4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbYDVG4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 02:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYDVG4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 02:56:07 -0400
Received: from aksay.ru ([80.254.111.40]:59892 "EHLO aksay.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbYDVG4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 02:56:05 -0400
X-Greylist: delayed 1763 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2008 02:56:05 EDT
Date: Tue, 22 Apr 2008 10:19:04 +0400
From: Andrey Panin <pazke@pazke.donpac.ru>
To: Adrian Bunk <bunk@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Subject: Re: Status of SGI 320/540 (Visual Workstation) support?
Message-ID: <20080422061904.GA6423@pazke.donpac.ru>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
	James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <480C8EC8.3080705@zytor.com> <20080421141058.GH6011@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20080421141058.GH6011@cs181133002.pp.htv.fi>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 112, 04 21, 2008 at 05:10:58PM +0300, Adrian Bunk wrote:
> On Mon, Apr 21, 2008 at 08:55:36AM -0400, H. Peter Anvin wrote:
> >...
> > VISWS is another matter.  It's entirely possible I have the only =20
> > remaining VISWS in my garage; we have at least not been able to locate =
=20
> > another.  Not that we have tried all that hard.
> >
> > If there are no VISWS' left, we should just unload the code.
>=20
> Googling a bit around 320/540 hardware does not seem to have completely=
=20
> vanished from the earth, and there are still people who'd like to=20
> install Linux on them.
>=20
> Looking through the archives of the mailing list in MAINTAINERS there=20
> seem to be some older 2.6 kernels that worked on some Visual=20
> Workstations, but no indication that recent kernels work.
>=20
> Andrey, what is the status of recent 2.6 kernels on the SGI 320/540?

Right now it doesn't work, but there is a hope. I recovered my SGI 320
recently and I plan to start hacking kernel on it Real Soon Now.

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIDYNYIWZCBzwS8mkRAq83AKC1S14PtytEeSf08jpqnenfhp7y4wCfUeff
yd8Uc2wg4P3EaaKlkaUc4Fk=
=NfGK
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
