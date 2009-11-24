Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbZKXA1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbZKXA1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZKXA1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:27:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41145 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbZKXA1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:27:44 -0500
Date: Tue, 24 Nov 2009 11:27:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org
Subject: Re: linux-next: failed to fetch the mips tree
Message-Id: <20091124112739.dd1ba1f7.sfr@canb.auug.org.au>
In-Reply-To: <20091124000929.GA7223@linux-mips.org>
References: <20091124105303.512479aa.sfr@canb.auug.org.au>
	<20091124000929.GA7223@linux-mips.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Nov_2009_11_27_39_+1100_nlMtMNEaWOnI5tua"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Nov_2009_11_27_39_+1100_nlMtMNEaWOnI5tua
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

On Tue, 24 Nov 2009 00:09:29 +0000 Ralf Baechle <ralf@linux-mips.org> wrote:
>
> On Tue, Nov 24, 2009 at 10:53:03AM +1100, Stephen Rothwell wrote:
>=20
> > git.linux-mips.org[0: 78.24.191.183]: errno=3DConnection refused
> > fatal: unable to connect a socket (Connection refused)
>=20
> Thanks.  I upgraded the machine from Fedora 10 to Fedora 12 and the
> removal of the git "dash-commands" resulted in this failure.  Fixed.

All good now, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Nov_2009_11_27_39_+1100_nlMtMNEaWOnI5tua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksLKHsACgkQjjKRsyhoI8wmuACdH0/k57CcVyFkTBtU34iHniu5
eQQAoLe2iX1HG8JeJH6337HCwRF6mo+8
=HjN+
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Nov_2009_11_27_39_+1100_nlMtMNEaWOnI5tua--
