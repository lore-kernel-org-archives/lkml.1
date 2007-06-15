Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXFOIPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXFOIPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXFOIOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:14:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:50090 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750787AbXFOIOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:14:47 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX18fzNBpTXUfwGjI5bZA4WNKk70aOZ3jOCDP8ls8s9
	ZuFByMcBzxbDn2
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Paulo Marques <pmarques@grupopie.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 10:14:44 +0200
User-Agent: KMail/1.9.5
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <20070614170902.GQ21478@ftp.linux.org.uk> <467178D3.6010204@grupopie.com>
In-Reply-To: <467178D3.6010204@grupopie.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1987136.IJfHaWp53u";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706151014.45383.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1987136.IJfHaWp53u
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 14 June 2007 19:20, Paulo Marques wrote:
> Watching the output of the first grep without "wc -l" shows that,
> although it is not 100% accurate, it is still ok just to get a rough
> estimate.
>
> So yes, ~6300 files are definitely more than a couple ;)

Most of them don't say anything, so they are "any GPL" by the author. When=
=20
do you people accept that Linus can't change the GPL, he can only add=20
comments of what he thinks is the case! His interpretation of the GPLv2=20
might be that not saying anything about the version means "v2 only", but if=
=20
he does so, he's simply wrong. He was wrong in the module case, as well,=20
and dropped this comment a while ago. He might drop this comment in future,=
=20
as well. In fact, anybody can drop this comment, as it's just a comment.

The kernel *as a whole* is clearly under GPLv2 only from Linus' comment,=20
which is in fact true, since the common subset of GPL versions from all=20
authors is indeed GPLv2 (by virtue of some files from Al Viro, and maybe=20
some other explicit GPL v2 files). The author must specify the version=20
himself, there simply is no other way. If you don't specify any, it's "any=
=20
version", because I can license all patches straight from the authors. The=
=20
way the GPLv2 allows you to explicitely specify "any version" is by not=20
saying anything about the version at all. Linus isn't in the positition to=
=20
change that unless he does a substantial change to the file, and also adds=
=20
a comment that this file is now GPLv2 only.

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart1987136.IJfHaWp53u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGckp1i4ILt2cAfDARArBPAJ9ZSGDpLxPQqdBV+doQxgKfHx37EwCglETv
SlQg/RWoGDnBMoFgqeKYD34=
=k1zO
-----END PGP SIGNATURE-----

--nextPart1987136.IJfHaWp53u--
