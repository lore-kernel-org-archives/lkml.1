Return-Path: <linux-kernel-owner+w=401wt.eu-S1763399AbXF1L3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763399AbXF1L3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbXF1L3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:29:04 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:3099 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760095AbXF1L3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:29:03 -0400
Message-ID: <46839B10.7040005@imap.cc>
Date: Thu, 28 Jun 2007 13:27:12 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: crispin@novell.com, seanlkml@sympatico.ca, bunk@stusta.de,
       akpm@linux-foundation.org, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
References: <4682D13C.6060107@novell.com>	<20070627172940.1cabd5c4.seanlkml@sympatico.ca>	<4682E8E1.6090701@novell.com> <20070627.160535.71552808.davem@davemloft.net>
In-Reply-To: <20070627.160535.71552808.davem@davemloft.net>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB2C7BDEF0EBFEF487094C410"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB2C7BDEF0EBFEF487094C410
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

David Miller schrieb:
> What you get by the code going into the upstream kernel tree is that
> it a) adds some pseudo legitimacy to AppArmour (which I don't
> personally think is warranted) and b) gets the work of keeping
> apparmour working with upstream largely off of your back and in the
> hands of the upstream community.
>=20
> Neither of those are reasons why something should go into the tree.

I beg to differ. b) is *the* reason cited again and again on LKML
for submitting code for inclusion in the tree. Whenever anyone
posts anything which is remotely related to out-of-tree code,
whether it's a question on the usage of some standard in-tree
function, a request for help with a coding or debugging problem,
or out-of-tree repercussions of an in-tree change, he or she
invariably has to put up with an answer along the lines of: "put
your code into the tree and all your problems will be solved" -
or its sarcastic variant: "I can't find your code anywhere in
the current kernel sources".

You can't have it both ways. Either you go around bashing
people for maintaining their code out-of-tree or you go around
bashing people for trying to get their code into the tree.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigB2C7BDEF0EBFEF487094C410
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGg5sQMdB4Whm86/kRAmnIAJ477ztnC0UkGiYu3ZZjOExaK/IVkACeMZAL
I39sCeBhFsSebIXPEtvqcAU=
=OBvw
-----END PGP SIGNATURE-----

--------------enigB2C7BDEF0EBFEF487094C410--
