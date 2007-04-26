Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbXDZUu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbXDZUu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbXDZUu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:50:59 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:58740 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbXDZUu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:50:57 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0704261343150.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
	 <1177607026.30284.197.camel@frg-rhel40-em64t-04>
	 <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
	 <1177618081.4737.42.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704261343150.9964@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i41BsiiPXcXH/B3XMMno"
Date: Fri, 27 Apr 2007 06:50:56 +1000
Message-Id: <1177620656.4737.56.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i41BsiiPXcXH/B3XMMno
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 13:45 -0700, Linus Torvalds wrote:
>=20
> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> >=20
> > Perhaps you should try to make an alternative yourself instead of
> > pushing us into making something we don't believe will work (my case) o=
r
> > have already done but in a way you don't like (Rafael). Don't talk abou=
t
> > Pavel cutting code. He's just acking/nacking what Rafael sends him.
>=20
> I've done that in the past (USB, PCMCIA - screw the maintainers, redo=20
> it basically from scratch). But the thing is, I'm totally uninterested=20
> personally in the whole disk-snapshotting, so I'm not likely to do it=20
> there.
>=20
> But yes, I'm actually hoping that some new person will come in with a new=
=20
> idea. The current people seem to be too set in "their" corners, and I=20
> don't expect that to really change.
>=20
> Quite honestly, I don't foresee any of the current tree approaches really=
=20
> doing something new and obviously better, unless somebody new steps in.

That's because there is no other possibility. Sooner or later you have
to do a snapshot, and somehow you have to save it. You're not going to
get a new solution, just one that do those basic things in new and
better ways.

I'm perfectly willing to think through some alternate approach if you
suggest something or prod my thinking in a new direction, but I'm afraid
I just can't see right now how we can achieve what you're after.

Nigel

--=-i41BsiiPXcXH/B3XMMno
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMRCwN0y+n1M3mo0RAiGvAJ9hvtsw6dayVVcPbRgGXh2FmpS+3wCfbDu0
3RfHgaj6iGq//a2EMSFEzWg=
=dymh
-----END PGP SIGNATURE-----

--=-i41BsiiPXcXH/B3XMMno--

