Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYG1ASM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYG1ASM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYG1AR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:17:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60733 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbYG1AR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:17:58 -0400
Date: Mon, 28 Jul 2008 10:17:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland Dreier <rdreier@cisco.com>, kkeil@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-Id: <20080728101752.7a6795c6.sfr@canb.auug.org.au>
In-Reply-To: <20080727204355.GA14057@uranus.ravnborg.org>
References: <20080728023732.090aff83.sfr@canb.auug.org.au>
	<20080727182709.1dac0556@lxorguk.ukuu.org.uk>
	<20080727.125604.73857337.davem@davemloft.net>
	<adamyk35aoi.fsf@cisco.com>
	<20080727204355.GA14057@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Jul_2008_10_17_52_+1000_zgGZj5WOY7vvXzA7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jul_2008_10_17_52_+1000_zgGZj5WOY7vvXzA7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Sun, 27 Jul 2008 22:43:55 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> On Sun, Jul 27, 2008 at 01:33:49PM -0700, Roland Dreier wrote:
> >  > IMHO, this driver was really rushed in and that was a huge mistake.
> >  > If it had gone through linux-next we could have tidied all of this
> >  > stuff up in a less "rushed" manner.
> >=20
> > ??  This thread *is* about a build failure in linux-next.
> mISDN are in -linus which is part of -next and Stephens point is that if
> we have had mISDN in -next then this would have been fixed before hitting
> -linus.

Dave made that point, not me.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Jul_2008_10_17_52_+1000_zgGZj5WOY7vvXzA7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiNEDAACgkQjjKRsyhoI8zUAQCeJS5Qs8kEGj5YD8yllyKApElY
c44AoLjVrhr6XGQRTfsxBKSUFmMvBWxP
=IH1b
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jul_2008_10_17_52_+1000_zgGZj5WOY7vvXzA7--
