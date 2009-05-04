Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbZEDC1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbZEDC1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 22:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZEDC1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 22:27:43 -0400
Received: from mx40.mail.ru ([94.100.176.54]:56740 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZEDC1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 22:27:43 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Bank screen after resume on Dell XPS M1330
Date: Mon, 4 May 2009 06:27:35 +0400
User-Agent: KMail/1.11.90 (Linux/2.6.30-rc4-3avb; KDE/4.2.70; i686; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200905031111.50789.arvidjaar@mail.ru> <200905031543.28977.arvidjaar@mail.ru> <20090503115603.GA18880@srcf.ucam.org>
In-Reply-To: <20090503115603.GA18880@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart155182276.XudVx07yYg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905040627.36297.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart155182276.XudVx07yYg
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sunday 03 of May 2009 15:56:03 Matthew Garrett wrote:
> On Sun, May 03, 2009 at 03:43:28PM +0400, Andrey Borzenkov wrote:
> > On Sunday 03 of May 2009 14:59:32 Matthew Garrett wrote:
> > > On Sun, May 03, 2009 at 11:11:47AM +0400, Andrey Borzenkov wrote:
> > > > 01:00.0 VGA compatible controller: nVidia Corporation GeForce
> > > > 8400M GS (rev a1)
> > >
> > > We don't know how to reinitialise nvidia graphics hardware.
> >
> > Just in case - same issue also after resume from hibernation. I was
> > under impression, that hibernation does not have these issues as
> > card goes via normal POST routine.
>
> Hm. That sounds a bit weirder.
>

Is it worth further debugging? Anything I can provide?

> > Hmm ... this implies users of nVidia are locked to proprietary
> > driver if suspend is required?
>
> Right now, yeah.


--nextPart155182276.XudVx07yYg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn+UpgACgkQR6LMutpd94wl1ACfWsfMStDVFUjWCsgd+UbPrb5l
niwAn326aR1SH7qGX2heiLHeYZPBWqda
=qiAo
-----END PGP SIGNATURE-----

--nextPart155182276.XudVx07yYg--
