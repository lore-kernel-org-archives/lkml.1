Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZHaMVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZHaMVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZHaMVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:21:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38834 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbZHaMVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:21:08 -0400
Date: Mon, 31 Aug 2009 22:21:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: linux-next: i2c tree build failure
Message-Id: <20090831222102.f75ab10b.sfr@canb.auug.org.au>
In-Reply-To: <20090831141546.6c52c7fb@hyperion.delvare>
References: <20090831111935.5059565b.sfr@canb.auug.org.au>
	<20090831120449.3f64aa74@hyperion.delvare>
	<20090831210335.f382d7ff.sfr@canb.auug.org.au>
	<20090831131647.3f609ad4@hyperion.delvare>
	<20090831215905.caadce2f.sfr@canb.auug.org.au>
	<20090831141546.6c52c7fb@hyperion.delvare>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Aug_2009_22_21_02_+1000_gvc4IZW9qAGb7A=e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Aug_2009_22_21_02_+1000_gvc4IZW9qAGb7A=e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Mon, 31 Aug 2009 14:15:46 +0200 Jean Delvare <khali@linux-fr.org> wrote:
>
> I've made sure my patch has the same name as Greg's, to make it easier
> for you to spot duplicates.

Thanks.

> > Just readd the patch :-)
>=20
> OK, done. Hopefully the next merge window is coming soon now anyway, and
> then the trouble with this specific patch will be solved.

Indeed - and I can get more sleep :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Aug_2009_22_21_02_+1000_gvc4IZW9qAGb7A=e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqbwC4ACgkQjjKRsyhoI8wuSACfXF3iS/YDICBS876JtD4Usdjt
ZBkAnikLAE62GF0SLlB3Bwx9jsnyu33i
=mNvE
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Aug_2009_22_21_02_+1000_gvc4IZW9qAGb7A=e--
