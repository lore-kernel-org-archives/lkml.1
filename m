Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXGWNPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXGWNPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbXGWNP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:15:26 -0400
Received: from lug-owl.de ([195.71.106.12]:46464 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbXGWNPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:15:25 -0400
Date: Mon, 23 Jul 2007 15:15:23 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
Message-ID: <20070723131523.GR22998@lug-owl.de>
Mail-Followup-To: Rene Herman <rene.herman@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com> <20070722162802.GA20174@thunk.org> <46A46399.5090406@gmail.com> <20070723084146.GP22998@lug-owl.de> <46A488EB.2050305@gmail.com> <46A4A16F.7070100@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nccO0ldXW0cuDU6a"
Content-Disposition: inline
In-Reply-To: <46A4A16F.7070100@gmail.com>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--nccO0ldXW0cuDU6a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-07-23 14:39:11 +0200, Rene Herman <rene.herman@gmail.com> wrot=
e:
> On 07/23/2007 12:54 PM, Rene Herman wrote:
>=20
> > static inline uint32_t le_32(uint32_t n)
> > {
> > #ifdef __LITTLE_ENDIAN
> >	return n;
> > #else
> > 	return bswap_32(n);
> > #endif
> > }
>=20
> #if __BYTE_ORDER =3D=3D __LITTLE_ENDIAN, that is. sigh.

Don't forget PDP11 byteorder :-)

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
  Signature of:                           Wenn ich wach bin, tr=C3=A4ume ic=
h.
  the second  :

--nccO0ldXW0cuDU6a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGpKnrHb1edYOZ4bsRAhiyAJ9yABd8QmWsaVNdRgjNRZ9eXyAW7ACfRKly
e9sG4KCUrlE0DwThVrMxZZ0=
=FWJq
-----END PGP SIGNATURE-----

--nccO0ldXW0cuDU6a--
