Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0BWCVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:21:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42552 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab0BWCVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:21:50 -0500
Date: Tue, 23 Feb 2010 13:21:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       x86@kernel.org
Subject: Re: linux-next: build failure in i386 since next-20100104
Message-Id: <20100223132144.63020207.sfr@canb.auug.org.au>
In-Reply-To: <4B833B13.7060109@kernel.org>
References: <20100222220340.4b0a19fb.sfr@canb.auug.org.au>
	<4B833B13.7060109@kernel.org>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Feb_2010_13_21_44_+1100_crHDZ7OtBYQOnfsg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Feb_2010_13_21_44_+1100_crHDZ7OtBYQOnfsg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Mon, 22 Feb 2010 18:18:59 -0800 "H. Peter Anvin" <hpa@kernel.org> wrote:
>
> Already fixed in upstream, checkin 87b8d1adefa1548b591cbf0d63965987e2cf89=
3d.

Yep, saw that today, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Feb_2010_13_21_44_+1100_crHDZ7OtBYQOnfsg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDO7gACgkQjjKRsyhoI8wnXACfYGVbPoR+9sA7K5PMVOubipi8
ihoAnRYBiQvHCpVK4GWxJ3wkbV2iUoe8
=2YQh
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Feb_2010_13_21_44_+1100_crHDZ7OtBYQOnfsg--
