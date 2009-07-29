Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZG2Dhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZG2Dhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 23:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZG2Dhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 23:37:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34429 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbZG2Dhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 23:37:35 -0400
Date: Wed, 29 Jul 2009 13:37:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, kevin.huang@rdc.com.tw
Subject: Re: [PATCH] pata_rdc: driver for RDC ATA devices
Message-Id: <20090729133728.34b738eb.sfr@canb.auug.org.au>
In-Reply-To: <4A6FBC6F.6040404@garzik.org>
References: <20090624172930.24354.80799.stgit@t61.ukuu.org.uk>
	<4A6FA304.6070501@garzik.org>
	<20090729025307.GA25100@kroah.com>
	<4A6FBC6F.6040404@garzik.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Jul_2009_13_37_28_+1000_lr56nkY4KReQKOdg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jul_2009_13_37_28_+1000_lr56nkY4KReQKOdg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 28 Jul 2009 23:05:19 -0400 Jeff Garzik <jeff@garzik.org> wrote:
>
> FWIW, it's in libata-dev.git#upstream and libata-dev.git#NEXT, so=20
> linux-next should pick it up automatically.

It will be in tomorrow's tree (unless it is important enough for me to
grab it for today).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Jul_2009_13_37_28_+1000_lr56nkY4KReQKOdg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpvw/gACgkQjjKRsyhoI8y5fQCcDwcSUUOtknAv5hrXxtawD8b6
xVQAnioBnRNeZMVOLwnpH0trN0jaw6Pe
=bDNY
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jul_2009_13_37_28_+1000_lr56nkY4KReQKOdg--
