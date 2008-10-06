Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYJFM1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYJFM1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYJFM1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:27:35 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:54803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYJFM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:27:34 -0400
Subject: Re: bad DMAR interaction with iwlagn and SATA
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Andres Freund <andres@anarazel.de>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809290140i5a47d534qa30f9088df834162@mail.gmail.com> (sfid-20080929_104025_440809_8C8FD26C)
References: <200809251511.20132.andres@anarazel.de>
	 <1222441955.3798.13.camel@johannes.berg>
	 <1ba2fa240809261630y7a8e5f20g75ab47ff98a1e614@mail.gmail.com>
	 <200809291027.50453.andres@anarazel.de>
	 <1ba2fa240809290140i5a47d534qa30f9088df834162@mail.gmail.com>
	 (sfid-20080929_104025_440809_8C8FD26C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wtKHr93MKiRybIorpimQ"
Date: Mon, 06 Oct 2008 14:26:55 +0200
Message-Id: <1223296015.15196.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wtKHr93MKiRybIorpimQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-29 at 11:40 +0300, Tomas Winkler wrote:
> On Mon, Sep 29, 2008 at 11:27 AM, Andres Freund <andres@anarazel.de> wrot=
e:
> > Hi,
> >
> > On Saturday 27 September 2008, Tomas Winkler wrote in "Re: bad DMAR
> > interaction with iwlagn and SATA":
> >> Meanwhile it all reported bugs in this case points to 64 bit
> >> installations, I'll give it more testing
> > Would it help to test on 32bit? I have some dissk with 32bit system ins=
talled
> > lying around somewhere...
>=20
> It would help to try to isolate this as 64 bit issue

Andres, can you post your config?

johannes

--=-wtKHr93MKiRybIorpimQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6gQLAAoJEKVg1VMiehFYP+IQAI7XD5VWcGPIE1Q/6HzhZtU4
Vgq6x8fTDI8afDZ1M5w+RKGuFR4TlqoPnvYjtRk+33ij+dWv653TM0H2VwnFQUFD
ugvKzojyzWLXIrHoOeN3App/98qlg7jknP7olPLOsLf6myllw9nXkDirQziJENfD
dqcdXF6GHA6mMv/ZLnVvYJioXS6uyUQDBwwq+FzMg6msB2Y+nn6cqZWtUJTXZIEK
ZPaBB6OJxIk4MvUg79KpIDtVNQjxbQBBuF4dXyybVK09BU0v+aT4C/FSTgDyC3yT
IIDSbYr5rk3CL7E4uMp/kepCqkCVXJRKyTWcuyC3T21JGTFhMUrsAp5dwo3mo9v2
elMOUfklTH0WMlvkPHdxnZ4+JXBHyiNXZrEloVQyupy3aV67V9/X1CzzveW4whA+
n5tBJsmMiBQh5c38tTO7Yz1zfPaTFD4dTBKkWoPAqsuadA1V4lRYSXONfJhxFUA2
uNHf15XrkH67sanWeSXbsvIzxYhsYOQOlPOAXdn82N6yRNnJ2iRtt/r82Qstx0HF
r9TNgGTafoKjSNwRcOM4vwQiuy/Tr25QGtXryuV5nGKnWJHmpzuZrWG/J5l4ZR+L
w7ZQYhAWc0HHuRZSVm2XIvGieX7nqqOqwBvLC88iHgVj9mkM+2/urF68tWIxGMPG
GKiPJVTkree9SDrxQMNK
=MZCq
-----END PGP SIGNATURE-----

--=-wtKHr93MKiRybIorpimQ--

