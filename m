Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbZDJKMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbZDJKMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbZDJKMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:12:24 -0400
Received: from lug-owl.de ([195.71.106.12]:35388 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbZDJKMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:12:22 -0400
Date: Fri, 10 Apr 2009 12:12:20 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: cross-compilers
Message-ID: <20090410101220.GF7921@lug-owl.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ia64@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org> <20090409003308.GK16602@bilbo.ozlabs.org> <20090408174443.79e71503.akpm@linux-foundation.org> <20090409215207.GN16602@bilbo.ozlabs.org> <20090409234750.GE7921@lug-owl.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oeyAOmeIWsNJ4sHb"
Content-Disposition: inline
In-Reply-To: <20090409234750.GE7921@lug-owl.de>
X-Operating-System: Linux mail 2.6.18-5-686
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological
	nuclear warfare test the bombastical terror of flooding the spy
	listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear
	warfare test the bombastical terror of flooding the spy listeners
	explosion sex drugs and rock'n'roll
X-message-flag: Please send plain text messages only. Do not send HTML
	emails. Thank you.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oeyAOmeIWsNJ4sHb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-10 01:47:50 +0200, Jan-Benedict Glaw <jbglaw@lug-owl.de> wr=
ote:
> On Fri, 2009-04-10 07:52:07 +1000, Tony Breeds <tony@bakeyournoodle.com> =
wrote:
> > On Wed, Apr 08, 2009 at 05:44:43PM -0700, Andrew Morton wrote:
> >=20
> > > Please do.
> >=20
> > linux-next is built on powerpc so I needed to rebuild many of the compi=
lers for
> > intel.
>=20
> I've started a build-bot like script for binutils + GCC from CVS/GIT.
> If it builds through, I'll start uploading i686 hosted compilers
> later on today.

So... I've now build trunk kernel-only cross-compilers (hosted on
i686) for these targets:

	alpha-linux.tar.bz2
	am33_2.0-linux.tar.bz2
	arm-linux.tar.bz2
	avr-linux.tar.bz2
	bfin-uclinux.tar.bz2
	cris-linux.tar.bz2
	frv-linux.tar.bz2
	h8300-elf.tar.bz2
	hppa64-linux.tar.bz2
	hppa-linux.tar.bz2
	i386-linux.tar.bz2
	ia64-linux.tar.bz2
	m32r-linux.tar.bz2
	m68k-linux.tar.bz2
	mips64-linux.tar.bz2
	mips-linux.tar.bz2
	powerpc64-linux.tar.bz2
	powerpc-linux.tar.bz2
	s390-linux.tar.bz2
	sh3-linux.tar.bz2
	sh64-linux.tar.bz2
	sparc64-linux.tar.bz2
	sparc-linux.tar.bz2
	v850e-linux.tar.bz2
	vax-linux.tar.bz2
	x86_64-linux.tar.bz2
	xtensa-linux.tar.bz2

They seem to build reliably, I'd easily build them once a day. If
anybody is interested, I'll put them somewhere on lug-owl.de, or if
you wish, on kernel.org .

Comments?

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:          GDB has a 'break' feature; why doesn't it have 'fix'=
 too?
the second  :

--oeyAOmeIWsNJ4sHb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknfG4QACgkQHb1edYOZ4btIhgCeJfszSwWkZev1aIafhUzqrSP6
SL0An2hUmcMMYDZ771s/V7IBg5LXoAjo
=Kw03
-----END PGP SIGNATURE-----

--oeyAOmeIWsNJ4sHb--
