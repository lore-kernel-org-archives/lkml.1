Return-Path: <linux-kernel-owner+w=401wt.eu-S1761381AbZFQNX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbZFQNX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZFQNXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:23:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37593 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZFQNXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:23:44 -0400
Date: Wed, 17 Jun 2009 23:23:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: subrata@linux.vnet.ibm.com, netdev@vger.kernel.org,
       Li Yang <leoli@freescale.com>, Nathan Lynch <ntl@pobox.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Tony Breeds <tony@bakeyournoodle.com>, michael@ellerman.id.au
Subject: Re: [PATCH][Resend 2][BUILD FAILURE 04/04] Next June 04:PPC64
 randconfig [drivers/net/ucc_geth.o]
Message-Id: <20090617232341.c4543ff2.sfr@canb.auug.org.au>
In-Reply-To: <6E26D0A1-0FE5-4179-9DA8-FDF0E3D417DA@kernel.crashing.org>
References: <20090611033705.20842.75501.sendpatchset@subratamodak.linux.ibm.com>
	<1245048719.5239.10.camel@subratamodak.linux.ibm.com>
	<1245243097.4870.3.camel@subratamodak.linux.ibm.com>
	<6E26D0A1-0FE5-4179-9DA8-FDF0E3D417DA@kernel.crashing.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Jun_2009_23_23_41_+1000_.izVW4hEBDoJIIBE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Jun_2009_23_23_41_+1000_.izVW4hEBDoJIIBE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kumar,

On Wed, 17 Jun 2009 08:07:47 -0500 Kumar Gala <galak@kernel.crashing.org> w=
rote:
>
>=20
> I'm confused by the proposed fix as we already have *mdio & *ph =20
> defined in this function:

Which tree are you looking at?  Linus' tree, and linux-next, do not have
those local variables ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Jun_2009_23_23_41_+1000_.izVW4hEBDoJIIBE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko47l0ACgkQjjKRsyhoI8z1OgCgqkPf9dXeSPtNV2LlDOCBzfGn
VaUAoJedD4+E4MU3dN11tRAzwqt/7AxN
=Cphp
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Jun_2009_23_23_41_+1000_.izVW4hEBDoJIIBE--
