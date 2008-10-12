Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYJLIuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYJLIuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 04:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYJLIua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 04:50:30 -0400
Received: from server.drzeus.cx ([85.8.24.28]:50836 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751421AbYJLIu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 04:50:29 -0400
Date: Sun, 12 Oct 2008 10:50:21 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] atmel-mci: updates for 2.6.28
Message-ID: <20081012105021.46450333@mjolnir.drzeus.cx>
In-Reply-To: <20081005204617.14868dc4@hskinnemo-gx745.norway.atmel.com>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20081005204617.14868dc4@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-11809-1223801428-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-11809-1223801428-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 5 Oct 2008 20:46:17 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

>=20
> If you're happy with this patchset, could you please pull
>=20

Fairly happy. There is the one thing to fix with the clock, but as no
cards implement power control yet, you can send that patch later.

There's also the open issue of bytes_xfered. Please send a patch for
that ASAP (provided it just isn't a misunderstanding on my part :)).

>   git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/atmel-mci-2.6=
.28.git master
>=20
> instead of applying the patches? If you do that, I can pull it into my
> avr32 tree as well and fix up any conflicts. I won't do that before
> you've pulled it, of course, and it's probably best if no one base any
> further work on it until it's accepted because I might have to rebase
> it if someone finds any issues during review.

Pulled and will be sent to Linus just as soon as I have everything else
queued up.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-11809-1223801428-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjxulEACgkQ7b8eESbyJLgO+wCfb2R//6WRLuOfyJN8uX8h/YbL
cz8AoOuKH1rovwTm/akPxQuzZfV0xv7x
=x5Zo
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-11809-1223801428-0001-2--
