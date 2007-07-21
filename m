Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbXGUT6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbXGUT6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760573AbXGUT6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:58:33 -0400
Received: from lug-owl.de ([195.71.106.12]:36891 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886AbXGUT6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:58:32 -0400
Date: Sat, 21 Jul 2007 21:58:30 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: from where comes "__moddi3"?
Message-ID: <20070721195830.GK22998@lug-owl.de>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0707211516480.6972@localhost.localdomain> <1185046274.5652.15.camel@lappy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LHvWgpbS7VDUdu2f"
Content-Disposition: inline
In-Reply-To: <1185046274.5652.15.camel@lappy>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--LHvWgpbS7VDUdu2f
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-07-21 21:31:13 +0200, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> On Sat, 2007-07-21 at 15:21 -0400, Robert P. J. Day wrote:
>=20
> use do_div().
>=20
> 16 works because gcc translates that into a right shift.

Right shift?  Doesn't it just mask out everything but the low 4 bit?

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:             God put me on earth to accomplish a certain numbe=
r of
the second  :            things. Right now I am so far behind I will never =
die.

--LHvWgpbS7VDUdu2f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGomVmHb1edYOZ4bsRAlE/AJ9vx7yDxhYHoTmed/JCGcrXC+JxpQCcCbTP
Zn8FoUaCQPnLFxKnrTVHP4g=
=LoK2
-----END PGP SIGNATURE-----

--LHvWgpbS7VDUdu2f--
