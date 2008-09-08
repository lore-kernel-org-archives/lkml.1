Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYIHUgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYIHUgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYIHUg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:36:29 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:59082 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYIHUg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:36:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=XigakGYXMtHv6RwznnV65BcQE32QVBHSh1hXa0MjFP8mrGsQzKYzhPQnwiDENSjAQM
         bOkT0w69KiT501Wckc1rByu7FA40OYx491MsDeTiHsZkzWUjidn7LjlcvpgsZbWiDPub
         unLxeQ/fSmkuiVGyQ6KX+iS/VbVptBkiQkhMU=
Subject: Re: Various OOps with 2.6.27-rc5
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080908124641.9ec6887a.randy.dunlap@oracle.com>
References: <1220815296.11776.4.camel@Varda>
	 <20080908124641.9ec6887a.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NTInUJupjba9tZNw31Wr"
Date: Mon, 08 Sep 2008 22:36:22 +0200
Message-Id: <1220906182.15312.1.camel@Varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NTInUJupjba9tZNw31Wr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

El lun, 08-09-2008 a las 12:46 -0700, Randy Dunlap escribi=C3=B3:

[ ... ]
> > The dmesg including oopses
>=20
> Actually they are INFO: messages with getnstimeofday() being stuck,
> similar to a few other reports on lkml.

 So is it useful to report them or i just do:
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
 And forget about it ??


> [ ... ]
>=20

 Thanks for the answer,
 Cheers

--=20
The idea that Bill Gates has appeared like a knight in shining armour to
lead all customers out of a mire of technological chaos neatly ignores
the fact that it was he who, by peddling second-rate technology, led
them into it in the first place.=20
                                     Douglas Adams

--=-NTInUJupjba9tZNw31Wr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Esta parte del mensaje =?ISO-8859-1?Q?est=E1?= firmada
	digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkjFjMYACgkQ3GEkiSnUSOFifgCfT1cDNK+Ka/+wcnX0xs0w+M+w
gKQAnjX6A1XrPz7rvwO86h1NhWzPW2+A
=9Bfp
-----END PGP SIGNATURE-----

--=-NTInUJupjba9tZNw31Wr--

