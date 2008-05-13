Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbYEMVoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbYEMVoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761456AbYEMVoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:44:39 -0400
Received: from virgo.iok.hu ([193.202.89.103]:55093 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761420AbYEMVoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:44:38 -0400
Date: Tue, 13 May 2008 23:44:35 +0200
From: Miklos Vajna <vmiklos@frugalware.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] x86: janitor work in bugs.c
Message-ID: <20080513214435.GR27724@genesis.frugalware.org>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org> <fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org> <87tzh17vy3.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4uQRTjNk52FNqRv"
Content-Disposition: inline
In-Reply-To: <87tzh17vy3.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4uQRTjNk52FNqRv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 13, 2008 at 11:09:24PM +0200, Andi Kleen <andi@firstfloor.org> wrote:
> We had a discussion recently that wrapping printk format strings
> is a bad idea. Don't do it please.

Sure, that makes sense. Given that Ingo already pointed it out, I sent a
corrected patch already. :)

--G4uQRTjNk52FNqRv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkgqC8MACgkQe81tAgORUJZuagCcCl6+JYUiJXoC/CQu06DCK0xU
AVQAl0LjPjlXpL2Xaqelr2Cpmo+boW4=
=fiau
-----END PGP SIGNATURE-----

--G4uQRTjNk52FNqRv--
