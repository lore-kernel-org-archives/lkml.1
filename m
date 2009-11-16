Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZKPRLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZKPRLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZKPRLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:11:48 -0500
Received: from nn7.de ([85.214.94.156]:36795 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZKPRLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:11:47 -0500
Subject: Re: [PATCH] mouse button 1 emulation for mac_hid
From: Soeren Sonnenburg <sonne@debian.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, olh@suse.de,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20091116170543.GB24026@core.coreip.homeip.net>
References: <1257762531.7245.23.camel@no>
	 <20091114054246.GF4463@core.coreip.homeip.net>
	 <alpine.LRH.2.00.0911161358240.31913@twin.jikos.cz>
	 <20091116170543.GB24026@core.coreip.homeip.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BgFecxfZ8zXlR/9+U9ET"
Date: Mon, 16 Nov 2009 18:11:51 +0100
Message-ID: <1258391511.3419.131.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BgFecxfZ8zXlR/9+U9ET
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-16 at 09:05 -0800, Dmitry Torokhov wrote:
> On Mon, Nov 16, 2009 at 01:59:37PM +0100, Jiri Kosina wrote:
> > On Fri, 13 Nov 2009, Dmitry Torokhov wrote:
> >=20
> > > > I am not sure what the future of mac_hid is (the source says will b=
e
> > > > removed, but since 9 years). In case it stays in kernel the attache=
d
> > > > patch adds support for mouse button 1 emulation. If this driver sta=
ys in
> > > > the kernel I would also suggest to rename it - it is not mac specif=
ic (I
> > > > am using this on a netbook).
> > > >=20
> > > > Rationale? Broken touchpads, within linux unsupported (multi-)touch=
pads
> > > > where click and hold + moving the mouse does not work (yet?).
> > >=20
> > > I would rather fix the touchpads so they work properly than pile more
> > > quirks in kernel.
> >=20
> > Hi Dmitry,
> >=20
> > in exactly what way are you planning to "fix the touchpads"?
> >=20
>=20
> Hi Jiri,
>=20
> It would be helpful to know which ones are currently. Obviously we can't
> help with physically broken ones but I don't believe it is kernel's task
> to deal with physically broken hardware. The ones that are not
> physically broken - PS/2 should have fairly decent hardware emulation
> mode (at least all I tried supported tap and trag while working as
> regular PS/2 mouse) - so that can be used while we figuring out native
> protocol. USB - appletouch, bcm - are there any issues at the moment?

Ignoring broken hardware, there is the problem or feature that some
touchpads have the mouse *under the touchpad*. So when you click there
and want to move the mouse - well good luck. Of course this is something
that needs to be ultimately fixed in the synaptics xorg driver.

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-BgFecxfZ8zXlR/9+U9ET
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLAYfWAAoJEH82z1Wqh6p31KYP/jelg048wDILXIKEoHO8TPlT
oP6y/2B64Vby9ohFgC+stUZ6H32aN/o4BdBLQ8k5fkDlz2QAzUix7G5xYxkSE9DL
Y4+/N/c5v6C+X/a1Pm37qcDGBLTKSbmK2uheC+bfpY2P/B7KEc2Dl0aSJ2eWOquV
5guJnEiukbBccwMs2wDOJFBBdYKzk/1FVdQBjMSo+s5Usi0SnpauDyIBcpHFbyDH
0131sO03Lf1NismUvWIIKEs2X0688+FrWpWlqr8Mv+p9p9mu+6j/qEH4EX3um2gk
/AvuSFMw2Qd/EmA2sebjLCl7kkDnQGd2yhpAKIY0niJ5o5fGOyIMxjPqbZBwOayy
VnQMnU/cHV1sM13UNpD1DdzdQceXEiz0iE+N7xDqMdx6Jz/g7MoUWUPVWRhT3IeE
8FmYSOZJhgL8sKG92J4lRRhhlXTIcMSOctW4aMDyrHsvmoEZiyixeLQo1vRMXX0A
/DS2XvREdR+Zu7LyYmcpqX1xP5xW5HxyK5enUqMgiwRAVK29Am7XzCULH8q5PcEM
ZXAMtkjjipoPmhCiIv8SW3SXtDTEybUaic9khKHsIjujZA5j9fL5bYoodHYQnph0
ZUjXH7OPqpnoyMWbkd4u7AhKrcSAcOKt2n4EdFTNmzVjzNWcdrtF9ovZ3gQeAbw3
QhoJQnkYI7TEWNF6VYce
=Vllr
-----END PGP SIGNATURE-----

--=-BgFecxfZ8zXlR/9+U9ET--
