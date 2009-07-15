Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbZGOHcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbZGOHcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZGOHcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:32:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36068 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZGOHcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:32:20 -0400
Date: Wed, 15 Jul 2009 17:32:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: dwmw2-iommu tree build failure
Message-Id: <20090715173216.ad0dad10.sfr@canb.auug.org.au>
In-Reply-To: <1247642959.10050.220.camel@macbook.infradead.org>
References: <20090715140116.c2ce8fde.sfr@canb.auug.org.au>
	<1247642959.10050.220.camel@macbook.infradead.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Jul_2009_17_32_16_+1000_OqsfKZsM4vwm_olY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jul_2009_17_32_16_+1000_OqsfKZsM4vwm_olY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, 15 Jul 2009 08:29:19 +0100 David Woodhouse <dwmw2@infradead.org> wr=
ote:
>
> Oops, I need to kill the lockdep references to that lock too. Fixed now;

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Jul_2009_17_32_16_+1000_OqsfKZsM4vwm_olY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpdhgAACgkQjjKRsyhoI8w7iQCePg1u9uyk1lJdgp8HY/eaOiPd
zl4AnR6ihr/7zo7BMffO6giIo2sxxC5R
=MnCE
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jul_2009_17_32_16_+1000_OqsfKZsM4vwm_olY--
