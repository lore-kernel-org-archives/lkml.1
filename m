Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZECLnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZECLnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 07:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZECLnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 07:43:37 -0400
Received: from mx48.mail.ru ([94.100.176.62]:22616 "EHLO mx48.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZECLng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 07:43:36 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Bank screen after resume on Dell XPS M1330
Date: Sun, 3 May 2009 15:43:28 +0400
User-Agent: KMail/1.11.90 (Linux/2.6.29.1-desktop-4mnb; KDE/4.2.70; i686; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200905031111.50789.arvidjaar@mail.ru> <20090503105932.GA18170@srcf.ucam.org>
In-Reply-To: <20090503105932.GA18170@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2381646.lJrR1rxrCr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905031543.28977.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2381646.lJrR1rxrCr
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Sunday 03 of May 2009 14:59:32 Matthew Garrett wrote:
> On Sun, May 03, 2009 at 11:11:47AM +0400, Andrey Borzenkov wrote:
> > 01:00.0 VGA compatible controller: nVidia Corporation GeForce 8400M
> > GS (rev a1)
>
> We don't know how to reinitialise nvidia graphics hardware.

Just in case - same issue also after resume from hibernation. I was=20
under impression, that hibernation does not have these issues as card=20
goes via normal POST routine.

Hmm ... this implies users of nVidia are locked to proprietary driver if=20
suspend is required?

--nextPart2381646.lJrR1rxrCr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn9g2AACgkQR6LMutpd94y6jQCdGMVHYtRHvMklQLz3QUAmNRAf
NNcAoL4CaNHMD7EmO7NCZN39G4uSM4vC
=UwEg
-----END PGP SIGNATURE-----

--nextPart2381646.lJrR1rxrCr--
