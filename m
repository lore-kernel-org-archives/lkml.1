Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYLFJxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYLFJxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 04:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYLFJxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 04:53:00 -0500
Received: from smtp12.mtu.ru ([62.5.255.41]:65197 "EHLO smtp12.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbYLFJw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 04:52:59 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Is vm86old no more implemented?
Date: Sat, 6 Dec 2008 12:52:43 +0300
User-Agent: KMail/1.10.90 (Linux/2.6.28-rc7-1avb; KDE/4.1.81; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200812061043.51438.arvidjaar@mail.ru> <87y6ytvg0s.fsf@basil.nowhere.org>
In-Reply-To: <87y6ytvg0s.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2993654.JqTGLJSHWp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812061252.51173.arvidjaar@mail.ru>
X-DCC-STREAM-Metrics: smtp12.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2993654.JqTGLJSHWp
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On =D0=A1=D1=83=D0=B1=D0=B1=D0=BE=D1=82=D0=B0 06 =D0=B4=D0=B5=D0=BA=D0=B0=
=D0=B1=D1=80=D1=8F 2008 11:56:03 Andi Kleen wrote:
> Andrey Borzenkov <arvidjaar@mail.ru> writes:
> > CONFIG_VM86 is defined; is there anything else that is needed? This fai=
ls
> > both in 2.6.27.7 and in 2.6.28-rc7. I attach config from 2.6.28-rc7.
>
> It should still work. Can you double check you're running the correct
> kernel? Perhaps a 64bit kernel (which doesn't implement it).
>

Linux cooker 2.6.28-rc7-1avb #23 Fri Dec 5 22:42:47 MSK 2008 i686 Pentium I=
II=20
(Coppermine) GNU/Linux

Anything else I can check?

--nextPart2993654.JqTGLJSHWp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk6S20ACgkQR6LMutpd94wV7gCg1WC0lNMQBYO1tp1mYQd89Bix
LnMAoI7yCq8UJhVnUVCPxfsa9noMGWI0
=7lQu
-----END PGP SIGNATURE-----

--nextPart2993654.JqTGLJSHWp--
