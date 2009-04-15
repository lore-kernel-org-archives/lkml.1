Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZDOPKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZDOPKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZDOPKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:10:45 -0400
Received: from lug-owl.de ([195.71.106.12]:41374 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZDOPKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:10:44 -0400
Date: Wed, 15 Apr 2009 17:10:42 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Jerry Wang <jerry18th@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel Cross-Compiling question
Message-ID: <20090415151042.GB25876@lug-owl.de>
Mail-Followup-To: Jerry Wang <jerry18th@yahoo.com>,
	linux-kernel@vger.kernel.org
References: <344183.64836.qm@web65503.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <344183.64836.qm@web65503.mail.ac4.yahoo.com>
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


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-15 07:18:13 -0700, Jerry Wang <jerry18th@yahoo.com> wrote:
> > In file included from arch/ppc/kernel/asm-offsets.c:13: include/linux/s=
ched.h: In function `arch_pick_mmap_layout':
> > include/linux/sched.h:1174: error: `CONFIG_TASK_SIZE' undeclared (first=
 use in this function)
> > include/linux/sched.h:1174: error: (Each undeclared identifier is repor=
ted only once
> > include/linux/sched.h:1174: error: for each function it appears in.)
[...]
>=20
> I am trying to cross-compile the linux 2.6.11.1 kernel on
> i686 vm for ppc, and I've been getting the following
> errors. Has anyone had this issue before?

Why are you trying to compile something that is /so/ old? Please
re-test with a current GIT snapshot.

MfG, JBG


--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
 Signature of:                            If it doesn't work, force it.
 the second  :                   If it breaks, it needed replacing anyway.

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknl+PIACgkQHb1edYOZ4bv/BgCeMiOEuyFRXQJL1Ecck6ESCCvN
uPAAnjES5qpjJHE7qlZXsoQSNu9K4khz
=7c2y
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
