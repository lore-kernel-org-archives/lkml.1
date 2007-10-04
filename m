Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbXJDQrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbXJDQrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759063AbXJDQq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:46:56 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:42780 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758311AbXJDQq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:46:56 -0400
Date: Thu, 4 Oct 2007 18:46:53 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Don Mullis <dwm@meer.net>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004184653.14201ff6@poseidon.drzeus.cx>
In-Reply-To: <20071004164225.GF5711@kernel.dk>
References: <1191478262.21598.5.camel@dmullis-laptop>
	<20071003231659.f41df5ed.akpm@linux-foundation.org>
	<20071004072515.GC5236@kernel.dk>
	<1191514780.30871.1.camel@dmullis-laptop>
	<20071004183555.3e0ed9eb@poseidon.drzeus.cx>
	<20071004164225.GF5711@kernel.dk>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-5710-1191516388-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-5710-1191516388-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Oct 2007 18:42:25 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

>=20
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index b0abc7d..a5d0354 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

(Provided it works ;))

I have no patches touching queue.c in my tree, so there should be no
problems with merge conflicts.

Rgds
Pierre

--=_hera.drzeus.cx-5710-1191516388-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHBRj97b8eESbyJLgRAqEbAKDVVr9az/e2Ugwq3YBcASmhHsaH8gCggCEf
hd49jVGVO5u4GHWynyKGPyQ=
=h2mU
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-5710-1191516388-0001-2--
