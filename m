Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXDZRLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXDZRLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXDZRL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:11:27 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:35187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbXDZRLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:11:17 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <4630CFE6.1050702@nortel.com>
References: <20070419070437.GA25211@elte.hu>
	 <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <1177582633.6814.29.camel@johannes.berg>
	 <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz>
	 <1177585897.6814.49.camel@johannes.berg>
	 <20070426111645.GR17387@elf.ucw.cz>
	 <1177586850.6814.52.camel@johannes.berg>
	 <20070426112641.GS17387@elf.ucw.cz>
	 <1177587308.6814.57.camel@johannes.berg>  <4630CFE6.1050702@nortel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+8BjQuIZS7wETA+DWNhU"
Date: Thu, 26 Apr 2007 19:11:13 +0200
Message-Id: <1177607473.6814.103.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+8BjQuIZS7wETA+DWNhU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-26 at 10:14 -0600, Chris Friesen wrote:
> Johannes Berg wrote:
>=20
> > Judging from experience with the wext 32/64 bit fiasco it seems to be
> > rather uncommon to use 32-bit userspace on 64-bit machines.
>=20
> I disagree...it's quite common.  I think its the standard way of doing=20
> things for ppc64, for instance.

I know. My only 64-bit machine is ppc64 :)

But still nobody noticed the wext 32/64 bit compat bug for like forever.
On the other hand, maybe that just means that most 64-bit machines are
desktop machines without wireless.

johannes

--=-+8BjQuIZS7wETA+DWNhU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMN0w/ETPhpq3jKURAi0+AKCgWkzv0iG8gcHOweXjI/ytN4styACeO8gl
/Y9/uhY/TYjsCiDHlEuoG9Y=
=KgHw
-----END PGP SIGNATURE-----

--=-+8BjQuIZS7wETA+DWNhU--

