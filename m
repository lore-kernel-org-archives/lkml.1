Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbXD0MHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbXD0MHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXD0MHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:07:12 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:60442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbXD0MHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:07:10 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Nick Piggin <npiggin@suse.de>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200704271409.56687.rjw@sisk.pl>
References: <20070425072350.GA6866@ucw.cz> <200704271218.07120.rjw@sisk.pl>
	 <1177669179.7828.53.camel@johannes.berg>  <200704271409.56687.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Duv+W3zEEh/Xf3CK2V7z"
Date: Fri, 27 Apr 2007 14:07:03 +0200
Message-Id: <1177675623.6024.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Duv+W3zEEh/Xf3CK2V7z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 14:09 +0200, Rafael J. Wysocki wrote:

> Yes.  Still, I'd like to rework your patch to deal with ACPI without
> introducing hibernate_ops .  I'm going to do this later today if you don'=
t
> mind. :-)

Not at all :) That's why I actually sent it out instead of just saying
"well I give up it breaks user.c"

johannes

--=-Duv+W3zEEh/Xf3CK2V7z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMedm/ETPhpq3jKURAmzgAJ0UPtMWRQqszy3TTebsAdowYCdonwCgmww1
M7AKOJZXkosQfpUASSO4HWI=
=TE+E
-----END PGP SIGNATURE-----

--=-Duv+W3zEEh/Xf3CK2V7z--

