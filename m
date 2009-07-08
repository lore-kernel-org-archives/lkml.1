Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZGHE6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZGHE6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZGHE60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:58:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49664 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZGHE60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:58:26 -0400
Date: Wed, 8 Jul 2009 14:58:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem.Bityutskiy@nokia.com
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: ubi tree build warnings
Message-Id: <20090708145819.3ad0c903.sfr@canb.auug.org.au>
In-Reply-To: <4A542452.6060703@nokia.com>
References: <20090708130921.a361f6d2.sfr@canb.auug.org.au>
	<4A542452.6060703@nokia.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jul_2009_14_58_19_+1000_4_coQtPNJ9P1qRK8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jul_2009_14_58_19_+1000_4_coQtPNJ9P1qRK8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Wed, 08 Jul 2009 07:45:06 +0300 Artem Bityutskiy <Artem.Bityutskiy@nokia=
.com> wrote:
>
> Will fix ASAP, thank you! I'm always wondering how you manage
> to reproduce warnings I do not see.

Probably a different config or compiler (I am using gcc 4.4.0).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Jul_2009_14_58_19_+1000_4_coQtPNJ9P1qRK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpUJ2sACgkQjjKRsyhoI8zCBQCfZRKydeY7X69PEhAC+BEjQgO/
da0AoLxSPHw3V4+NaJ5EG6Aww96a41g0
=h2i7
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jul_2009_14_58_19_+1000_4_coQtPNJ9P1qRK8--
