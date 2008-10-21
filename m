Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbYJUWzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbYJUWzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYJUWzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:55:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45405 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYJUWzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:55:44 -0400
Date: Wed, 22 Oct 2008 09:55:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21
Message-Id: <20081022095532.63cad898.sfr@canb.auug.org.au>
In-Reply-To: <1224609617.16910.94.camel@macbook.infradead.org>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au>
	<1224609617.16910.94.camel@macbook.infradead.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Oct_2008_09_55_32_+1100_2w2yDdgaF2_1.zVD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Oct_2008_09_55_32_+1100_2w2yDdgaF2_1.zVD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, 21 Oct 2008 18:20:17 +0100 David Woodhouse <dwmw2@infradead.org> wr=
ote:
>
> Missing the git://git.infradead.org/iommu-2.6.git tree, which contains a
> bunch of patches which had got dropped over the last few weeks, and
> which I need to send to Linus before the merge window closes. I was
> really hoping they'd be in today's linux-next :(

I was waiting for
	1) the dust to settle
	2) someone to tell me that the tree should be included
	3) someone to make clear that it only contains 2.6.28 stuff

You have now done that, so I will include it today and call it dwmw2-iommu
(unless you have a better name.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Oct_2008_09_55_32_+1100_2w2yDdgaF2_1.zVD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj+XeQACgkQjjKRsyhoI8wyHgCgiq1Pv0QrKlxBh/jstjgR6fzn
yVkAn3xbFr/AklsEcSA2FvKRVI3VaKes
=4NlG
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Oct_2008_09_55_32_+1100_2w2yDdgaF2_1.zVD--
