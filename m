Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbZIPPUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbZIPPUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbZIPPUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:20:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50610 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759222AbZIPPUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:20:38 -0400
Date: Thu, 17 Sep 2009 01:20:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Kumar Gala <galak@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] first round of PCI updates for 2.6.32
Message-Id: <20090917012035.e7b8b425.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.01.0909160753000.4950@localhost.localdomain>
References: <20090915132105.2fdd1d45@jbarnes-g45>
	<alpine.LFD.2.01.0909160753000.4950@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Sep_2009_01_20_35_+1000_Q6FxS/OgmzIBxub1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Sep_2009_01_20_35_+1000_Q6FxS/OgmzIBxub1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Wed, 16 Sep 2009 07:55:59 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> This one clashed trivially with the powerpc merge ("move pci_64.c device=
=20
> tree scanning code into pci-common.c" clashes with "PCI/powerpc: support
> PCIe fundamental reset.")
>=20
> I fixed it up, and I'm pretty sure it's all ok (it really was just a=20
> function movement and a single new added line), but ppc PCI people should=
=20
> double-check the result.

It looks good and matches the fix I have been carrying in linux-next for
some time.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Sep_2009_01_20_35_+1000_Q6FxS/OgmzIBxub1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqxAkQACgkQjjKRsyhoI8w/cwCcCYqG4ZD6zUC1aRcd2TA1lObx
CDEAoK5y7/1HcS6xHB7IHvaRwVGm9589
=Ifex
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Sep_2009_01_20_35_+1000_Q6FxS/OgmzIBxub1--
