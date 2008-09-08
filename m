Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYIHMWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYIHMWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYIHMWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:22:40 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:54594 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYIHMWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:22:39 -0400
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
From: Tony Vroon <tony@vroon.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87abeivrdf.fsf@basil.nowhere.org>
References: <1220754742.8530.12.camel@localhost>
	 <87abeivrdf.fsf@basil.nowhere.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TrO4oSsidJgfvC5P1qQO"
Date: Mon, 08 Sep 2008 13:22:39 +0100
Message-Id: <1220876559.27320.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TrO4oSsidJgfvC5P1qQO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 12:55 +0200, Andi Kleen wrote:
> It unfortunately turns out that mcelog logging is a tricky
> psychological problem. How should the warning above have
> looked like so that you would not have required "peer insight"
> and actually just contacted your hardware vendor?=20

Indication of the faulty part, so I know whether to contact AMD or Tyan.
Without a clear idea of which it could quickly turn into an infinite
redirect loop between the two.

Regards,
Tony V.

--=-TrO4oSsidJgfvC5P1qQO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjFGQ8ACgkQp5vW4rUFj5o+TwCffNZKD3Jvu5UzndLpd16WD2As
/5IAnR9iUyzwjK3JquhKaA01Daeec5rR
=mzQh
-----END PGP SIGNATURE-----

--=-TrO4oSsidJgfvC5P1qQO--

