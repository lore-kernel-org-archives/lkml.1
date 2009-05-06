Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbZEFPzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbZEFPzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZEFPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:55:18 -0400
Received: from mx48.mail.ru ([94.100.176.62]:1808 "EHLO mx48.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbZEFPzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:55:16 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Bank screen after resume on Dell XPS M1330
Date: Wed, 6 May 2009 19:55:10 +0400
User-Agent: KMail/1.11.90 (Linux/2.6.29.1-desktop-4mnb; KDE/4.2.71; i686; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905031111.50789.arvidjaar@mail.ru> <200905040627.36297.arvidjaar@mail.ru> <20090505194902.GC1379@ucw.cz>
In-Reply-To: <20090505194902.GC1379@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1906020.MeLp7MIPMC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905061955.13161.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1906020.MeLp7MIPMC
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Tuesday 05 of May 2009 23:49:02 Pavel Machek wrote:
> On Mon 2009-05-04 06:27:35, Andrey Borzenkov wrote:
> > On Sunday 03 of May 2009 15:56:03 Matthew Garrett wrote:
> > > On Sun, May 03, 2009 at 03:43:28PM +0400, Andrey Borzenkov wrote:
> > > > On Sunday 03 of May 2009 14:59:32 Matthew Garrett wrote:
> > > > > On Sun, May 03, 2009 at 11:11:47AM +0400, Andrey Borzenkov=20
wrote:
> > > > > > 01:00.0 VGA compatible controller: nVidia Corporation
> > > > > > GeForce 8400M GS (rev a1)
> > > > >
> > > > > We don't know how to reinitialise nvidia graphics hardware.
> > > >
> > > > Just in case - same issue also after resume from hibernation. I
> > > > was under impression, that hibernation does not have these
> > > > issues as card goes via normal POST routine.
> > >
> > > Hm. That sounds a bit weirder.
> >
> > Is it worth further debugging? Anything I can provide?
>
> Try it with minimum config, init=3D/bin/bash? Switch to plain vga
> console?

As stated in my first mail, that is exactly what I started with :)

--nextPart1906020.MeLp7MIPMC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoBst4ACgkQR6LMutpd94zOlwCcCrgT0JnVmxd4H7WjV4aEeYp6
xsAAn0NnXVmg+s2+9X/Ea1isIZMs687y
=Ej9i
-----END PGP SIGNATURE-----

--nextPart1906020.MeLp7MIPMC--
