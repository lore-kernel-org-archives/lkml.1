Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbXEZWXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbXEZWXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXEZWX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:23:28 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:2799 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbXEZWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:23:27 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: suspend2-devel@lists.suspend2.net
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Sun, 27 May 2007 00:23:16 +0200
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>
References: <200704182245.24156.mail@earthworm.de> <200705261938.03911.Martin@lichtvoll.de> <200705262235.17230.rjw@sisk.pl> (sfid-20070527_000444_422405_57E3632E)
In-Reply-To: <200705262235.17230.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2038769.R3eJYZR0pa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705270023.24219.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2038769.R3eJYZR0pa
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Samstag 26 Mai 2007 schrieb Rafael J. Wysocki:

Hi Rafael!

> The outcome was, more-or-less, that we'll work on merging suspend2 or
> at least some parts of it.
>
> However, in the meantime there have been some discussions implying that
> we have some important problems with suspend/hibernation that suspend2
> doesn't solve and that IMHO are more urgent than the merging of
> suspend2 right not.
>
> So, as far as I'm concerned, the plan is to fix the more urgent
> problems first and to work on merging suspend2 as far as there's time
> to do this.
>
> The problem is there are only a few people working on it and there's a
> lot to do, so I can only ask you to be patient. ;-)

Thats fine with me - I understand that. I just thought that there has been=
=20
no outcome at all.

I will try to be patient as long as I do not dig into kernel hacking=20
myself deeply enough to be able to help with that - did not do more than=20
to put together two conflicting patches to compile my own kernels till=20
now and forward port a patch for a sundance network card.  I can help=20
with testing once there is something testable tough.

Regards,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2038769.R3eJYZR0pa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQBGWLNcmRvqrKWZhMcRAkCtAJdXTP6Jsc+9VE/2O8grrRjubTXvAJ4+aP0h
x/nFjW+IqGDwhP+RcjDIMQ==
=weXF
-----END PGP SIGNATURE-----

--nextPart2038769.R3eJYZR0pa--
