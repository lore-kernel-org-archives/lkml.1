Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbXDZGEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbXDZGEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbXDZGEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:04:41 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:34888 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbXDZGEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:04:40 -0400
Subject: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Qv8u8WMdlg/BWdr2YnFX"
Date: Thu, 26 Apr 2007 16:04:40 +1000
Message-Id: <1177567481.5025.211.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Qv8u8WMdlg/BWdr2YnFX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi again.

So - trying to get back to the original discussion - what (if anything)
do you see as the way ahead?

The options I can think of are (starting with things I can do):

1) I stop developing Suspend2, thereby pushing however many current
Suspend2 users to move to [u]swsusp and seek to get that up to speed.

2) I quit my day job, see if Redhat will take me full time and give me
the time to start trying to merge Suspend2 bit by bit. Alternatively,
days suddenly become 8 hours longer and I discover the boundless energy
and alertness needed to do this too :). Ok. Not going to happen.

3) Someone else steps up to the plate and tries to merge Suspend2 one
bit at a time.

4) uswsusp and swsusp get dropped and Suspend2 goes into mainline.

5) Everything gets dropped and we start from scratch.

6) The status quo - or some small variant of it - stays. Oh... I said
"way ahead". I guess that rules this one out, even though I'll be very
surprised if it's not the one that wins out.

7) Suspend2 gets merged and people get to choose which they like better.
Nearly forgot this as a conceivable possibility. Yeah, I know you said
you don't want it. I'm just trying to think of what might possibly
happen.

N.

--=-Qv8u8WMdlg/BWdr2YnFX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMED4N0y+n1M3mo0RAhIDAKDQXLuXWXb1fiMrxx3oHzgF2CmP0wCg86rU
bjD0nY4NzhHlM2C93R0iIqE=
=cWG5
-----END PGP SIGNATURE-----

--=-Qv8u8WMdlg/BWdr2YnFX--

