Return-Path: <linux-kernel-owner+w=401wt.eu-S934227AbZDINAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbZDINAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933137AbZDINAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:00:31 -0400
Received: from lug-owl.de ([195.71.106.12]:56819 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759951AbZDINA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:00:29 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2009 09:00:28 EDT
Date: Thu, 9 Apr 2009 14:52:37 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090409125237.GD7921@lug-owl.de>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Robin Holt <holt@sgi.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ia64@vger.kernel.org
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org> <20090408173332.GB20187@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zNngJsVJxur72n6A"
Content-Disposition: inline
In-Reply-To: <20090408173332.GB20187@ldl.fc.hp.com>
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


--zNngJsVJxur72n6A
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-08 11:33:32 -0600, Alex Chiang <achiang@hp.com> wrote:
> * Andrew Morton <akpm@linux-foundation.org>:
> > On Tue, 7 Apr 2009 23:46:12 -0600 Alex Chiang <achiang@hp.com> wrote:
> > > * Robin Holt <holt@sgi.com>:
> > > > Don't know if this answers your problem, but I use the tools from
> > > > emdebian and they do not suffer from the problems you list below.
> > >=20
> > > Wow, this seems _much_ simpler. Once you get the toolchain
> > > installed, all you have to do is set ARCH and CROSS_COMPILE
> > > appropriately?
> > >=20
> > > I guess the question remains for Andrew. Since I pretty much did
> > > all the work needed to update his cross-compiler repo, is there
> > > still value in it?
> >=20
> > We would benefit very much from having someone who actually maintains a
> > suite of cross-compilers for kernel developers.
> =20
> Ok, I'll work with Vegard on this.

Is anybody building GCC trunk for the targets on a daily basis? I do
build vax-linux (kernel-only) cross compilers quite often and the
build script could probably also handle other targets.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
  Signature of:                        Lauf nicht vor Deinem Gl=C3=BCck dav=
on:
  the second  :                             Es k=C3=B6nnte hinter Dir stehe=
n!

--zNngJsVJxur72n6A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknd75UACgkQHb1edYOZ4bu0oACeJviGNvw1zHejrg2+ROOdYKCf
Jf0AoI+18AjE8jtw4DdxmJcvlBGiJBhm
=zqtr
-----END PGP SIGNATURE-----

--zNngJsVJxur72n6A--
