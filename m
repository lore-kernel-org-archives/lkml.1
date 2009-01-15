Return-Path: <linux-kernel-owner+w=401wt.eu-S1765822AbZAOOrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765822AbZAOOrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbZAOOqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:46:53 -0500
Received: from lug-owl.de ([195.71.106.12]:52413 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760294AbZAOOqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:46:53 -0500
Date: Thu, 15 Jan 2009 15:46:51 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
Message-ID: <20090115144651.GZ11087@lug-owl.de>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Jiri Kosina <jkosina@suse.cz>, Adam Osuchowski <adwol@zonk.pl>,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk> <20090108151046.GK18120@elte.hu> <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org> <20090115123614.GR11087@lug-owl.de> <alpine.LFD.1.10.0901151309420.5737@ftp.linux-mips.org> <20090115133252.28c36adb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="svxYMya3cuHlfhYO"
Content-Disposition: inline
In-Reply-To: <20090115133252.28c36adb@lxorguk.ukuu.org.uk>
X-Operating-System: Linux mail 2.6.18-5-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-message-flag: Please send plain text messages only. Do not send HTML emails. Thank you. 
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--svxYMya3cuHlfhYO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 13:32:52 +0000, Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
> > UP emulation of CMPXCHG and XADD for userland should be rather trivial,=
=20
> > so why not include it like with LL/SC for MIPS?
>=20
> Why not just ship an additional libc with the right options ?

Due to another historic bug, which created libcs targeted for i386
containing the locking code for i486, as I was told back when I first
showed interest for real i386 hardware.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:                 Friends are relatives you make for yourself.
the second  :

--svxYMya3cuHlfhYO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJb0xbHb1edYOZ4bsRAsi+AJ0eWxIsMHV6OfTkjBY74ydin6bBkgCeKUpE
A01FelQkf4o2hhqb8Wj/epw=
=714F
-----END PGP SIGNATURE-----

--svxYMya3cuHlfhYO--
