Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbXFDWgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbXFDWgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXFDWg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:36:27 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54024 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXFDWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:36:26 -0400
Subject: Re: A kexec approach to hibernation
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Jeremy Maitin-Shepard <jmaitins@andrew.cmu.edu>
Cc: Pavel Machek <pavel@ucw.cz>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <20070604220910.GB2515@andrew.cmu.edu>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	 <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	 <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz>
	 <20070604220910.GB2515@andrew.cmu.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eGauHBQKUlGgRV/KCaCu"
Date: Tue, 05 Jun 2007 08:36:26 +1000
Message-Id: <1180996586.4356.65.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eGauHBQKUlGgRV/KCaCu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Mon, 2007-06-04 at 18:09 -0400, Jeremy Maitin-Shepard wrote:
> I was hoping that everyone would like the idea so much that they would
> rush to=20
> implement it, so that I wouldn't have to try.  (I haven't written much ke=
rnel=20
> code before, and I have a number of other time-requiring projects to work=
 on.)=20
> It looks like that is not too likely to happen though ;).

I spent some time, last I think, seriously considering this approach.
The more I thought about the details, the more I realised that it wasn't
a viable approach. As I said before, it does indeed sound like a dream
at first, but once you get into the details, it becomes more and more of
a nightmare.

> Maybe I'll try implementing it though, and find that it isn't very much w=
ork.

Perhaps that would be a good idea. Then you'll get to see those issues
too.

[...]

> To some extent, (see some of the explanations I gave in the other e-mail =
I
> sent a few minutes ago in reply to Nigel) I think the kexec appraoch can =
be
> viewed as a cleaner variant of userspace hibernate.

I'm not going to bother saying more in response to that at the moment.
It seems clear to me that the three of us who've actually worked on
hibernation and thought about the issues actually know nothing, and
everyone who hasn't worked on it is far more expert than us.

I'm not saying that I think it's utterly impossible to use kexec for
hibernation. I am saying that I think such an implementation would be
even more of a headache than the existing issues.

Regards,

Nigel

--=-eGauHBQKUlGgRV/KCaCu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGZJPqN0y+n1M3mo0RAmDQAKDolPlpe6Q0QkjHMriQoZUh2YHaEQCgwP98
ZA5MEKoe47xKmQWaZopI/gE=
=aVBd
-----END PGP SIGNATURE-----

--=-eGauHBQKUlGgRV/KCaCu--

