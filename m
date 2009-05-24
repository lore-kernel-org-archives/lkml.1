Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbZEXGiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbZEXGiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 02:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZEXGiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 02:38:13 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:36345 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZEXGiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 02:38:12 -0400
Subject: Re: mpc8315e-rdb: pci_enable_msi() fails (using today's 
 galak/powerpc.git tree)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Linux PPC <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <c384c5ea0905231512u72894e34g17746548e640d4fe@mail.gmail.com>
References: <c384c5ea0905231358t4803fbc6gf54618b2839a448a@mail.gmail.com>
	 <c384c5ea0905231512u72894e34g17746548e640d4fe@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-e+v5y4I+8MwMO+hRXr4g"
Date: Sun, 24 May 2009 16:38:11 +1000
Message-Id: <1243147091.27293.3.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-e+v5y4I+8MwMO+hRXr4g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-24 at 00:12 +0200, Leon Woestenberg wrote:
> Hello,
>=20
> On Sat, May 23, 2009 at 10:58 PM, Leon Woestenberg
> <leon.woestenberg@gmail.com> wrote:
> > using this tree: git://git.kernel.org/pub/scm/linux/kernel/git/galak/po=
werpc.git
> >
> > pci_enable_msi() fails on my MPC8315E-RDB board with PCIe device in

<snip good bug report>

'lspci -vvv' of the device in question is often useful too.

cheers


--=-e+v5y4I+8MwMO+hRXr4g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoY61MACgkQdSjSd0sB4dIszgCfSZwTcpPgmZmKUhch7m3SIqyJ
9GgAoJiWfHusf2xDl0Q/xen/vc4S7d8w
=aT5v
-----END PGP SIGNATURE-----

--=-e+v5y4I+8MwMO+hRXr4g--

