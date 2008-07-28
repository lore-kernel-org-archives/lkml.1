Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYG1AQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYG1AQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbYG1AQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:16:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60713 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbYG1AQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:16:48 -0400
Date: Mon, 28 Jul 2008 10:16:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: David Miller <davem@davemloft.net>, kkeil@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-Id: <20080728101643.82a7e870.sfr@canb.auug.org.au>
In-Reply-To: <adamyk35aoi.fsf@cisco.com>
References: <20080728023732.090aff83.sfr@canb.auug.org.au>
	<20080727182709.1dac0556@lxorguk.ukuu.org.uk>
	<20080727.125604.73857337.davem@davemloft.net>
	<adamyk35aoi.fsf@cisco.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Jul_2008_10_16_43_+1000_jdpyc/KrfJVT1vik"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jul_2008_10_16_43_+1000_jdpyc/KrfJVT1vik
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

On Sun, 27 Jul 2008 13:33:49 -0700 Roland Dreier <rdreier@cisco.com> wrote:
>
>  > IMHO, this driver was really rushed in and that was a huge mistake.
>  > If it had gone through linux-next we could have tidied all of this
>  > stuff up in a less "rushed" manner.
>=20
> ??  This thread *is* about a build failure in linux-next.

I noticed this in Linus' tree ... I did not mention linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Jul_2008_10_16_43_+1000_jdpyc/KrfJVT1vik
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiND+sACgkQjjKRsyhoI8zuYACfQ4ekFN33ugVADihvkp36bTrq
QEgAn26mE9XGwE5SI21YkP9hM0376PjL
=q8mI
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jul_2008_10_16_43_+1000_jdpyc/KrfJVT1vik--
