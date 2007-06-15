Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbXFOL5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbXFOL5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbXFOL5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:57:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:46190 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751650AbXFOL5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:57:23 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX1+Sg7MttOuS38doO7HFJIG99PfXuwQK5UiXTrJ1C0
	MLjcfbC+VCjCr1
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Rob Landley <rob@landley.net>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 13:57:10 +0200
User-Agent: KMail/1.9.5
Cc: Carlo Wood <carlo@alinoe.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexandre Oliva <aoliva@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <20070614020827.GO3588@stusta.de> <20070614231812.GA9463@alinoe.com> <200706142149.19883.rob@landley.net>
In-Reply-To: <200706142149.19883.rob@landley.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1877088.Ttpcd2sc7M";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706151357.17418.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1877088.Ttpcd2sc7M
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 15 June 2007 03:49, Rob Landley wrote:
> (Right now, nobody EXCEPT the FSF has the right to sue somebody to
> enforce the license terms on something like gcc.  Do you find that a
> comforting thought?)

Have you ever signed a copyright transfer agreement to the FSF? Obviously=20
not, because then you wouldn't utter such nonsense. The agreement reads=20
that you transfer a non-exclusive right to the FSF to distribute the code=20
under GPL (versions of your choice, they have this right anyway, but making=
=20
it explicit is always good), and the right to enforce the license. You=20
still have the right to relicense the work as you like. You also have the=20
right to enforce the license yourself, or to transfer that right to=20
somebody else like gpl-violations.org. The FSF even doesn't require to=20
transfer copyright if you make a GNU project, but if you don't, the FSF=20
won't help you (because they can't).

They make very obvious promises about what they care ("four freedoms"), and=
=20
that they will be very consistent in doing so. So far, all track records=20
have proven that they indeed are very consistent in doing so - the main=20
controversy here is not whether the FSF protects the "four freedoms", but=20
whether these four freedoms are the right goal, and if they really should=20
try so hard to protect these four freedoms. This part of the discussion is=
=20
fully acceptable, what's not acceptable is that the Linus-fancurve claims=20
things the GPL sais which it doesn't (like "tit-for-tat") or doesn't say=20
which it does (like section 6 - direct license from the licensor, and in=20
cases like Linux where no copyright transfer agreements whatsoever exist,=20
these are the individual contributors). Or that Linux 0.something was=20
already under GPLv2 only, when GPLv2 clearly says that there may be=20
updates, and when you as author don't say something, you are allowing users=
=20
to update if they like.

The last point IMHO makes clear that my interpretation of the comment is=20
valid: This is a commend made by Linus Torvalds, as how he understands or=20
misunderstands the license text. It's not even something you can take as=20
legal advice, because Linus is not a lawyer (fortunately - think how the=20
kernel would look like if it was programmed by a lawyer ;-).

Sure, if you as outsider strip the kernel of obvious GPLv2-only code to=20
relicense it as a whole under GPLv3, you need a good asbestos suite, a good=
=20
lawyer, and good arguments. But let's assume Microsoft really succeeds with=
=20
its patent FUD against Linux, and the only way out is GPLv3, when will=20
opinions here change?

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart1877088.Ttpcd2sc7M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcn6di4ILt2cAfDARArpcAJ4/VqAHpqnsTK0hLR4e1tVgrDAHpACg2ogp
bruCtWabcSXlHQHOUPOWeJE=
=Rfn7
-----END PGP SIGNATURE-----

--nextPart1877088.Ttpcd2sc7M--
