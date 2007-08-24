Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbXHXGHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbXHXGHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXHXGG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:06:56 -0400
Received: from armagnac.ifi.unizh.ch ([130.60.75.72]:39042 "EHLO
	albatross.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbXHXGGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:06:55 -0400
Date: Fri, 24 Aug 2007 08:06:45 +0200
From: martin f krafft <madduck@madduck.net>
To: linux-kernel@vger.kernel.org
Subject: Re: what does this mean: "kernel: 7.0.0.1:53 L=79 S=0x00 I=39869
	F=0x4000 T=64"
Message-ID: <20070824060645.GB18166@piper.oerlikon.madduck.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070823100045.GA18793@piper.oerlikon.madduck.net> <46CDA81C.4060705@ums.usu.ru> <20070823154244.GA15919@piper.oerlikon.madduck.net> <46CDBA3D.7040402@ums.usu.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <46CDBA3D.7040402@ums.usu.ru>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux lenny/sid kernel 2.6.22-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Alexander E. Patrakov <patrakov@ums.usu.ru> [2007.08.23.1847 +0=
200]:
> However, the style does look similar to a message in ipw2100.c:
>
> IPW_DEBUG_TX("TX%d V=3D%p P=3D%04X T=3D%04X L=3D%d\n", i,
>              &txq->drv[i],
>              (u32) (txq->nic + i * sizeof(struct ipw2100_bd)),
>              txq->drv[i].host_addr, txq->drv[i].buf_length);

This is not being used on the machine.

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
"never attribute to malice what can be
 adequately explained by incompetence."=20
                                                       -- mark twain
=20
spamtraps: madduck.bogus@madduck.net

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGznV1IgvIgzMMSnURApfcAJkBI2nT5FgCQhatlJ/+20slcBMRmACfR+oH
91ALnOv/cFwxId203yEV7FM=
=h6jP
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
