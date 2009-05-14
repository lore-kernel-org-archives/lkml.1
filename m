Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbZENGoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbZENGoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 02:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZENGoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 02:44:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38316 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZENGoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 02:44:00 -0400
Date: Thu, 14 May 2009 16:43:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH 01/15] asm-generic: rename termios.h, signal.h and
 mman.h
Message-Id: <20090514164355.36479995.sfr@canb.auug.org.au>
In-Reply-To: <20090514061623.GA27755@uranus.ravnborg.org>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de>
	<1242255398-23779-2-git-send-email-arnd@arndb.de>
	<20090514151107.5eae120e.sfr@canb.auug.org.au>
	<20090514061623.GA27755@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_May_2009_16_43_55_+1000_7zF23XSz3.cBFF04"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_May_2009_16_43_55_+1000_7zF23XSz3.cBFF04
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Thu, 14 May 2009 08:16:23 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> We have two Kbuild files in asm-generic.
>=20
> Kbuild (the one patched above) which specifies the files to be exported f=
rom asm-generic.
> Kbuild.asm which specify the commen set of files all architctures hall ex=
port.
>=20
> The latter is the file included from the arch's Kbuild file.

My mistake, thanks for the clarification.

/me cleans his glasses :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__14_May_2009_16_43_55_+1000_7zF23XSz3.cBFF04
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoLvasACgkQjjKRsyhoI8yJjgCfbI4RH1Hr5+kC7uGMO896rx1r
OnsAn34vBYUVCoB2DulLQqS9AIMQFLHd
=yMkA
-----END PGP SIGNATURE-----

--Signature=_Thu__14_May_2009_16_43_55_+1000_7zF23XSz3.cBFF04--
