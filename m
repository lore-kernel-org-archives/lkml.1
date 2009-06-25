Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZFYVQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZFYVQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbZFYVQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:16:17 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:32800 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbZFYVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=bvqKC00lKNAzjTUk+95ga0BWFiavP7mq4tVjgR5Z9xM1092r0rmNQmOVqeZdheVCC2
         OPpK+69abwjr9rG9FqCdEbuLcqZPBlAU8DT8jNxdk1hNN+71/HNiVdLNGcecaLUkI3ML
         Ngkfde4yeTtLyUM7q4PLIMYmBubPsOeKZ3ESc=
Subject: Re: [rtc-linux] [PATCH] PCAP RTC driver (for 2.6.32).
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>, akpm@linux-foundation.org
In-Reply-To: <20090625225339.3393f1d9@i1501.lan.towertech.it>
References: <1245962749.10360.42.camel@brutus>
	 <20090625225339.3393f1d9@i1501.lan.towertech.it>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wDOKQe7jUmBCuDPPBhoD"
Date: Thu, 25 Jun 2009 18:16:09 -0300
Message-Id: <1245964569.10360.48.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wDOKQe7jUmBCuDPPBhoD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Qui, 2009-06-25 =C3=A0s 22:53 +0200, Alessandro Zummo escreveu:
> > RTC driver for PCAP2 PMIC.
> >=20
> > This patch was sent some time ago and acked by Alessandro, but we had t=
o
> > change some stuff on the core driver and consequently on this driver
> > too, so I'm submitting it again for review (sorry).
> >=20
> > Signed-off-by: guiming zhuo <gmzhuo@gmail.com>
> > Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
>=20
>  Acked-by: Alessandro Zummo <a.zummo@towertech.it>
>=20

Wow, this was fast! Thanks! :)

Alessandro, as there are no dependencies on other subsystems, it would
be good if this driver gets merged through your tree. Is this ok for
you?

--=20
Daniel Ribeiro

--=-wDOKQe7jUmBCuDPPBhoD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpD6RgACgkQw3OYl0G0liQMHQCfdxnLUF8D3ZYOEwMTAOUH9OT0
4d4AnjxZC9WOWjr1zcxnby3UihXN+WNE
=ukdA
-----END PGP SIGNATURE-----

--=-wDOKQe7jUmBCuDPPBhoD--

