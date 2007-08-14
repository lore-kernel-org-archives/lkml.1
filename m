Return-Path: <linux-kernel-owner+w=401wt.eu-S1765943AbXHNRDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765943AbXHNRDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759844AbXHNRCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:02:40 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:39059 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759147AbXHNRCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:02:38 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 00/12] 2.6.22-stable review
Date: Tue, 14 Aug 2007 19:02:33 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
References: <20070814072813.GA15025@kroah.com> <200708141813.34951.prakash@punnoor.de> <20070814160419.GA18195@suse.de>
In-Reply-To: <20070814160419.GA18195@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2691850.J4vzRuNBQT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708141902.33731.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2691850.J4vzRuNBQT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag 14 August 2007 schrieb Greg KH:
> On Tue, Aug 14, 2007 at 06:13:34PM +0200, Prakash Punnoor wrote:
> > Am Dienstag 14 August 2007 schrieb Greg KH:
> > > This is the start of the stable review cycle for the 2.6.22.3 release.
> >
> > You missed this one: http://lkml.org/lkml/2007/8/10/296
> >
> > The buggy patch was introduced in 2.6.22.2, so it wouldn't be bad to fix
> > in .3...
>
> I asked for clarification about that patch, if it is really needed and
> matters, yet did not recieve any response yet.

Well, I can't speak for the author, but I at least would find it disturbing=
 if=20
some random values would be written into random registers of my hardware,=20
when they were meant for a different hardware...

=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart2691850.J4vzRuNBQT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGweApxU2n/+9+t5gRAlLIAJ9x0sd9dg1fj3zgCuRW6gzd9nWjdACeKkcf
4jApx9ySpQ4PTOhI2l12pP8=
=b4PR
-----END PGP SIGNATURE-----

--nextPart2691850.J4vzRuNBQT--
