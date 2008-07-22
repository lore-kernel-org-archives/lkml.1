Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYGVBfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYGVBfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 21:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYGVBfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 21:35:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55553 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYGVBfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 21:35:03 -0400
Date: Tue, 22 Jul 2008 11:34:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] serial: fix struct uart_info change fallout
Message-Id: <20080722113458.8c5c77c6.sfr@canb.auug.org.au>
In-Reply-To: <20080722003814.GA14809@redhat.com>
References: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
	<20080722003814.GA14809@redhat.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Jul_2008_11_34_58_+1000_.7NOZ=DtUIsBKIno"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Jul_2008_11_34_58_+1000_.7NOZ=DtUIsBKIno
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 21 Jul 2008 20:38:14 -0400 Dave Jones <davej@redhat.com> wrote:
>
> That's the same pair of patches I sent earlier, which apparently were
> "Already in the ttydev tree" which should be in linux-next ?

Indeed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Jul_2008_11_34_58_+1000_.7NOZ=DtUIsBKIno
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiFOUIACgkQjjKRsyhoI8wLvwCgv4wDxAOhnWLBb4/63R7TAOsj
iLwAn2xD4EMYGZ2Msglqn8ozg+ifokjZ
=bfBK
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Jul_2008_11_34_58_+1000_.7NOZ=DtUIsBKIno--
