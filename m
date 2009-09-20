Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZITHfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZITHfA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 03:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZITHe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 03:34:59 -0400
Received: from lo.gmane.org ([80.91.229.12]:56123 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZITHe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 03:34:59 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: Re: tickless and HZ=1000 throughput advantage?
Date: Sun, 20 Sep 2009 09:34:30 +0200
Message-ID: <4AB5DB06.1090100@klingt.org>
References: <6278d2220909190747n62f7036dj2e5231fcdc4730fb@mail.gmail.com>	 <20090919165501.65d77294@infradead.org>	 <6278d2220909191050l19f2a446r5ccf1907fd963096@mail.gmail.com> <1253401950.7587.7.camel@ben-desktop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6EF22EC2DCDBC4979089C98D"
X-Complaints-To: usenet@ger.gmane.org
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: 85-127-80-191.dynamic.xdsl-line.inode.at
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3pre) Gecko/20090810 Lightning/1.0pre Shredder/3.0b4pre
In-Reply-To: <1253401950.7587.7.camel@ben-desktop>
X-Enigmail-Version: 0.96a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6EF22EC2DCDBC4979089C98D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/20/2009 01:12 AM, Ben Nizette wrote:
> On Sat, 2009-09-19 at 18:50 +0100, Daniel J Blueman wrote:
>=20
>> Agreed. Do you think there is still a small case for moving to HZ=3D10=
00
>> (given it's effectively free) in situations like:
>=20
> Sure HZ=3D1000 gives you more accurate sleeps, that's kind of the point=
,
> but since when has it been "effectively free"?
> http://lwn.net/Articles/331607/

i'd be curious, what effect does it have on userspace applications?
like, does it effect the wakeup latency of userspace (pthread)
mutexes/conditions or posix semaphores?

thnx, tim

--=20
tim@klingt.org
http://tim.klingt.org

Desperation is the raw material of drastic change. Only those who can
leave behind everything they have ever believed in can hope to escape.
  William S. Burroughs


--------------enig6EF22EC2DCDBC4979089C98D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq12w8ACgkQdL+4qsZfVstmEgCeMcyFJRANTqGLcnjsIKTVBx2Z
aIsAnioHKal47wGATMZQvACiO1+SzdQu
=iGud
-----END PGP SIGNATURE-----

--------------enig6EF22EC2DCDBC4979089C98D--

