Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXFOMEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXFOMEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXFOMEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:04:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:49466 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752407AbXFOMD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:03:59 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX18SnsEZsNMSon/mHnTpRx5EWv58X6rG/aviQ8xgUv
	/2IjyMZx81gdeG
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Paulo Marques <pmarques@grupopie.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 14:03:55 +0200
User-Agent: KMail/1.9.5
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <200706151014.45383.bernd.paysan@gmx.de> <46727CCF.9030905@grupopie.com>
In-Reply-To: <46727CCF.9030905@grupopie.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1382654.iUBj7BXk8p";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706151403.57178.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1382654.iUBj7BXk8p
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 15 June 2007 13:49, Paulo Marques wrote:
> I've contributed some code for the kernel (unlike yourself, AFAICT), and
> believe me, I did so under GPL v2. The COPYING file is pretty much self
> explanatory, so I didn't need to add any explicit license statement to
> my code.

It's not, it's a personal comment from a misunderstanding of the GPL text.=
=20
It's as valid as the "closed source kernel modules are legal" comment that=
=20
was there some years ago.

> People seem to forget that the kernel license in COPYING *never had* the
> "v2 or later" clause. Never. Period.

It's there in section 9.

> The only change in license was from the previous hand-made one from
> Linus into GPL v2 only. And that is perfectly fine since the previous
> license was even more permissive than GPL v2.

??? Linus changed his own less permissive license (which=20
excluded "commercial use", and certainly the TiVO device is commercial) in=
=20
0.0x time-frame. He added and deleted comments on top of COPYING in later=20
years, some simply wrong like the assertion on proprietary kernel modules.=
=20
He added his interpretation about the version issue in 2.4.0-test9, and he=
=20
may delete it any time he wants. It's *his* interpretation.

> No, it is not "any version". It is the license specified in COPYING and
> nothing else.

COPYING says in section 9 that there may be other versions, and if you as=20
author don't specify the version, it's "any version".

> And the basics are: "people who write the code decide the license to
> give it". And that's just it.

Yo, then fucking do it! Write it in the files you contribute! If you don't,=
=20
you haven't! You decide, not Linus Torvalds. Make it clear you have=20
decided.

> And people who write kernel code are perfectly aware that the kernel
> license is GPL v2 only, and always has been (except for the initial
> linus license).

Wrong.

> Putting a license statement in _every_ file in the kernel tree would
> just be idiotic when there is such a clear COPYING file in the root of
> the kernel tree.

It's a personal comment from Linus, and not clear in any way. Do it the way=
=20
the file COPYING itself suggests. It's not "idiotic", it's the most obvious=
=20
way to do it.

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart1382654.iUBj7BXk8p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcoAti4ILt2cAfDARAlYqAKC7+CK1kk2K92BFfVPbHgKO/fneqgCcCZcC
hkeRf+TeQOBofUliMuNwsgU=
=phqR
-----END PGP SIGNATURE-----

--nextPart1382654.iUBj7BXk8p--
