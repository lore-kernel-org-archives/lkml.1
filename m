Return-Path: <linux-kernel-owner+w=401wt.eu-S1030323AbXDZKOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323AbXDZKOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030565AbXDZKOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:14:04 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:43654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030505AbXDZKOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:14:03 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070424212408.GD16457@elf.ucw.cz>
References: <20070413202100.GA9957@elte.hu>
	 <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu>
	 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xduRuLbubfga36TRMMV1"
Date: Thu, 26 Apr 2007 12:17:12 +0200
Message-Id: <1177582633.6814.29.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xduRuLbubfga36TRMMV1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-04-24 at 23:24 +0200, Pavel Machek wrote:

> I believe uswsusp user/kernel separation is clean enough. Kernel
> provides "snapshot image" and "resume image". (Thanks go to Rafael for
> very clean interface).

The interface isn't even 64/32-bit compatible...

johannes

--=-xduRuLbubfga36TRMMV1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMHwo/ETPhpq3jKURAv1BAKC4ngBgpIa2yfhU5QM0Qi8zbOb3egCgtmCC
uyPsdVTNRM0JZsHZoeZV18s=
=FRGP
-----END PGP SIGNATURE-----

--=-xduRuLbubfga36TRMMV1--

