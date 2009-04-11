Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbZDKLXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbZDKLXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 07:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZDKLXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 07:23:13 -0400
Received: from lug-owl.de ([195.71.106.12]:55863 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZDKLXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 07:23:12 -0400
Date: Sat, 11 Apr 2009 13:23:09 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090411112309.GL7921@lug-owl.de>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ia64@vger.kernel.org
References: <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org> <20090409003308.GK16602@bilbo.ozlabs.org> <20090408174443.79e71503.akpm@linux-foundation.org> <20090409215207.GN16602@bilbo.ozlabs.org> <20090409234750.GE7921@lug-owl.de> <20090410101220.GF7921@lug-owl.de> <8bd0f97a0904100319kb16c81bs596341e016cc41a@mail.gmail.com> <20090410104913.GA21483@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AV82Vp2qq95PBKq0"
Content-Disposition: inline
In-Reply-To: <20090410104913.GA21483@uranus.ravnborg.org>
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


--AV82Vp2qq95PBKq0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-10 12:49:13 +0200, Sam Ravnborg <sam@ravnborg.org> wrote:
> It can...
> I'm after a one-stop place where we can locate cross compilers
> for all architectures that Linux supports so it is a much simpler
> task to actaully try to build our changes for as many architectures
> as we supports.

As long as nobody objects, I'll put snapshot compilers once a week to

	http://www.kernel.org/pub/linux/kernel/people/jbglaw/cross_compilers

The first round is uploading right now, it should show up soon.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:  The course of history shows that as a government grows, libe=
rty
the second  : decreases."  (Thomas Jefferson)

--AV82Vp2qq95PBKq0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkngfZ0ACgkQHb1edYOZ4buK6QCfYCWYfG9NkhKnUTyn+f/UlNao
XrQAn2tSFUfnw73YObMR9/dQEN/rNsNa
=LuRP
-----END PGP SIGNATURE-----

--AV82Vp2qq95PBKq0--
