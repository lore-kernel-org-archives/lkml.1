Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYKUFbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYKUFbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 00:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYKUFbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 00:31:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58580 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYKUFbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 00:31:25 -0500
Date: Fri, 21 Nov 2008 16:31:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] cpu alloc cleanups and implementation improvement
Message-Id: <20081121163111.7107315e.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0811201030240.19948@quilx.com>
References: <200811172353.18356.rusty@rustcorp.com.au>
	<Pine.LNX.4.64.0811201030240.19948@quilx.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_Nov_2008_16_31_11_+1100_kIwZ2l=r3eEWdu1M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Nov_2008_16_31_11_+1100_kIwZ2l=r3eEWdu1M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Thu, 20 Nov 2008 10:35:05 -0600 (CST) Christoph Lameter <cl@linux-founda=
tion.org> wrote:
>
> On Mon, 17 Nov 2008, Rusty Russell wrote:
>=20
> >   I've argued with Christoph that his implementation contains gratuitous
> > obsolescence of perfectly-good APIs; hopefully providing real patches w=
ill
> > give us a more useful debate.
>=20
> I would not mind if you would take over from here.

So, should I remove the cpu_alloc tree from linux-next?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_Nov_2008_16_31_11_+1100_kIwZ2l=r3eEWdu1M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkmR58ACgkQjjKRsyhoI8wV1gCeMREaWD8YIUVYFhFOGNvW7CMW
5lgAn0NHO5P9oP0MZSyKuoYhxeUzSrW8
=fvMA
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Nov_2008_16_31_11_+1100_kIwZ2l=r3eEWdu1M--
