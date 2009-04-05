Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZDESpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZDESpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 14:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZDESpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 14:45:08 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:55906 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbZDESpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 14:45:07 -0400
Date: Sun, 5 Apr 2009 20:45:00 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andreas Mohr <andi@lisas.de>
Cc: Pavel Machek <pavel@suse.cz>, Andreas Mohr <andi@lisas.de>,
       Sriram V <vshrirama@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090405204500.103af5eb@mjolnir.ossman.eu>
In-Reply-To: <20090329162601.GA649@rhlx01.hs-esslingen.de>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com>
	<20090102102152.GA26603@rhlx01.hs-esslingen.de>
	<20090102172407.GD1555@ucw.cz>
	<20090329162601.GA649@rhlx01.hs-esslingen.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-21482-1238957101-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-21482-1238957101-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 29 Mar 2009 18:26:01 +0200
Andreas Mohr <andi@lisas.de> wrote:

>=20
> The least that should be done now is to drastically change this Kconfig
> description (mention that _both_ settings can be dangerous, and help
> people decide which one to use), to reflect current knowledge.
> I'd be willing to submit a patch... (--> Pierre, right?)
>=20

Right. And it probably needs a better description, yes. What should
also be clear is that one failure mode results in noisy corruption, and
the other in silent corruption (which is much worse IMO).

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-21482-1238957101-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknY/C4ACgkQ7b8eESbyJLjz1gCfVo/lIzN/eRe+Ddw8niy4VRRG
ZBcAoNerSDzREITDF+w3YyK1BeWKIa9j
=BVoI
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-21482-1238957101-0001-2--
