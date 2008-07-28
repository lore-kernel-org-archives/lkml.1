Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbYG1AUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbYG1AUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYG1AUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:20:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51812 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172AbYG1AUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:20:44 -0400
Date: Mon, 28 Jul 2008 10:20:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: rdreier@cisco.com, alan@lxorguk.ukuu.org.uk, kkeil@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-Id: <20080728102035.8a2f5723.sfr@canb.auug.org.au>
In-Reply-To: <20080727.161432.237385384.davem@davemloft.net>
References: <20080727182709.1dac0556@lxorguk.ukuu.org.uk>
	<20080727.125604.73857337.davem@davemloft.net>
	<adamyk35aoi.fsf@cisco.com>
	<20080727.161432.237385384.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Jul_2008_10_20_35_+1000_8Dh=CkFJWb7nz5=O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jul_2008_10_20_35_+1000_8Dh=CkFJWb7nz5=O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 27 Jul 2008 16:14:32 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> The driver went directly into Linus's tree.
>=20
> Stephen hit the build problem once he synced linux-next up with
> Linus's current tree.

It didn't even get as far as linux-next, I was just browsing the
bloodbath that is/was Linus' tree
(http://kisskb.ellerman.id.au/kisskb/branch/3/) :-(.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Jul_2008_10_20_35_+1000_8Dh=CkFJWb7nz5=O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiNENMACgkQjjKRsyhoI8zx+ACfUUeLkOPOgV2Gs8Y9bfiC+V9d
L/MAni7xOGxtSzIaaYYS/xErKv54tAaw
=Wi4t
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jul_2008_10_20_35_+1000_8Dh=CkFJWb7nz5=O--
