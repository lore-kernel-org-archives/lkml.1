Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbXJDICW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbXJDICW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 04:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbXJDICC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 04:02:02 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:52685 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbXJDICA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:02:00 -0400
Date: Thu, 4 Oct 2007 10:01:54 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Mullis <dwm@meer.net>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004100154.6093844d@poseidon.drzeus.cx>
In-Reply-To: <20071004072515.GC5236@kernel.dk>
References: <1191478262.21598.5.camel@dmullis-laptop>
	<20071003231659.f41df5ed.akpm@linux-foundation.org>
	<20071004072515.GC5236@kernel.dk>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-31478-1191484892-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-31478-1191484892-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Oct 2007 09:25:15 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

>=20
> It looks like missing init of the sg list in mmc, does this work?
>=20

Huh? Isn't the block layer supposed to fill in the entire thing? (i.e.
current contents shouldn't matter)

Rgds
Pierre

--=_hera.drzeus.cx-31478-1191484892-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHBJ3z7b8eESbyJLgRAkwwAKCht5Xho6HsN2tY9ppRYA4mVFWOgQCgg+rg
eBSOqsES0KBwIIKIwhlDvdI=
=a8Bn
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-31478-1191484892-0001-2--
