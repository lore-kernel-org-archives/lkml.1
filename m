Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbXJ1Xu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbXJ1Xu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbXJ1XuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:50:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbXJ1XuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:50:17 -0400
Date: Mon, 29 Oct 2007 10:50:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] pcmcia: Remove replace kio_addr_t with unsigned int
 everywhere
Message-Id: <20071029105005.d85e212e.sfr@canb.auug.org.au>
In-Reply-To: <20071028201858.GA10048@lixom.net>
References: <20070905142742.GA1760@lixom.net>
	<20070914034854.1658a9cf.akpm@linux-foundation.org>
	<20070921221516.GA7926@lixom.net>
	<20070921233936.2aeb2504@the-village.bc.nu>
	<20070922062551.GE10625@parisc-linux.org>
	<20070922091303.GA12525@lst.de>
	<20071019201720.GA13234@lixom.net>
	<20071028134414.GF26943@isilmar.linta.de>
	<20071028201034.GB9472@lixom.net>
	<20071028201858.GA10048@lixom.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Oct_2007_10_50_05_+1100_/wj1YA2jLaKIDaIk"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Oct_2007_10_50_05_+1100_/wj1YA2jLaKIDaIk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Olof,

diffstat output is very useful - especially for patches like this that
touch lots of files.  It makes it easier for potential reviewers to see
if they should be potential reviewers.  :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Oct_2007_10_50_05_+1100_/wj1YA2jLaKIDaIk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJSAyTgG2atn1QN8RAv7yAKCObr3GjbrpzJI8sXVagHeKbC0ZmgCfYFac
F/JZV1JYRRVd1IICT1KeiTo=
=Uyqn
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Oct_2007_10_50_05_+1100_/wj1YA2jLaKIDaIk--
