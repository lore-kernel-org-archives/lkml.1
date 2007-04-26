Return-Path: <linux-kernel-owner+w=401wt.eu-S1030310AbXDZLIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310AbXDZLIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXDZLIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:08:44 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbXDZLIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:08:44 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070426104052.GA19072@elf.ucw.cz>
References: <20070418211632.GA7610@elte.hu>
	 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <1177582633.6814.29.camel@johannes.berg>
	 <20070426103051.GP17387@elf.ucw.cz>  <20070426104052.GA19072@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nnEbYl2m52E1dqSVLMze"
Date: Thu, 26 Apr 2007 13:11:37 +0200
Message-Id: <1177585897.6814.49.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nnEbYl2m52E1dqSVLMze
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-26 at 12:40 +0200, Pavel Machek wrote:

> Does this seem to help?

No idea, I haven't actually tried it yet, last time I tried uswsusp on
my 32/32 machine it didn't work due to endian problems that were
supposed to be resolved but I haven't had a chance to pick all the bits
together that you need.

johannes

--=-nnEbYl2m52E1dqSVLMze
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMIjp/ETPhpq3jKURAgbKAKChQH4eJPf6j26BSWvQaLxmgzKMugCfT5jO
YQFzxZnXEufQztattj1pw7A=
=wcuB
-----END PGP SIGNATURE-----

--=-nnEbYl2m52E1dqSVLMze--

