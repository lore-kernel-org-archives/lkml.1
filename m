Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbXIJLIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbXIJLIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 07:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbXIJLID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 07:08:03 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbXIJLIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 07:08:00 -0400
Subject: Re: [2/2] 2.6.23-rc5: known regressions with patches v2
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Christian Casteyde <casteyde.christian@free.fr>,
       Alan Stern <stern@rowland.harvard.edu>, netdev@vger.kernel.org,
       Florian Lohoff <flo@rfc822.org>, linux-wireless@vger.kernel.org,
       Martin Langer <martin-langer@gmx.de>, Stefano Brivio <st3@riseup.net>,
       Michael Buesch <mbuesch@freenet.de>,
       Danny van Dyk <kugelfang@gentoo.org>,
       Andreas Jaggi <andreas.jaggi@waterwave.ch>
In-Reply-To: <46E2836B.60406@googlemail.com>
References: <46E28149.2090900@googlemail.com>
	 <46E2836B.60406@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RXc8z+5z+ykjplKG/obX"
Date: Mon, 10 Sep 2007 13:09:22 +0200
Message-Id: <1189422562.4506.56.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RXc8z+5z+ykjplKG/obX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-08 at 13:11 +0200, Michal Piotrowski wrote:

> Subject         : Unable to access memory card reader anymore
> References      : http://bugzilla.kernel.org/show_bug.cgi?id=3D8885
> Last known good : ?
> Submitter       : Christian Casteyde <casteyde.christian@free.fr>
> Caused-By       : ?
> Handled-By      : Alan Stern <stern@rowland.harvard.edu>
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=3D12438
> Status          : patch available

Last known good/caused-by doesn't apply, the bug has been in there ever
since the mac80211 code was merged into the tree.

johannes

--=-RXc8z+5z+ykjplKG/obX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5SXi/ETPhpq3jKURAonYAJ496VbOMMdBmfXcSIAGj7SP8WHOogCgsAIh
mPIagbcK0ZbIFGjIpzwROos=
=gxUL
-----END PGP SIGNATURE-----

--=-RXc8z+5z+ykjplKG/obX--

