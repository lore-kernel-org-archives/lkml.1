Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYJTWbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYJTWbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYJTWbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:31:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43899 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYJTWbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:31:38 -0400
Date: Tue, 21 Oct 2008 09:31:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, Christopher Harrer <charrer@alacritech.com>,
       Michael Miles <mmiles@alacritech.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linus@kroah.com
Subject: Re: linux-next: build failure
Message-Id: <20081021093129.eaccead1.sfr@canb.auug.org.au>
In-Reply-To: <20081020154857.GC24666@kroah.com>
References: <20081020230420.aa85f83b.sfr@canb.auug.org.au>
	<20081020154857.GC24666@kroah.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Oct_2008_09_31_29_+1100_/ufd884U=LUiCMKq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Oct_2008_09_31_29_+1100_/ufd884U=LUiCMKq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 20 Oct 2008 08:48:57 -0700 Greg KH <greg@kroah.com> wrote:
>
> Ah, doh, sorry, I should have caught that.  I'll go apply this to the
> tree, thanks.

Linus seems to have already applied it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Oct_2008_09_31_29_+1100_/ufd884U=LUiCMKq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj9BsEACgkQjjKRsyhoI8y9UQCgvPZPlM9O2iveHWQ10j0dts7b
EJwAoJipX0UTuA/Jur9klGRI246Ki4kw
=+Qp8
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Oct_2008_09_31_29_+1100_/ufd884U=LUiCMKq--
